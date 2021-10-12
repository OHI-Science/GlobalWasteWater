#!/bin/bash
## First steps
## Make a directory to export all the html files to
mkdir docs
## Run the first script, which generates a base layer for our vectors (country limits)
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_world_vector_prep.Rmd"), , output_dir = here("docs"))'
####### CASCADE< INSERT REFERENCE TO RIVER AND URBAN RASTERS HERE ##########

## Sanitation factor directory
mkdir docs/1_sanfact
# Clean national sanitation factor data
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_sanfact", "1_clean_national_sanitation_factor_data.Rmd"), output_dir = here("docs", "1_sanfact"))'
# Calculate sanitation factors
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_sanfact", "2_calculate_sanitation_factors.Rmd"), output_dir = here("docs", "1_sanfact"))'
# Imputation for FIO
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_sanfact", "3_impute_sanitation_factors.Rmd"), output_dir = here("docs", "1_sanfact"))'
# Imputation for N
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_sanfact", "4_impute_nitrogen_factors.Rmd"), output_dir = here("docs", "1_sanfact"))'
# Rasterize the data for FIOs
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_sanfact", "5_pixel_level_sanitation_factors.Rmd"), output_dir = here("docs", "1_sanfact"))'
# Rasterize the data for N
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_sanfact", "6_pixel_level_n_factors.Rmd"), output_dir = here("docs", "1_sanfact"))'
# Rasterize infrastructure level for N
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "1_sanfact", "7_pixel_level_n_factors_infrastructure.Rmd"), output_dir = here("docs", "1_sanfact"))'


# Calories
mkdir docs/2_protein_intake
# Clean the national food table
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "2_protein_intake", "1_national_calories_table.Rmd"), output_dir = here("docs", "2_protein_intake"))'
# Extract information on protein consumption
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "2_protein_intake", "2_protein_gdp_data_collection.Rmd"), output_dir = here("docs", "2_protein_intake"))'
# Imputation for protein consumption
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "2_protein_intake", "3_protein_imputation.Rmd"), output_dir = here("docs", "2_protein_intake"))'
# Rasterize protein consumtpion
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "2_protein_intake", "4_rasterize_national_calories.Rmd"), output_dir = here("docs", "2_protein_intake"))'

# Now that all our base rasters are produced, we can go ahead and produce effluents (in the main directory)i6


# Effluent N for each infrastructure
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "3_N_effluent.Rmd"), output_dir = here("docs"))'
# Effluent FIO
Rscript -e 'library(rmarkdown); library(here); render(input = here("code", "4_FIO_effluent.Rmd"), output_dir = here("docs"))'

####### CASCADE< INSERT REFERENCE TO ZONAL STATS, PLUMES< OR ANYTHING RELEVANT HERE ##########