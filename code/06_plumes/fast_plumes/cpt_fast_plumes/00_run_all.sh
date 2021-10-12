######################################################################################################
#
#   Re-wrote fast_plumes work with run_all by Cascade Tuholske (cascade.tuholske@gmail.com)
#   Feb 2021
#
#   BE SURE TO UPDATE FILE NAMES AND PATHS HERE AND IN all.sh BEFORE RUNNING THIS SCRIPT
#
#   I rewrote the plume work flow for ease of use for the next person.
#   Each run (Total N, treated, open, & septic) will require updated
#   directories and input pourpoint file names.
#
#   Be sure to have screen session started so you can log off while it runs!!! 
#
#   Be sure to conda geo runnning 
#   
######################################################################################################

#!/bin/bash

## remote old grass session data
rm -r /home/tuholske/wastewater/data/processed/grassdata

## Launch GRASS GIS and execute all.sh
grass -c /home/tuholske/wastewater/data/interim/ocean_masks/ocean_mask_landnull.tif /home/tuholske/wastewater/data/processed/grassdata/ -e --exec sh all.sh

