# Steps to Run the Plumes
I recommend running the plumes using `screen` so that you can turn it on and leave it. <br>
By Cascade Tuholske June 2020 (cascade.tuholske@gmail.com). <br> <br>
NOTE: Update file paths accordingly. <br>
NOTE: old_output are plumes from Science/PNAS models, not ERL

1. Make sure pour_point data for each run (total N, treated, open & spetic) `make_plume_pours.py` from `05_zonal_stats` dir is completed. If not go run this in the geo conda environment in python 3 that you have used so far. You can likely skip this step because I have already done it. <br>

2. Make a new python2 conda env and install gdal. **Activate new python 2 env.** <br>

3. The ocean mask (/home/tuholske/wastewater/data/interim/ocean_masks/ocean_mask_landnull.tif) will work. But if it is not there, take the original ocean_mask.tif raster from the pilot and set the land values to nan and the ocean values to 1. You can find my python script in [scratch/cascade/cpt_OceanMask.ipynb](https://github.com/OHI-Science/wastewater/tree/master/scratch/cascade), though I think you can do this with gdal from the prompt too with this [.Rmd script](https://github.com/OHI-Science/wastewater/blob/master/pilot/code/ocean_mask.Rmd).

4. Update all file paths and output names in `01_run_plumes.sh` to match the desired plume run (total N, treated, open & spetic).  
5. Execute : `00_run_all.sh`

6. If needed, repeat steps 4 & 5 for each pourpoint file (tot_N, treated_N, septic_N, & open_N). 

**WorkFlow** 
* 00_run_all.sh : This runs all the steps below by calling *01_run_plumes.sh* which runs the steps below -- **be sure to update args in 01_run_plumes.sh & 05_mosaic.sh*** 

**Steps from 01_run_plumes.sh**
* 01_run_plumes.sh : this runs the following (**BE SURE TO UPDATE FILE PATHS & NAMES HERE BEFORE YOU RUN**)
  * 02_clean_pour_point_files.sh - clears out pour points from GRASS 
  * 03_clean_plumes.sh - clears out pour points from GRASS
  * 04_plume_buffer.py - plume buffer decay model <br>
  * 05_mosaic.sh - mosaics final tifs (**BE SURE TO UPDATE FILE PATHS & NAMES HERE BEFORE YOU RUN**)






