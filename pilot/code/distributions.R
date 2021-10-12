library(tidyverse)
library(sf)

source('./code/file_names.R')

pp <- sf::read_sf(pour_points_fn)

classes <- c(0.0005, 0.05,0.10,0.25,0.50,0.75)

effl <- ifelse(pp$effluent == 0, NA, pp$effluent)

quants <- stats::quantile(sort(effl), probs=classes)
sink('./code/dist.log')
print(quants)
sink()

