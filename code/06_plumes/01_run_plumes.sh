##################################
#
#   Re-wrote by Cascade Tuholske (cascade.tuholske@gmail.com)
#   June 2020, Updated Feb 2021
#
#   I rewrote the plume work flow for ease of use for the next person.
#   Each run (openal N, open, open, & septic) will require updated
#   directories and input pourpoint file names.
#
#   Use /wastewater/data/interim/ocean_masks/ocean_mask_landnull.tif
#   for plumes otherwise it will plume effluents inland for some reason
#   I do not fully understand. 
#
#   This gets executed by run_all.sh
#   Be sure to update all file paths and names before executing run_all.sh -- see UPDATE!!!
#   
##################################

#!/bin/bash 

# clean up any previous pour points:
sh 02_clean_pour_point_files.sh

# clean up any previous pour points:
sh 03_clean_plumes.sh

# Move the ocean mask null file to GRASS dir
cp /home/tuholske/wastewater/data/interim/ocean_masks/ocean_mask_landnull.tif /home/tuholske/Github/wastewater/code/06_plumes/grassdata_septic_N/ # UPDATE!!!

# Load ocean mask null into grass session 
r.in.gdal /home/tuholske/Github/wastewater/code/06_plumes/grassdata_septic_N/ocean_mask_landnull.tif output='ocean' # UPDATE !!!

# Load pour points into grass session 
file="/home/tuholske/wastewater/data/processed/N_effluent_output/effluent_N_pourpoints_plumes_septic_N.shp" # UPDATE!!!
v.import -o $file output='pours'

# Run the plume model
python2 04_plume_buffer.py pours effluent > ./plume_buffer.log

## Code below is from export_plumes.sh
# Make export list
mkdir output_septic_N # UPDATE!!!
cd output_septic_N # UPDATE!!!

# Get the list of rasters
g.list type=raster pattern=plume_effluent* > plume_raster.list

# export the rasters 
for i in `cat plume_raster.list`; do
  echo "Processing ${i}..."
  g.region rast=$i
  r.mapcalc "plume_temp = if(isnull(${i}),0,${i})"
  r.out.gdal --overwrite input=plume_temp output=$i.tif type=Float32
  g.remove -f type=raster name=plume_temp
done

