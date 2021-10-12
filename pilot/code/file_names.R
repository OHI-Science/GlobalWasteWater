library(magrittr)

## Data Directories
data_dir <- "/home/shares/ohi/git-annex/land-based/wastewater"
intermediate_dir <- file.path(data_dir, "intermediate_files")
output_dir <- file.path(data_dir, "output")

## Input Files (from outside sources and previous projects)
san_dat <- file.path(data_dir, "JMP_2017_WLD.xlsx")
# regions_2017_update evaluated, but not used
reg_fn <- file.path(data_dir, "regions_2017_update/regions_2017_update.shp")
gadm_fn <-  file.path(data_dir, "gadm36_shp/gadm36.shp")
pop_fn <- file.path(data_dir, "d2019/gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-rev10_2015_30_sec_tif/gpw_v4_population_density_adjusted_to_2015_unwpp_country_totals_rev10_2015_30_sec.tif")
pour_points_original_fn <- file.path(data_dir, "pour_points/global_plume_2007_2010.shp")

## Intermediate Files
sanit_factors_fn <- file.path(intermediate_dir, "country_sanitation_factors.csv")
world_vector_fn <- file.path(intermediate_dir, "world_vector.shp")
ff_raster_fn <- file.path(intermediate_dir, "ff_raster.tif")
effluent_fn <- file.path(intermediate_dir, "effluent_density.tif")
effluent_watersheds_fn <- file.path(intermediate_dir, "effluent_watersheds.shp")
pour_points_fn <- file.path(intermediate_dir, "pour_points.shp")
ocean_mask_fn <- file.path(intermediate_dir, "ocean_mask.tif")

## Output Files
hotspots_fn <- file.path(output_dir, "wastewater_hotspot.shp")

## Set Up Env Variables for Bash
# We're going to use bash code blocks to run gdal commands so I want
# these file paths accessible from bash. 

# get all defined variables that contain `_fn` or `_dat` in the variable name
fn_names <- ls(pattern="_fn|_dat")

# get a list of the paths defined by those variables
fn_paths <- parse(text=fn_names) %>% 
  sapply(eval) %>% 
  as.list()

# assign all caps versions of variable names
names(fn_paths) <- fn_names %>% stringr::str_to_upper()

# Set the evironment variables. Now `pop_fn` can be accessed
# in bash by `$POP_FN`
do.call(Sys.setenv, fn_paths)

