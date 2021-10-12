##################################
#
#   Re-wrote run_plumes work with run_all by Cascade Tuholske (cascade.tuholske@gmail.com)
#   June 2020, updated Feb 2021
#
#   BE SURE TO ACTIVATE Python2 conda env with gdal installed
#
#   BE SURE TO UPDATE FILE NAMES AND PATHS here and in run_plumes.sh and 05_mosaic.sh before launching this. 
#
#   I rewrote the plume work flow for ease of use for the next person.
#   Each run (Total N, treated, open, & septic) will require updated
#   directories and input pourpoint file names.
#
#   Use /wastewater/data/interim/ocean_masks/ocean_mask_landnull.tif
#   for plumes otherwise it will plume effluents inland for some reason
#   I do not fully understand. 
#   
##################################

#!/bin/bash 

## remote old grass session data
rm -r /home/tuholske/wastewater/data/processed/grassdata

## Launch GRASS GIS -- ALWAYS UPDATE ! ! !
grass -c /home/tuholske/wastewater/data/interim/ocean_masks/ocean_mask_landnull.tif /home/tuholske/Github/wastewater/code/06_plumes/grassdata_septic_N/ -e --exec sh 01_run_plumes.sh # ALWAYS UPDATE tif NAME

## Mosaic 1000 pour point test
#cd output

# python ../gdal_add.py -o global_effluent_2015_tot_N.tif -ot Float32 plume_effluent_*.tif # ALWAYS UPDATE tif NAME

## Mosaic all final tif files -- Be sure to update
#sh 05_mosaic.sh






