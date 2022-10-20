# ------- Suggested Answer Function Definition for Task 02, Part I -------
# Replace the contents of file  `R/lookup_species.R` with the contents of this file:
lookup_species <- function(raw_field_data, species_lookup_data) {
  raw_field_data_w_species_type <-
    raw_field_data %>%
    dplyr::left_join(.,species_lookup_data, by = "species")
  # Non-Vegetation: Litter and Bare Ground, Lichen and Moss, Rock
  raw_field_data_w_species_type <-
    raw_field_data_w_species_type %>%
    dplyr::mutate(type = ifelse(species == "BG", "BG", type)) %>%
    dplyr::mutate(type = ifelse(species == "L", "L", type)) %>%
    dplyr::mutate(type = ifelse(species == "LM", "LM", type)) %>%
    dplyr::mutate(type = ifelse(species == "R", "R", type))
  return(raw_field_data_w_species_type)
}