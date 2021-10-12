# Faster Plumes
By Cascade Tuholske, Feb 2021 

This updates Jared Kibele, April 2019 code to speed up the plume models. Use screen in bash to run this. 

**WorkFlow** 
* 00_run_all.sh : This runs all the steps below by calling *all.sh* which runs the steps below -- **be sure to update args in all.sh** 

**Steps from all.sh**
* 01_split_pour_load.py  : splits up the pour points into a bunch of smaller files and loads into GRASS
* 02_split_buffering.py  : runs the plumes on the pour points  with
  * run_subset_plumes.sh 
    * clean_pour_point_files.sh : cleans out old pourpour points from grass
    * python2 plume_buffer.py : runs the plumes
    * export_subset_plumes.sh : explores the plumes with
      * gdal_add.py



