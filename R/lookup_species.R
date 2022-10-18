#' Match species origin, growth form and type
#'
#' @description lookup_species searches for matching species in a species look up table \code{species_lookup_data} for all observed species in the raw field data frame \code{raw_field data} and adds three new columns containing the \code{type}, \code{origin}, and \code{growth_form} of the matched species.
#' @param raw_field_data A data_frame of raw percentage cover counts at the quadrat level, grouped by transect. Should contain the columns: \code{transect_number},  \code{quadrat},           \code{species}, and  \code{percent_cover}.
#' @param species_lookup_data A data_frame containing a key column of species names in the format and associated value columns: \code{type}, \code{origin}, and \code{growth_form} of the matched species. The full list of species observed during a whole season's field work should be present in the \code{species} column.
#'
#' @return raw_field_data_w_species_type The new data frame containing the \code{type}, \code{origin}, and \code{growth_form} of the matched species.
#' @import dplyr
#' @export
#'
lookup_species <- function(raw_field_data, species_lookup_data) {
  raw_field_data_w_species_type <-
    raw_field_data %>%
    dplyr::left_join(.,species_lookup_data, by = "species")
  return(raw_field_data_w_species_type)
}