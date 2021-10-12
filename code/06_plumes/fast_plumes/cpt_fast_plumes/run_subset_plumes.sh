#!/bin/bash
## This tries to run everything in sets. Like lame parallel processing

pnt_shp_fn=$1

mkdir ./output
mkdir ./output/$pnt_shp_fn

#clean up any previous pour points:
sh ./clean_pour_point_files.sh

#Add the new pour points shapefile:
#v.in.ogr dsn="/var/cache/halpern-et-al/mnt/storage/marine_threats/impact_layers_2013_redo/impact_layers/work/land_based/201112/step6/output/global_plume_${YEAR}_1.shp" output=pours
#I'm just assuming the pour points are loaded into the mapset as pour already

#run the plume model
python2 plume_buffer.py $pnt_shp_fn effluent > ./output/$pnt_shp_fn/plume_buffer.log

#export the rasters to tiff files
sh ./export_subset_plumes.sh ./output/$pnt_shp_fn
