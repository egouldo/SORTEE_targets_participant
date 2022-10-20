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

# Walk through the following examples
# Plot targets, not just dataframes
# tar_target(name = diversity_BG_plot,
#            command = plot_diversity_bare_ground(analysis_data)),
# Add code directly to targets script:
# tar_target(name = diversity_BG_fit,
#            command = lm(formula = IndigSpp_transect_t ~ BareGround_t,data = analysis_data)),
# Render reports!!           
# tarchetypes::tar_render(minimal_report,
#                         path = "materials/minimal_report.Rmd")
# )

