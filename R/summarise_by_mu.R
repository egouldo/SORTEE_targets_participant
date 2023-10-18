#' Summarise field data by transect over each management unit
#'
#' @param field_data_by_transect The raw field data with key variables summarised over all quadrats within each transect
#'
#' @param year an integer between 0 and 5 representing the \code{GrasslandBBN} time-slice to be parameterised from the field data stored within the case file.
#'
#' @return field_data_by_management_unit \code{data_frame} containing all the variables needed for updating the GrasslandBBN with a Netica Case File.
#' @export
#' @import dplyr
#'
#' @details Please ensure the following rows are supplied: \code{management_unit}, \code{BG_mean}, \code{E_mean}, \code{E_diversity}, \code{NF_diversity}, \code{management}, \code{years_since}. Note that if you are providing observations for Management period t0, the column \code{management} is still required. You can fill this character variable with \code{NA}, the function will remove it as necessary since there is no \code{t0} \code{management} period.
#'
summarise_by_mu <- function(field_data_by_transect, year = c(0:5)) {
  # Aggregate all replicate transect sampling for each key measure var
  # over each management_unit
  field_data_by_management_unit <-
    field_data_by_transect %>%
    dplyr::group_by(management_unit) %>%
    dplyr::summarise(BG_pc = mean(NG_mean),
                     E_pc = mean(E_mean),
                     E_diversity = mean(E_diversity),
                     NF_diversity = mean(NF_diversity)) %>%
    dplyr::mutate(Grassland_Condition = NA)
  # Rename variable names to node names
  year_char <- ifelse(year == 0, "", as.character(year))
  field_data_by_management_unit <-
    field_data_by_management_unit %>%
    tidyr::gather(variable, value, -management_unit) %>%
    dplyr::mutate(variable =
                    ifelse(variable == "BG_pc",
                           "BareGround",
                           ifelse(variable == "E_pc",
                                  "WeedCover",
                                  ifelse(variable ==
                                           "E_diversity",
                                         "WeedDiversity",
                                         ifelse(variable == "years_since",
                                                "years_Since", ifelse(
                                                  variable == "NF_diversity", "IndigSpp_transect", "Grassland_Condition")))))) %>%
    dplyr::mutate(time = paste0("t", year_char)) %>%
    tidyr::unite(variable, variable, time) %>%
    tidyr::spread(variable, value)
  
  #Reformat field data by transect
  field_data_by_transect <-
    field_data_by_transect %>%
    dplyr::select(management_unit,
                  management,
                  years_since) %>%
    dplyr::distinct() %>% #drop multiple entries for single MU
    dplyr::rename(Management = management, YearsSince = years_since) %>%
    tidyr::gather(variable, value, -management_unit) %>%
    dplyr::mutate(year = ifelse(variable == "Management", year - 1, year), year = as.character(year),
                  year = ifelse(year == 0, "",year),
                  time = paste0("t", year)) %>%
    dplyr::select(-year) %>%
    tidyr::unite(variable, variable, time) %>%
    dplyr::filter(variable != "Management_t-1") %>%
    tidyr::spread(variable, value)
  
  # Join original data back to field_data_by_management_unit,
  # excluding transect_number and measure variables
  # and collapsing management units with multiple entries (transects)
  # into single entries (1 summarised value per management unit)
  field_data_by_management_unit <-
    field_data_by_management_unit %>%
    dplyr::left_join(., field_data_by_transect)
  
  
  return(field_data_by_management_unit)
}