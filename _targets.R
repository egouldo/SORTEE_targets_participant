library(targets)
suppressPackageStartupMessages(library(tidyverse, quietly = TRUE))
tar_source("R/")
options(tidyverse.quiet=TRUE)
# Set target-specific options such as packages.
tar_option_set(packages = "tidyverse") #, debug = "analysis_data"

# End this file with a list of target objects.
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
             command = 
               build_summarised_field_data(
                 field_data,
                 species_classification_data,
                 site_management_data, 
                 0))
)
