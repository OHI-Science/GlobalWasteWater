#!/bin/bash
## This tries to run everything in one mapset sequentially. Might work but slow.

#clean up any previous pour points:
./clean_pour_point_files.sh

#Add the new pour points shapefile:
#v.in.ogr dsn="/var/cache/halpern-et-al/mnt/storage/marine_threats/impact_layers_2013_redo/impact_layers/work/land_based/201112/step6/output/global_plume_${YEAR}_1.shp" output=pours
#I'm just assuming the pour points are loaded into the mapset as pour already

#run the plume model
python2 plume_buffer.py pours effluent > ./output/plume_buffer.log

#export the rasters to tiff files
./export_plumes.sh
