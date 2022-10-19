# ------ Suggested Answer to Task 01 -----
# Put this script inside the root directory ./ where the .Rproj file is located
library(targets)
library(readr)
tar_source("R/") #source *all* scripts in R/
tar_option_set(packages = c("dplyr"))
list(
  tarchetypes::tar_file_read(name = field_data,
                             command = "data/field_data_raw_2014.csv",
                             read = readr::read_csv(file = !!.x)),
  tarchetypes::tar_file_read(name = site_management_data,
                             command = "data/field_site_management_2014.csv",
                             read = readr::read_csv(file = !!.x)),
  tarchetypes::tar_file_read(name = species_classification_data,
                             command = "data/species_lookup_table.csv",
                             read = readr::read_csv(file = !!.x)),
  tar_target(name = analysis_data, 
             command = build_analysis_data(field_data,
                                           site_management_data,
                                           species_classification_data))
)
