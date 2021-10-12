#!/bin/bash
#
# clean_plumes.sh: removes plume rasters from current grass session

g.list type=rast pattern=plume_pest* > plume_raster.list
g.list type=rast pattern=plume_fert* >> plume_raster.list

for i in `cat plume_raster.list`; do
  echo "Processing ${i}..."
  g.remove rast=$i
done
