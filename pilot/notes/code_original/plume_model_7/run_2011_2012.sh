#!/bin/bash
# brun@nceas.ucsb.edu, May 2015
# run_2011_2012.sh: combines the steps to do the plume model run

YEAR="2011_2012"

#clean up any previous raster
./clean_plumes.sh

#clean up any previous pour points:
./clean_pours.sh

#Add the new pour points shapefile:
#v.in.ogr dsn="/var/cache/halpern-et-al/mnt/storage/marine_threats/impact_layers_2013_redo/impact_layers/work/land_based/201112/step6/output/global_plume_${YEAR}_1.shp" output=pours
#v.in.ogr dsn="/var/cache/halpern-et-al/mnt/storage/marine_threats/impact_layers_2013_redo/impact_layers/work/land_based/201112/step6/output/global_plume_${YEAR}_2.shp" output=pours
#v.in.ogr dsn="/var/cache/halpern-et-al/mnt/storage/marine_threats/impact_layers_2013_redo/impact_layers/work/land_based/201112/step6/output/global_plume_${YEAR}_3.shp" output=pours
v.in.ogr dsn="/var/cache/halpern-et-al/mnt/storage/marine_threats/impact_layers_2013_redo/impact_layers/work/land_based/201112/step6/output/global_plume_${YEAR}_4.shp" output=pours

#run the plume model
python plume_buffer.py pours

#Creates and go in the ouput folderfor the specific year
mkdir output
mkdir output/${YEAR} 
cd output/${YEAR} #TO BE CHANGED Accordingly

#export the rasters to tiff files
./export_plumes.sh
