# Debugging Console Script - Task 2 INTERACTIVE EXAMPLE
# To be run in console after replacing `./_targets.R` with `./examples/_targets.R`
library(targets)
suppressPackageStartupMessages(library(tidyverse, quietly = TRUE))
tar_make()
tar_meta(fields = error, complete_only = TRUE)
tar_meta(fields = error, complete_only = TRUE) %>% 
  pull(error)

# --------- TARGETS DEBUG option -------
# ENSURE INSERT: tar_option_set(debug = "analysis_data") in _targets.R
#  R console
tar_make(callr_function = NULL, 
         names = any_of("analysis_data"), 
         shortcut = TRUE)
# Enter Browser
targets::tar_name() # Confirm running correct target

# In the debugger, the dependency targets of `analysis_data` are available in the current environment, and the global objects and functions are available in the parent environment.
ls() # What values have been parsed to target command arguments?
field_data
site_management_data
species_classification_data
ls(parent.env(environment())) # doesn't show up for me!
# target invokes function build_summarised_field_data, so we debug it
debug(build_summarised_field_data)
c # execute c to enter the functions calling environment. 
# Locate Error
tar_make(callr_function = NULL, 
names = any_of("analysis_data"), 
shortcut = TRUE)
c
debug(build_summarised_field_data) # is this necessary? yes bc starts new env.
debug(summarise_by_mu) 
# Hit Next until enter summarise_by_mu
# Locate Error

# Enter again, while in summarise_mu
field_data_by_transect %>%
dplyr::group_by(management_unit) 

field_data_by_transect %>%
  dplyr::group_by(management_unit) %>% 
  colnames

c("BG_mean", "E_mean", "E_diversity", "NF_diversity") %in%
  {field_data_by_transect %>%
  dplyr::group_by(management_unit) %>% 
  colnames}
# mean percent cover of bare ground per transect is missing 
# in field_data_by_transect object!

# Let's See what happens in `summarise_by_transect()`
# Locate Error again
tar_make(callr_function = NULL, 
         names = any_of("analysis_data"), 
         shortcut = TRUE)
debug(build_summarised_field_data)
c
debug(summarise_by_transect)
n
n
n
# For each quadrat, add percent cover of each plant functional group
field_data_by_quadrat %>%
dplyr::group_by(transect_number, quadrat, type) %>%
  dplyr::summarise(pc_type = sum(percent_cover))

# But why are there NA's??
field_data_by_quadrat %>%
  dplyr::group_by(transect_number, quadrat, type) %>%
  dplyr::summarise(pc_type = sum(percent_cover)) %>% 
  ungroup %>%  
  count(type) # We only have Exotics, Native Forbs, and Native Graminoids... what about non-vegetation elements?? BG, L, M etc? 
# Check that something weird isn't happening in summarise?
field_data_by_quadrat %>% 
  count(type)
# No, It's present in `field_data_by_quadrat`
# So there must be something happening earlier in `lookup_species`, which is the function that codes the 'type' of the individual observation...
# Let's restart R, remake, and debug
rstudioapi::restartSession()
tar_make(callr_function = NULL, 
         names = any_of("analysis_data"), 
         shortcut = TRUE)
debug(build_summarised_field_data)
c
# From
tar_visnetwork() # we know that `lookup_species` is called in `build_raw_dataset`
# So let's
debug(lookup_species)
n
n
# What's NOT in species lookup data, but present in raw_field_data??
raw_field_data %>%
  dplyr::anti_join(.,species_lookup_data, by = "species") %>% 
  count(species)
# So species_lookup data doesn't code the abiotic elements of the quadrat...
# Bare ground, Litter, Lichen and Moss, Rock
# We'll have to adapt our function to do that!
# Exit Debugging and Edit the File!

# remove debug from _targets.R
# restart R
# tar_make()
# tar_visnetwork()
# tar_read(analysis_data) %>% glimpse

