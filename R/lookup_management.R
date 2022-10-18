#' Match transect management history and other site-level information
#'
#' @param raw_field_data A data_frame of raw percentage cover counts at the quadrat level, grouped by transect. Should contain the columns: \code{transect_number},  \code{quadrat},           \code{species}, and  \code{percent_cover}.
#' @param management_lookup_data A data_frame containing site information for each transect \code{transect_number}. At minimum the columns \code{management} and \code{years_since} must be present (necessary for casefile creation to learn the GrasslandBBN). Other variables may be included for analysis if desired.
#'
#' @return raw_field_data_w_management The new data frame containing raw field data plus additional matched columns in \code{management_lookup_data}.
#' @export
#'
#' @import dplyr
#'
lookup_management <- function(raw_field_data, management_lookup_data) {
  # Live Vegetation
  raw_field_data_w_management <-
    raw_field_data %>%
    dplyr::left_join(.,management_lookup_data, by = "transect_number")
  # Non-Vegetation: Litter and Bare Ground, Lichen and Moss, Rock
  # raw_field_data_w_management <-
  #   raw_field_data_w_management %>%
  #   dplyr::mutate(type = ifelse(species == "BG", "BG", type)) %>%
  #   dplyr::mutate(type = ifelse(species == "L", "L", type)) %>%
  #   dplyr::mutate(type = ifelse(species == "LM", "LM", type)) %>%
  #   dplyr::mutate(type = ifelse(species == "R", "R", type))
  return(raw_field_data_w_management)
}