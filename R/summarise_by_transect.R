#' Summarise by quadrat data into per transect data with key variables for updating the GrasslandBBN
#'
#'
#' @return field_data_by_transect A data_frame containing a row for each surveyed transect. Measured variables are equivalent to the nodes in the GrasslandBBN, and include: \code{E_pc}, the mean percent cover of exotic species per transect; \code{BG_pc} mean percent area of Bare Ground for each transect; \code{NF_diversity}, the total number of native forbs in each transect; \code{E_diversity}, the total number of exotic species across each transect.
#'
#' @param field_data_by_quadrat A tidy dataframe grouped by transect number and quadrat with multiple entries for each quadrat under the variable \code{species}. The species column includes all species encountered within the quadrat, as well as non-living entities such as Bare Ground and Litter, and non-vascular life-forms including lichen and moss. Each \code{species} has a \code{type}, an \code{origin}, and \code{growth-form} attribute, listed under the respective variable columns. Information about each transect is also included under the variables: \code{date} of survey, \code{orientation} of transect, survey \code{assistant}, last \code{management} action, \code{burn_season} of the last fire, \code{years_since} last biomass removal, and \code{biomass_reduction_year}.
#' @export
#' @import dplyr
#' @import tidyr
#'
summarise_by_transect <- function(field_data_by_quadrat) {
  # Get percent_cover variables
  percent_cover_dat <-
    field_data_by_quadrat %>%
    dplyr::group_by(transect_number, quadrat, type) %>%
    dplyr::summarise(pc_type = sum(percent_cover)) %>%
    dplyr::filter(type == "BG" | type == "E" | type == "NG") %>%
    tidyr::spread(type, pc_type) %>%
    dplyr::group_by(transect_number) %>%
    dplyr::select(-quadrat) %>%
    dplyr::summarise_all(.funs = c("mean", "sd")) %>%
    tidyr::replace_na(., list(BG_mean = 0, E_mean = 0, NG_mean = 0, BG_sd = 0, E_sd = 0, NG_sd = 0))
  # Get diversity variables
  diversity_dat <-
    field_data_by_quadrat %>%
    dplyr::group_by(transect_number, type) %>%
    dplyr::summarise(n = n_distinct(species)) %>%
    dplyr::filter(type == "E" | type == "NF") %>%
    tidyr::spread(type, n) %>%
    dplyr::rename(NF_diversity = NF, E_diversity = E)
  # Get Management History and Site Info variables
  management_history_dat <-
    field_data_by_quadrat %>%
    dplyr::select(transect_number,
                  management,
                  years_since,
                  biomass_reduction_year,
                  size,
                  date,
                  orientation,
                  assistant,
                  management_unit) %>%
    dplyr::distinct()
  # Merge all data and return:
  field_data_by_transect <- dplyr::left_join(percent_cover_dat, diversity_dat) %>%
    dplyr::left_join(management_history_dat)
  return(field_data_by_transect)
}
