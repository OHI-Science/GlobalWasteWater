##############################################################################################################
####
####   Mask Effluents
####   By Cascade Tuholske June 2020
####
####   This script masks inland watersheds from the 
####   effluent rasters and makes geo tif
####   files to run the zonal stats on
####
##############################################################################################################

#### Dependencies 
##############################################################################################################
import numpy as np
import pandas as pd
import geopandas as gpd
import rasterio
import matplotlib.pyplot as plt 
from glob import glob

#### File Paths and FN
##############################################################################################################
DATA_IN = '/home/cascade/projects/wastewater/data/'
MASK_FN = DATA_IN+'interim/coastal_mask.tif'
effluent_rsts = glob(DATA_IN+'interim/*zero.tif')
print(effluent_rsts)
#### Functions
##############################################################################################################
def mask_effluent(effluent_fn, mask_fn, out_fn):
    
    """Function opens effluent raster and masks inland watershed pixels\
    Args:
        effluent_fn = effluent raster fn
        mask_fn = mask raster fn
        out_fn = file name out
    """
    
    # Open effluent raster
    rst = rasterio.open(effluent_fn)
    band = rst.read(1)
    
    # Update MetaData
    meta = rst.meta
    meta.update({'dtype' : 'float32'}) 
    
    # mask inland watersheds
    mask = rasterio.open(mask_fn).read(1)
#     mask[mask == 1] = 2 # revalue mask so inland watersheds are = 0 ### CPT 2020.06.19 - using coastl 
#     mask[mask == 0] = 1
#     mask[mask == 2] = 0
    
    band_out = band * mask
    band_out = band_out.astype('float32')
    
    print(band_out.max())

    #Save new data type and mask out
    with rasterio.open(out_fn, 'w', **meta) as dst:
        dst.write(band_out, 1)
    
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
    rst_out = DATA_IN+'interim/'+data+'_mask.tif'
    mask_effluent(rst, MASK_FN, rst_out)
    
    print('\n')

print('DONE!')