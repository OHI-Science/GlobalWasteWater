##############################################
##
## By Cascade Tuholske June 2020 
## cascade.tuholske@gmail.com
##
## Step 1 needs to be run twice
## first on N, then on FIO effluent outputs.
## Step 2 - 5 will run then be good to go. 
## 
##############################################

Run these .py scripts to calulate watershed 
& country-level zonal stats.

-- 01_raster_NoData_fix.py : This changes the no data values from the effluent_n and effluent_fio tifs produced earlier. Makes zonal stats run smoothly.
-- 02_mask_effluents.py : Masks inland watershed pixels for the zonal stats.
-- 03_Effluent_ZonalStats.py : Zonal stats in parallel on countries and watersheds. 
-- 04_Final_N_Data.py : makes final N data for watershed, pour points, and gdam boundaries 
-- 05_Top100.py : makes top 100 of N all, sep, open, sewer and FIO
-- 06_make_plume_pours.py : makes .shp file for plume models

**NOTE** 
Because the FIO data doesn't get mapped to pour points, be sure to copy interim/effluent_FIO_watersheds* and interim/effluent_FIO_countries_gdam* to /data/processed/FIO_effluent_output/ to make figures
