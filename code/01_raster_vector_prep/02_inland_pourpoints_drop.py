##############################################################################################################
####
####   Pour Point Rst
####   By Cascade Tuholske June 2020
####
####   This script takes hydrosheds and hydrolakes polygons
####   to make a mask of land/water to mask outline pourpoints.
####   Inland pourpoints, are pour points that are >10 km from
####   a coastline. 
####
####   Note: this could be sped up by removing a lot of the
####   output functions that save rasters, but I want to be
####   able to view each step easily so I am leaving them in
####   for now. 
####
##############################################################################################################

#### Dependencies 
##############################################################################################################

import geopandas as gpd
import numpy as np
import pandas as pd
import rasterio 
import matplotlib.pyplot as plt
from shapely.geometry import Point
from multiprocessing import Pool, Queue, Process
import time 
import os
import multiprocessing as mp
from rasterio import features
from skimage.morphology import erosion
from skimage.morphology import dilation
from rasterstats import zonal_stats, gen_zonal_stats
from glob import glob

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
    
#### File Names and Paths & Arguments
##############################################################################################################

DATA_IN = '../../data/'
RST_FN = DATA_IN+'raw/GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0/GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0.tif' # Template to burn

#### Watersheds Raster 
##############################################################################################################

# Open watershed basins polygons and stack em
print('Starting watersheds')
basins_dir = glob(DATA_IN+'interim/basins_crs/*59004.shp')

# empty df to stack all the watershed polys
columns= (['ID','GRIDCODE','inspect','area','PNTPOLYCNT','basin_id','MWa_in_km2','geometry'])
watersheds = pd.DataFrame(columns = columns)

# Open watershed polys
for shp_fn in basins_dir:
    basins = pd.DataFrame(gpd.read_file(shp_fn))
    watersheds = watersheds.append(basins, sort = False)

watersheds.loc[:,'true'] = 1 # true column is 1 meaning there is an inland watershed there

# burn raster
fn_out = fn_out = DATA_IN+'interim/watersheds_mask.tif'
print('Burning Watershed')
burn_rst(RST_FN, watersheds, fn_out)
print('Watershed Rst Done')

#### Hydro Lakes Raster 
##############################################################################################################

# Open HydroLakes polys
print('Starting hydrolakes')
lakes_fn = DATA_IN+'raw/HydroLAKES_polys_v10_shp/HydroLAKES_polys_v10.shp'
lakes = gpd.read_file(lakes_fn)

# Reproject  to espg:59004
crs = {'proj': 'moll', 'lon_0' :0, 'x_0': 0, 'y_0' :0, 'datum': 'WGS84', 'units': 'm', 'no_defs' : True}
print(lakes.crs)
lakes = lakes.to_crs(crs) # switch crs
print(lakes.crs)

# Geodataframe
lakes = gpd.GeoDataFrame(lakes[['geometry']])
lakes.loc[:,'true'] = 1 # true column is 1 meaning there is an inland watershed there

# burn raster
fn_out = fn_out = DATA_IN+'interim/lakes_mask.tif'
print('Burning Lakes')
burn_rst(RST_FN, lakes, fn_out)
print('Lakes Rst Done')

#### Custom Polys Rst -- These polys were drawn manually in QGIS to remove mis-matched pixels w/
#### the lakes and rivers polys
##############################################################################################################

# Open watershed basins polygons and stack em
print('Starting custom')
polys_fn = DATA_IN+'interim/inland_water_custom_polys.shp'
polys = gpd.read_file(polys_fn)
polys.loc[:,'true'] = 1 # true column is 1 meaning there is an inland watershed there

# burn raster
fn_out = DATA_IN+'interim/custpolys_mask.tif'
print('Burning custom')
burn_rst(RST_FN, polys, fn_out)
print('custom Rst Done')

#### Merge Rivers and Lakes and Custom rasters
##############################################################################################################

print('merging all rasters - ocean/land')
# Open rasters
lake_rst_fn = DATA_IN+'interim/lakes_mask.tif'
river_rst_fn = DATA_IN+'interim/watersheds_mask.tif'
polys_rst_fn = DATA_IN+'interim/custpolys_mask.tif'

lake_rst = rasterio.open(lake_rst_fn)
river_rst = rasterio.open(river_rst_fn)
poly_rst = rasterio.open(polys_rst_fn)

# get bands
lake_arr = lake_rst.read(1)
river_arr = river_rst.read(1)
polys_arr = poly_rst.read(1)

# stack them
water_arr = lake_arr + river_arr + polys_arr 

# revalue to bianary
water_arr[water_arr > 0] = 1

# write raster
fn_out = 'interim/oceanland_mask.tif'
meta = lake_rst.meta # get meta
print('Burning oceanland')
with rasterio.open(DATA_IN+fn_out, 'w', **meta) as dst:
    dst.write_band(1, water_arr)
print('oceanland Rst Done')

#### Erode Coastline
##############################################################################################################

# open ocean/land rst
print('erode start')
fn_in = DATA_IN+'interim/oceanland_mask.tif'
rst = rasterio.open(fn_in)
mask = rst.read(1) # Load band 1 

# erode the coastline inward 10-km (tried with loop, did not work)
erode = erosion(mask) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km
erode = erosion(erode) # erode land in-ward by 1-km

# write out
meta = rst.meta # get meta
fn_out = 'interim/oceanland_mask-10km.tif'
with rasterio.open(DATA_IN+fn_out, 'w', **meta) as dst:
    dst.write_band(1, erode)
print('erode saved!')

#### Raster Stats to Find Inland PourPoints
##############################################################################################################
print('starting inland zonal stats')

#### Open pourpoints
PP_FN = 'raw/pour_points/global_plume_2007_2010.shp'
PP = gpd.read_file(DATA_IN+PP_FN)
PP = gpd.read_file(DATA_IN+PP_FN) # have to open PP twice, I have no clue why

# Run Zonal Stats
fn_in = 'interim/oceanland_mask-10km.tif'
oceanmask_fn = DATA_IN+fn_in # load 10-km eroded file

feature_list = [] # empty list for features

zs_feats = zonal_stats(PP, oceanmask_fn, stats="max", geojson_out=True, nodata = -999, all_touched=True)
feature_list.extend(zs_feats)
    
zgdf = gpd.GeoDataFrame.from_features(feature_list, crs=PP.crs)
zgdf = zgdf.rename(columns={'max': 'inland-coastal'}) # inland = 1, coastal = 0 

print('num pp is:', len(zgdf))

# make a value column to burn later & save points
zgdf[zgdf['inland-coastal'] == 1] 

# save
fn_out = 'interim/pourpoints_inland.shp'
zgdf.to_file(DATA_IN+fn_out)
print('inland pp saved as shapes')

#### Match inland PourPoints with Inland Watersheds & Burn Rst
##############################################################################################################
print('matching pp w/ watersheds')

# get inland pourpoints
inland_pp = zgdf[zgdf['inland-coastal'] == 1] 

# Isolate Inland
watersheds_inland = watersheds.merge(inland_pp['basin_id'], on = 'basin_id', how = 'inner')

# Back to GPD DF
watersheds_inland = gpd.GeoDataFrame(watersheds_inland)
print(type(watersheds_inland))
print('num inland watersheds is: ', len(watersheds_inland))

# Save them and plot them 
fn_out = DATA_IN+'interim/watersheds_inland.shp'
watersheds_inland.to_file(fn_out)
print('inland watersheds identified & and saved')

# burn raster
fn_out = fn_out = DATA_IN+'interim/inlandwatersheds_mask.tif'
print('Burning inland Watershed')
burn_rst(RST_FN, watersheds_inland, fn_out)
print('inlandwatersheds Rst Done')

#### Match coastal PourPoints with COASTAL Watersheds & Save 
##############################################################################################################
# get coastal pourpoints
coastal_pp = zgdf[zgdf['inland-coastal'] == 0] 

# Isolate Coastal watersheds
watersheds_coastal = watersheds.merge(coastal_pp['basin_id'], on = 'basin_id', how = 'inner')

# Back to GPD DF
watersheds_coastal = gpd.GeoDataFrame(watersheds_coastal)
print(type(watersheds_coastal))
print('num coastal watersheds is: ', len(watersheds_coastal))

# Save them and plot them 
fn_out = DATA_IN+'interim/watersheds_coastal.shp'
watersheds_coastal.to_file(fn_out)
print('coastal watersheds saved')

# burn raster
fn_out = fn_out = DATA_IN+'interim/coastal_mask.tif'
print('Burning Watershed')
burn_rst(RST_FN, watersheds_coastal, fn_out)
print('inlandwatersheds Rst Done')

#### All done
print('ALL DONE - YEW!')
