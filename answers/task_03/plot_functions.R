# ------ Answer to Task 3 ------
# Replace content in R/plotting_functions.R with content of this file:
plot_diversity_biomass_reduction_time <- function(summarised_data){
  summarised_data %>% 
    ggplot(aes(y = IndigSpp_transect_t, x = YearsSince_t)) +
    geom_point() +
    theme_bw()
}

plot_diversity_bare_ground <- function(summarised_data){
  summarised_data %>% 
    ggplot(aes(y = IndigSpp_transect_t, x = BareGround_t)) +
    geom_point() +
    theme_bw()
}
