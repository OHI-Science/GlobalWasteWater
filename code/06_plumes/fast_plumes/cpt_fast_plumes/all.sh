######################################################################################################
#
#   Re-wrote fast_plumes work with run_all by Cascade Tuholske (cascade.tuholske@gmail.com)
#   Feb 2021
#
#   BE SURE TO UPDATE FILE NAMES AND PATHS here and in run_plumes.sh before launching this. 
#
#   I rewrote the plume work flow for ease of use for the next person.
#   Each run (Total N, treated, open, & septic) will require updated
#   directories and input pourpoint file names.
#
#   Be sure to update the variables that are flagged below with 'UPDATE' each time
#
#   Be sure to have screen session started so you can log off while it runs!!! 
#
######################################################################################################

## Move the ocean mask null file to GRASS dir
cp /home/tuholske/wastewater/data/interim/ocean_masks/ocean_mask_landnull.tif /home/tuholske/wastewater/data/processed/grassdata/PERMANENT/

## Load ocean mask null into grass session -o flag ignores projection 
r.in.gdal /home/tuholske/wastewater/data/processed/grassdata/PERMANENT/ocean_mask_landnull.tif output='ocean'

## Step 1 - Split and the pour points
######################################################################################################
# file name of pourpoint shape file to split up
step='step1'
echo $step
filename="/home/tuholske/wastewater/data/processed/N_effluent_output/effluent_N_pourpoints_plumes_test1000.shp" # --- UPDATE

# num of rows of split files (with 1000 pp, 500 will make two new files w rows)
split_num=500 # --- UPDATE
python 01_split_pour_load.py $filename $split_num

## Step 2 - run the split plume buffers
######################################################################################################
step='step2'
echo $step 

# directory where 02_split_pour_load.py wrote the files 
directory="/home/tuholske/wastewater/data/processed/N_effluent_output/" # --- UPDATE

# pattern made from 02_split_pour_load.py 
filepattern="effluent_N_pourpoints_plumes_test1000_*.shp" # --- UPDATE
python2 02_split_buffering.py $directory $filepattern
