# ------- Suggested Answer Function Definition for Task 01 -------
# Put this script in "./R"
build_analysis_data <- function(raw_field_data, site_management_data, species_classification_data) {
  analysis_data <- 
    raw_field_data %>% 
    lookup_species(raw_field_data = ., 
                   species_lookup_data = species_classification_data) %>% 
    lookup_management(raw_field_data = .,
                      management_lookup_data = site_management_data) %>% 
    
    return(analysis_data)
}