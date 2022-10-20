# "_targets_batching.R"
# # Branching Over Files
# tar_make(script = "_targets_batching.R")
# tar_visnetwork(script = "_targets_batching.R")
# tar_meta("_targets_batching.R")
# tar_visnetwork(script = "_targets_batching.R")
# tar_make(callr_function = NULL, script = "_targets_batching.R")
library(targets) # for tar_files()
suppressPackageStartupMessages(library(tidyverse,quietly = TRUE))
library(tarchetypes)
options(tidyverse.quiet=TRUE)
tar_source("R/")
tar_option_set(packages = "tidyverse")


list(
  tarchetypes::tar_file_read(name = species_classification_data,
                             command = "data/species_lookup_table.csv",
                             read = readr::read_csv(file = !!.x)),
  tarchetypes::tar_files(field_data_files, 
            c("data/field_data_raw_2014.csv", 
              "data/field_data_raw_2015.csv")),
  tar_files( management_files, 
            c("data/field_site_management_2014.csv", 
              "data/field_site_management_2015.csv")),
  tar_target(field_data, 
             read_csv(field_data_files), 
             pattern = map(field_data_files)),
  tar_target(site_management_data,
             read_csv(management_files),
             pattern = map(management_files)),
  tar_target(name = analysis_data_batched,
             command =
               build_summarised_field_data(
                 field_data,
                 species_classification_data,
                 site_management_data,
                 0),
             pattern = map(field_data,site_management_data),
             iteration = "list")
)



