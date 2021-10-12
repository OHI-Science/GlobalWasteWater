#!/bin/bash
#
# Jared Kibele, April 2019
# Updated Cascade Tuholske, Feb 2021

outdir=$1

HERE=`pwd`

cd $outdir

rm *.*

g.list type=raster pattern=plume_effluent* > plume_raster.list

for i in `cat plume_raster.list`; do
  echo "Processing ${i}..."
  g.region rast=$i
  r.mapcalc "plume_temp = if(isnull(${i}),0,${i})"
  r.out.gdal --overwrite input=plume_temp output=$i.tif type=Float32
  g.remove -f type=raster name=plume_temp
done

#python2 ../gdal_add.py -o global_effluent_2015_test1000.tif -ot Float32 plume_effluent_*.tif #CPT

cd $HERE
