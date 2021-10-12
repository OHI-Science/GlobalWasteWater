##################################
#
#   Cascade Tuholske (cascade.tuholske@gmail.com)
#   June 2020
#
#   Code to stitch the plume output tifs all together.
#   Will be added to run_all.sh once I make sure it works. 
#
#   ALWAYS UPDATE FILE NAMES TO MATCH TREATMENT TYPE
#   
##################################
#!/bin/bash 

cd output_septic_N # ALWAYS UPDATE tif NAME
mkdir subsets
for i in  1 2 3 4 5 6 7 #### Check number of plume output tifs to make sure loop is long enough 
do
   printf "Starting $i \n"
   mkdir subsets/subset$i
   
   # move the tif files in batches of 10000
   mv `ls | head -10000` subsets/subset$i/
   
   # mosaic subset 
   cd subsets/subset$i/
   ../../../gdal_add.py -o global_effluent_2015_septic_N_sub$i.tif -ot Float32 plume_effluent_*.tif # ALWAYS UPDATE tif NAME
   printf "subset $i tif done \n"
   
   # move subset mosaic and go up
   mv global_effluent_2015_septic_N_sub$i.tif ../ # ALWAYS UPDATE tif NAME
   cd ../../
   pwd
   printf "\n Ending $i \n"
done
printf "Done Subsets \n"

# final mosaic
cd subsets
pwd
../../gdal_add.py -o global_effluent_2015_septic_N.tif -ot Float32 global_effluent_2015_septic_N*.tif # ALWAYS UPDATE tif NAME

printf "\n Final Tif Done"
# move final tif
# cp global_effluent_2015_open_N.tif home/tuholske/wastewater/data/processed/N_effluent_output/

