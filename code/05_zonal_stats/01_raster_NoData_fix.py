##############################################################################################################
####
####   Mask Effluents
####   By Cascade Tuholske June 2020
####
####   This script fixes the no data values 
####   in the effluent rasteres to speed up 
####   zonal stats processing
####
####   BE SURE TO SET DATA TYPE as N OR FIO
####
##############################################################################################################

#### Dependencies 
##############################################################################################################
import numpy as np
import pandas as pd
import geopandas as gpd
import rasterio
import matplotlib.pyplot as plt 

#### File Paths and FN
##############################################################################################################
DATA_IN = '../../data/'
DATA_TYPE = 'N' # FIO or N 
MASK_FN = DATA_IN+'interim/inlandwatersheds_mask.tif'

if DATA_TYPE == 'N':
    effluent_rsts = [DATA_IN+'interim/effluent_N.tif', DATA_IN+'interim/effluent_N_treated.tif', 
                     DATA_IN+'interim/effluent_N_septic.tif', DATA_IN+'interim/effluent_N_open.tif']

elif DATA_TYPE == 'FIO':
    effluent_rsts = [DATA_IN+'interim/effluent_FIO.tif']

else: 
    print('What data, N or FIO?')

#### Functions
##############################################################################################################
def rst_nd_fix(effluent_fn, mask_fn, out_fn):
    
    """Function opens effluent raster and fixes the 
    no data values 
    
        effluent_fn = effluent raster fn
        out_fn = file name out
    """
    
    # Open effluent raster
    rst = rasterio.open(effluent_fn)
    meta = rst.meta
    
    # change na values to zero
    band = rst.read(1)
    print("min is", band.min())
    band[band < 0] = 0 
    print("min is", band.min())
    
    print('band max is', band.max())

    #Save new data type and mask out
    with rasterio.open(out_fn, 'w', **meta) as dst:
        dst.write(band, 1)
    
    print('Done', out_fn)

#### Run it
##############################################################################################################

# Make masked rasters
for rst in effluent_rsts:
    
    # Get data type
    data = rst.split('interim/')[1].split('.')[0]
    print(data)

    # Raster Mask 64 
    print('Starting mask', rst)
    rst_out = DATA_IN+'interim/'+data+'_zero.tif'
    rst_nd_fix(rst, MASK_FN, rst_out)
    
    print('\n')

print('DONE!')