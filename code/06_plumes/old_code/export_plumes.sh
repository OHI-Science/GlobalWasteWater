#!/bin/bash
#
# export_plumes.sh:
# -----------------
# Export plume rasters from current grass session to external tif files.
#
# March-April 2013, John Potapenko (john@scigeo.org)
# Modified April 2019, Jared Kibele (jkibele@nceas.ucsb.edu)
# Modified June 2020, Cascade Tuholske (cascade.tuholske@gmail.com)

# g.mlist type=rast pattern=plume_fert* > plume_raster.list
# g.mlist type=rast pattern=plume_pest* >> plume_raster.list

mkdir output 
cd output
rm *.*

g.list type=raster pattern=plume_effluent* > plume_raster.list

for i in `cat plume_raster.list`; do
  echo "Processing ${i}..."
  g.region rast=$i
  r.mapcalc "plume_temp = if(isnull(${i}),0,${i})"
  r.out.gdal --overwrite input=plume_temp output=$i.tif type=Float32
  g.remove -f type=raster name=plume_temp
done

## CPT NOTE: will need to run this individually on subsets of 10,000 or less files
../gdal_add.py -o global_effluent_2015_raw.tif -ot Float32 plume_effluent_*.tif


