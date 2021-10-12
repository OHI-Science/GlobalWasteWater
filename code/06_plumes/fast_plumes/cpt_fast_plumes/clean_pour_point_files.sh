#!/bin/bash
#
# clean_pour_point_files.sh: removes pour_point rasters and vectors from current grass session

g.remove -f type=raster pattern=pours_*
g.remove -f type=vector pattern=pours_*
g.remove -f type=raster pattern=plume_effluent_*_*

