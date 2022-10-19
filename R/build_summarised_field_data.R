build_summarised_field_data <- function(raw_field_data,
                                        species_lookup_data,
                                        management_lookup_data, 
                                        year) {
  field_data_by_quadrat <- 
    build_raw_dataset(raw_field_data,
                      species_lookup_data,
                      management_lookup_data)
  
  field_data_by_transect <- 
    summarise_by_transect(field_data_by_quadrat)
  
  field_data_by_mu <- 
    summarise_by_mu(field_data_by_transect, year)
  
  return(field_data_by_mu)
} 