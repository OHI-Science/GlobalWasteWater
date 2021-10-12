# Wastewater

This is an inherently interdisciplinary work where Geographers, Environmental scientists, and Conservation scientists came together to bring the best of each discipline. As such, we also bring our own coding idiosyncrasies to the table, and you will find a combination of R, Python, and bash scripts in this repository. Neither of us is an expert on all languages, but we are all comfortable reading each others' code. We have done our best to document the repository, and structure it in an intuitive and language-agnostic way. This should help make it readable and, more importantly, reproducible.

Reference: to be added upon publication.

## Repository structure

The proposed repository structure (at least inside the `code` directory) is as follows:

- `_run all.sh` - "One shell script to run them all"

- `00_setup.R` - Set up script (installs packages, checks dependencies and all that, **must be created**)

- `01_file_names.R` - List of file names and pointers (I can modify the renv file so that this script is sourced on start-up of RStudio)

- `01_raster_vector_prep` - Containing ll python and R code to generate the required input spatial data (4 files):
   
   - `01_urban_rural.py` - This makes an urban/rural raster from the GHS-SMOD urban/rural land use types.
   
   - `02_inland_pourpoints_drop.py` - This finds the inland pourpoints/watersheds and drops them.
   
   - `03_river_raster.py` - This makes a raster at 1-km of major rivers (Hydrosheds data) and coastlines needed for the effluent rst.
   
   - `04_world_vector_prep` - Creates our base vector dataset

- `02_sanitation_factors` - Containing all code to clean, process, and create sanitation factors (FIO and N) (6 files):
   
   - `01_clean_national_sanitation_factor_data.Rmd` - Reads in raw `JMP_2019_WLD.xlsx` dataset to clean it
   
   - `02_calculate_sanitation_factors.Rmd` - Calculates the sanitation and nitrogen factors per our definition
   
   - `03_impute_sanitation_factors.Rmd` - Imputes sanitation factors for missing countries
   
   - `04_impute_nitrogen_factors.Rmd` - Imputes nitrogen factors for missing countries (Supplementary figures created here too)
   
   - `05_pixel_level_sanitation_factors.Rmd` - Rasterizes FIO factors
   
   - `06_pixel_level_n_factors_infrastructure.Rmd` - Rasterizes N factors

- `03_protein_intake` - Containing all code to clean, processes, and modify the protein intake data (4 files):

   - `01_national_calories_and_protein_table.Rmd` - Reads in the data and selects the protein and caloric intake we need

   - `02_protein_gdp_data_collection.Rmd` - Collects GDP information for the nations we have in the above

   - `03_protein_imputation.Rmd` - Imputes protein intake fo rmissing countries, based on GDP and population (supplementary figures created here too)

   - `04_rasterize_national_protein_intake.Rmd` - Rasterizes national protein intake

- `04_produce_effluents` - Contains files to create FIO and N effluents
   
   - `01_N_effluent.Rmd` - Produces Nitrogent effluen rasters

   - `02_FIO_effluent.Rmd` - Produces FIO effluent rasters

- `05_zonal_stats` - Contains python code to get zonal stats
   
   - `01_raster_NoData_fix.py` - This changes the no data values from the effluent_n `tifs` produced earlier. Makes zonal stats run smoothly.
   
   - `02_mask_effluents.py` - Masks inland watershed pixels for the zonal stats.
   
   - `03_effluent_zonal_stats.py` - Zonal stats in parallel on countries and watersheds.
   
   - `04_final_N_data.py` - Merge watershed and country effluent files together (**CASCADE** this used to be in `code/5_Final_N_Data.py` Can it live here, or does it have to go into `code/04_produce_efluents`?)
   
- `06_figures_scripts` - Contains all scripts to generate figures (**GORDON** can you take a look at these?)
   
   - Clean things up, there seem to be multiple `fig1_` versions and so.

- `07_plumes`?

- `08_web_map_map` - Code to generate the webmap

   - `01_color_rasters.sh` - Assigns a colorramp to the rasters

   - `02_create_tiles.sh` - Creates tiles of the rasters for different zoom levels

---------



























