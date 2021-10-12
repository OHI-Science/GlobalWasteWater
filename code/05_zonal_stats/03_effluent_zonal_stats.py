##############################################################################################################
####
####   Zonal Stats for Effluents
####   By Cascade Tuholske June 2020
####
##############################################################################################################

#### Dependencies 
##############################################################################################################
from rasterstats import zonal_stats, gen_zonal_stats
import numpy as np
import pandas as pd
import geopandas as gpd
import rasterio
import time
import multiprocessing as mp 
from multiprocessing import Pool
from glob import glob

# Files and File Paths
##############################################################################################################
DATA_IN = '../../data/'

# effluent rsts
EFFLUENT_RSTS = glob(DATA_IN+'interim/*zero_mask.tif')

# Functions
##############################################################################################################
def open_data():
    """ function opens data and feeds the datasets to functions that run the zonal stats.
    """

    # Open countries 
    #COUNTRIES_FN = DATA_IN+'interim/world_vector.shp' #- CPT 2020.06.25 running on gdam files
    COUNTRIES_FN = DATA_IN+'interim/gadm36_ISO3_dissolve.shp'
    COUNTRIES = gpd.read_file(COUNTRIES_FN)
    
    # Drop antactrica because it falls just outside the rasters
    COUNTRIES = COUNTRIES[COUNTRIES['ISO3'] != 'ATA']

    # coastal watersheds
    WATERSHEDS_FN = DATA_IN+'interim/watersheds_coastal.shp' 
    WATERSHEDS = gpd.read_file(WATERSHEDS_FN)
    
    CRS = {'proj': 'moll', 'lon_0': 0, 'x_0': 0, 'y_0': 0, 'ellps': 'WGS84', 'units': 'm', 'no_defs': True}
    
    # Check crs & reproject 
    print('watershed crs', WATERSHEDS.crs)
    print('country crs, ', COUNTRIES.crs)
    WATERSHEDS.crs = CRS # just sets to be set, not reprojected
    COUNTRIES = COUNTRIES.to_crs(CRS) # reproject if using gdam

    # Check crs
    print('watershed crs', WATERSHEDS.crs)
    print('country crs, ', COUNTRIES.crs, '\n')
    
    return COUNTRIES, WATERSHEDS

def zonal(rst_in, polys_in, out, do_stats): 
    """Function will run zonal stats on a raster and a set of polygons. All touched is set to True by default. 
    
    Args:
        rst_in = file name/path of raster to run zonal stats on
        polys = either list of shape files (watersheds) or single shape file (countries)
        out = file and path for shp and csv file
        do_stats = stats to use, see rasterstats package for documention, (use sume)

    """
    
    # Run Zonal Stats
    zs_feats = zonal_stats(polys_in, rst_in, stats= do_stats, geojson_out=True, all_touched=True)
        
    # Turn into geo data frame and rename column
    zgdf = gpd.GeoDataFrame.from_features(zs_feats, crs=polys_in.crs)
    zgdf = zgdf.rename(columns={'sum': 'effluent'})
    zgdf.effluent = zgdf.effluent.fillna(0)
    
    # Save out shape and CSV
    zgdf.to_file(out+'.shp')
    zgdf.to_csv(out+'.csv')

def run_zonal(rst):
    
    """function runs zonal stats on watersheds and country polygons, writen
    this way to run in parallel 
    Args:
        rst = raster to calc zonal stats on
    
    """
    # see which process is running
    print(mp.current_process())
    
    # open the datasets 
    COUNTRIES, WATERSHEDS = open_data()
    
    # Get raster name
    rst_data = rst.split('interim/')[1].split('_zero')[0]
    print('Started', rst_data)
    
    # Zonal on watersheds 
    geog = '_watersheds' # geography for naming files out 
    polys = WATERSHEDS.copy()
    fn_out = DATA_IN+'interim/'+rst_data+geog
    zonal(rst_in = rst, polys_in = polys, out = fn_out, do_stats = 'sum')
    print('Done', geog, fn_out)
    
    # Zonal on countries
    geog = '_countries' # geography for naming files out 
    polys = COUNTRIES.copy()
    fn_out = DATA_IN+'interim/'+rst_data+geog+'_gdam' #### - CPT 2020.06.25 running on gdam files
    zonal(rst_in = rst, polys_in = polys, out = fn_out, do_stats = 'sum')
    print('Done', geog, fn_out, '\n')

def parallel_loop(function, job_list, cpu_num):
    """Run the routine in parallel
    Args: 
        function = function to apply in parallel
        job_list = list of dir or fn to loop through 
        cpu_num = numper of cpus to fire  
    """ 
    
    start = time.time()
    pool = Pool(processes = cpu_num)
    pool.map(function, job_list)
    pool.close()

    end = time.time()
    print(end-start)

# Run Everything
##############################################################################################################
print(EFFLUENT_RSTS)
parallel_loop(run_zonal, EFFLUENT_RSTS, 5)