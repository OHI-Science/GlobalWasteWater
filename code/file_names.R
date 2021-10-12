library(magrittr)

## Data Directories ####
# We use three directories to manage our data:
# folder with raw data
data_dir <- "/home/shares/ohi/git-annex/land-based/wastewater/data/raw"
# folder with data that has been cleaned but may be used as input
intermediate_dir <- "/home/shares/ohi/git-annex/land-based/wastewater/data/interim"
#folder with output data (i.e. results)
output_dir <- file.path("/home/shares/ohi/git-annex/land-based/wastewater/data/processed")

## Input Files (from outside sources and previous projects) ####
# We also have a series of files that are commonly called across the project. 
# We standardeize the read / write process by providing the direct path to each of these
san_dat_fn <- file.path(data_dir, "JMP_2019_WLD.xlsx") # Raw sanitation data report
calories_raw_fn <- file.path(data_dir, "food_balance.csv") # Raw food and caloric data
protein_gdp_fn <- file.path(data_dir, "protein_gdp.csv") # Raw protein and GDP for imputation
protein_gdp_imputed_fn <- file.path(data_dir, "protein_gdp_imputed.csv") # Imputed protein and GDP
reg_fn <- file.path(data_dir, "regions_2017_update/regions_2017_update.shp") # regions_2017_update evaluated, but not used
gadm_fn <-  file.path(data_dir, "gadm36_shp/gadm36.shp") #gadm political boundaries
eez_fn <- file.path(data_dir, "World_EEZ_v10_20180221/eez_v10.shp") #World exclusive Economic Zones
pour_points_original_fn <- file.path(data_dir, "pour_points/global_plume_2007_2010.shp") # Pour points of rivers
pop_fn <- file.path(data_dir, "GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0/GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0.tif") # Population raster
rural_urban_input_fn <- file.path(data_dir, "GHS_SMOD_POP2015_GLOBE_R2019A_54009_1K_V1_0/GHS_SMOD_POP2015_GLOBE_R2019A_54009_1K_V1_0.tif") #urban / rural raster
bouwman_raw_fn <- file.path(data_dir, "benchmark_bouwman_raw.txt") # Bowman data rom "Exploring changes in river nitrogen export to the world's oceans"
global_news_fn <- file.path(data_dir, "global_news.csv") # GLOBAL NEWS dataset from Mayorga et al 2010: https://www.sciencedirect.com/science/article/pii/S1364815210000186#!
# Watersheds come from 'basins_laea' --> implemented as a file list so no need for individual file names

## Intermediate Files
# These files are either produces by cleaning scripts, or part of a larger process.
# For example, pixel-level sanitation factors are intermediate files, that will be used
# when calculating total effluent.
gadm_dissolve_fn <- file.path(intermediate_dir, "gadm36_ISO3_dissolve.shp") # political boundaries with dissolved withincountry boundaries
world_vector_fn <- file.path(intermediate_dir, "world_vector.shp") # This combines gadm_dissolve and EEZs, and is our MAIN political boundary file
ocean_mask_fn <- file.path(intermediate_dir, "ocean_masks/ocean_mask_landnull.tif") # Ocean mask, see README in dir
rural_urban_binary_fn <- file.path(intermediate_dir, "rural_urban.tif")
#FIO data
san_dat_clean_fn <- file.path(intermediate_dir, "clean_sanfac_2019.csv") #clean sanitation database
sanit_factors_fn <- file.path(intermediate_dir, "country_sanitation_factors.csv") # country level sanitation factors for urban and rural
sanit_factors_impute_fn <- file.path(intermediate_dir, "imputed_country_sanitation_factors.csv") # Same as above, but with KNN imputation for missing values
sf_raster_rural_urban_fn <- file.path(intermediate_dir, "sf_raster_rural_urban.tif") # Pixel-level fudge factors that account for urban rural

# NITROGEN data
## Tabular
### N factors
nitrogen_factors_fn <- file.path(intermediate_dir, "nitrogen_factors.csv") # Nitrogen removal factors to be rasterized
nitrogen_factors_imputed_fn <- file.path(intermediate_dir, "nitrogen_factors_imputed.csv") # Imputed N removal factors
## Spatial
### N factors
nitrogen_factors_raster_fn <- file.path(intermediate_dir, "nitrogen_factors_raster.tif") # Nitrogen removal factors for all
nitrogen_factors_open_raster_fn <- file.path(intermediate_dir, "nitrogen_factors_open_raster.tif") # Nitrogen removal factors for open
nitrogen_factors_septic_raster_fn <- file.path(intermediate_dir, "nitrogen_factors_septic_raster.tif") # Nitrogen removal factors for septic
nitrogen_factors_treated_raster_fn <- file.path(intermediate_dir, "nitrogen_factors_treated_raster.tif") # Nitrogen removal factors for treated
### Protein consumption
protein_g_cap_year_raster_fn <- file.path(intermediate_dir, "protein_g_cap_year_raster.tif") # Rasterized protein intake

# Benchmarking
global_news_clean_fn <- file.path(intermediate_dir, "global_news_clean.shp") # Clean version of the same file, but as a spatial object
global_news_buffer_fn <- file.path(intermediate_dir, "global_news_buffer.shp") # Clean version of the same file, but as a spatial object
benchmarking_N_with_percentages_fn <- file.path(intermediate_dir, "benchmarking_N_with_percentages.shp")
bouwman_fn <- file.path(intermediate_dir, "bouwman_clean.csv") # Clean Bouwman data

# Final River masks 
riv_15s_coastlines_fn <- file.path(intermediate_dir, "riv_15s_coastlines.tif") # Hydroshed 30s rivers, lakes, and coastlines as binary 1-km

#################################################################################################################
# Pixel-level effluent data
#################################################################################################################
## General
effluent_FIO_fn <- file.path(intermediate_dir, "effluent_FIO.tif") # SF * pop
effluent_N_fn <- file.path(intermediate_dir, "effluent_N.tif") # future N output file
effluent_N_log10_fn <- file.path(intermediate_dir, "effluent_N_log10.tif") # N output file, in log-10 transformed
## Infrastructure-specific
effluent_N_open_fn <- file.path(intermediate_dir, "effluent_N_open.tif") # N efflient for open
effluent_N_septic_fn <- file.path(intermediate_dir, "effluent_N_septic.tif") # N efflient for septic
effluent_N_treated_fn <- file.path(intermediate_dir, "effluent_N_treated.tif") # N efflient for treated
## Infrastructure-specific and log-10 transformed for webmap
effluent_N_open_log10_fn <- file.path(intermediate_dir, "effluent_N_open_log10.tif") # N efflient for open
effluent_N_septic_log10_fn <- file.path(intermediate_dir, "effluent_N_septic_log10.tif") # N efflient for septic
effluent_N_treated_log10_fn <- file.path(intermediate_dir, "effluent_N_treated_log10.tif") # N efflient for treated
#################################################################################################################

#### MUST KEEP MODYFING BELOW ONCE WE REACH THESE ###
effluent_watersheds_fn <- file.path(intermediate_dir, "effluent_watersheds.shp") # Watershed boundaries for zonal stats
pour_points_fn <- file.path(intermediate_dir, "pour_points.shp")

## Output Files
FIO_pourpoints_fn <- file.path(output_dir, "FIO_pourpoints_final.shp") # all pour point totals
N_pourpoints_fn <- file.path(output_dir, "N_effluent_output", "effluent_N_pourpoints.shp") # all pour point totals (l, m, h) log10
N_pourpoints_500_fn <- file.path(output_dir, "N_effluent_output", "effluent_N_pourpoints_500.shp") # top 500 pour poitns


FIO_pourpoints = file.path(output_dir, "FIO_effluent_output/FIO_pourpoints_final.shp") # all pour point totals
N_pourpoints = file.path(output_dir, "N_effluent_output/N_pourpoints_final.shp") # all pour point 
FIO_plume = file.path(output_dir, "FIO_effluent_output/FIO_global_plume_effluent_2015.tif") # global FIO plume .tif
N_plume = file.path(output_dir, "N_effluent_output/N_global_plume_effluent_2015.tif") # global FIO plume .tif
N_plume_log10 = file.path(output_dir, "N_effluent_output/N_global_plume_effluent_2015_log10.tif") # global FIO plume .tif

hotspots_fn <- file.path(output_dir, "wastewater_hotspot.shp")

## Set Up Env Variables for Bash
# We're going to use bash code blocks to run gdal commands so I want
# these file paths accessible from bash. 

# get all defined variables that contain `_fn` or `_dat` in the variable name
fn_names <- ls(pattern="_fn|_dat")

# get a list of the paths defined by those variables
fn_paths <- parse(text = fn_names) %>% 
  sapply(eval) %>% 
  as.list()

# assign all caps versions of variable names
names(fn_paths) <- fn_names %>% stringr::str_to_upper()

# Set the evironment variables. Now `pop_fn` can be accessed
# in bash by `$POP_FN`
do.call(Sys.setenv, fn_paths)

