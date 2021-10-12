#!/bin/bash
#
# export_plumes.sh:
# -----------------
# Export plume rasters from current grass session to external tif files.
#
# March-April 2013, John Potapenko (john@scigeo.org)

g.mlist type=rast pattern=plume_fert* > plume_raster.list
g.mlist type=rast pattern=plume_pest* >> plume_raster.list

for i in `cat plume_raster.list`; do
  echo "Processing ${i}..."
  g.region rast=$i
  r.mapcalc "plume_temp=if(isnull(${i}),0,${i})"
  r.out.gdal --overwrite input=plume_temp output=$i.tif type=Float32
  g.remove rast=plume_temp
done
