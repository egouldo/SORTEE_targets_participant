#' Build raw field data set complete with species type and management history data
#'
#' @details This is an internal function for building the paper vignette with the Remake package
#' @param raw_field_data Data frame of un-processed raw field data. Observations at quadrat level.
#' @param species_lookup_data Path to the CSV file containing the species lookup data see \code{\link{lookup_species}}.
#' @param management_lookup_data Path to the CSV file containing the management lookup data, see \code{\link{lookup_management}}.
#' @return field_data_by_quadrat This is the complete field dataset in raw form containing both management history for each transect, as well as the type code for each species (i.e. row in the dataset). Individual observations of species cover are organised into quadrats, transects, management units, respectively.
#' @import readr
#' @export
#'
build_raw_dataset <- function(raw_field_data,species_lookup_data,management_lookup_data) {
  field_data_by_quadrat <-
    lookup_species(raw_field_data = raw_field_data,# lookup species
                                      species_lookup_data = species_lookup_data) %>% 
    lookup_management(raw_field_data = .,# lookup management
                                         management_lookup_data = management_lookup_data)
  return(field_data_by_quadrat)
}

