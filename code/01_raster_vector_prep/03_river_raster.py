#################################################################
##
##  Code to turn river line strings from HydroSheds into bianary raster
##  in the same resolution and crs (EPSG:54009) at 1km res as other data.
##  Next it takes the ocean-land mask to merge it with the
##  coastline
##
##  Built with conda env geo37
##
##  By Cascade Tuholske 2019-10-16 (Update June 2020)
##
#################################################################

# Dependencies 
##############################################################################################################
from glob import glob
import numpy as np
import rasterio 
from rasterio import features
import pandas as pd
import geopandas as gpd
import os
from skimage.morphology import erosion

# Files and File Paths
##############################################################################################################
DATA_IN = '../../data/'

#### Functions
##############################################################################################################

def burn_rst(rst_in, polys, fn_out):
    """ Function burns polygons into a bianary raster, polys must have a value column labeled 'true'
    Args:
        rst_in = file path to raster for template
        polys = polygons to burn int, values column must be labeled 'true'
        fn_out = file path for burned raster
    """
    
    # Get array as template
    rst = rasterio.open(rst_in)
    out_arr = rst.read(1) # get an array to burn shapes
    out_arr.fill(0) # revalue rst to an Nan Value before burning in polygons
    out_arr = out_arr.astype('uint8') # change dtype for file size
    
    # Update Meta Data
    meta = rst.meta
    meta['dtype'] = "uint8"
    meta['nodata'] = 99 # NA as 99
    
    # extract geom and values to burn
    shapes = ((geom,value) for geom, value in zip(polys['geometry'], polys['true']))

    # burn shapes intp an array
    burned = features.rasterize(shapes=shapes, fill=0, out=out_arr, transform=rst.transform, all_touched=True)

    # write our raster to disk
    with rasterio.open(fn_out, 'w', **meta) as out:
        out.write_band(1, burned)

    print(fn_out + "  saved!")

# Make Coastline Rst
##############################################################################################################
print('starting coastline rst')
rst_in = DATA_IN+'interim/oceanland_mask.tif'
rst = rasterio.open(rst_in)

# erode by 1-km 
arr = rst.read(1)
arr_eroded = erosion(arr) 

# add them together and revalue
coast_arr = arr+arr_eroded

# 0 = ocean, 1 = coastline, 2 = land
coast_arr[coast_arr == 2] = 0

# write it out
meta = rst.meta
crs = rst.crs # get CRS for later 
rst_out = DATA_IN+'interim/coastline.tif'
with rasterio.open(rst_out, 'w', **meta) as dst:
    dst.write_band(1, coast_arr)
print('coastline rst done')

# Open Hydrosheds River & Burn as a Raster
##############################################################################################################
print('starting river rst')
polys_fn = DATA_IN+'raw/HydroRIVERS_v10_shp/HydroRIVERS_v10_shp/HydroRIVERS_v10.shp' # 15-arc second 
polys_gdp = gpd.read_file(polys_fn)

# add column for burning
polys_gdp['true'] = 1

# switch crs
polys_gdp_crs = polys_gdp.to_crs(rst.crs)

# Burn River Raster 
rst_out = DATA_IN+'interim/river_rst.tif'
burn_rst(rst_in = rst_in, polys = polys_gdp_crs, fn_out = rst_out)
print('river rst done')

# merge river rst and coastline rst 
##############################################################################################################
print('starting coastline-river rst')
riv_arr = rasterio.open(rst_out).read(1)
coast_riv = riv_arr+coast_arr

# revalue case of overlaop
coast_riv[coast_riv > 0] = 1

rst_out = DATA_IN+'interim/riv_15s_coastlines.tif'
with rasterio.open(rst_out, 'w', **meta) as dst:
    dst.write_band(1, coast_riv)
print('River-coastline rst is done - ALL DONE')
