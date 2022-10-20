# plotting functions
plot_diversity_biomass_reduction_time <- function(summarised_data){
summarised_data %>% 
  ggplot(aes(y = IndigSpp_transect_t, x = YearsSince_t)) +
  geom_point() +
  theme_bw()
}

plot_diversity_bare_ground <- function(summarised_data){
  # WILL ERROR!!
  my_data %>% 
    ggplot(aes(y = IndigSpp_transect_t, x = BareGround_t)) +
    geom_point() +
    theme_bw()
}
