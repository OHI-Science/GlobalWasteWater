#################################################################
##
##  Code to turn GHS-MOD into an urban rural/raster, 
##  see https://ghsl.jrc.ec.europa.eu/download.php?ds=smod
##  Note, that the files I am working with right now crs 
##  is in World Mollweide (EPSG:54009) at 1km spatial res.
##
##  Built with conda env geo37
##  
##  By Cascade Tuholske 2019-09-26
##
#################################################################

# Dependencies
import rasterio
import pandas as pd
import numpy as np
import geopandas as gpd
from matplotlib import pyplot

# File Paths --- See file_names.R in the Git Repo, currently set for local machine
DATA_IN = '../../data/raw/'
DATA_OUT = '../../data/interim/'

# Files
pop2015_fn = 'GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0/GHS_POP_E2015_GLOBE_R2019A_54009_1K_V1_0.tif'
smod2015_fn = 'GHS_SMOD_POP2015_GLOBE_R2019A_54009_1K_V1_0/GHS_SMOD_POP2015_GLOBE_R2019A_54009_1K_V1_0.tif'

# Open files
pop2015 = rasterio.open(DATA_IN+pop2015_fn)
smod2015 = rasterio.open(DATA_IN+smod2015_fn)

# Check Meta Data
print(pop2015.meta)
print(smod2015.meta)

# get arrays
smod_arr = smod2015.read(1)

# Look up SMOD classes 
# Classes 30 – 23 – 22 – 21 if aggregated form the “urban domain”, 13 – 12 – 11 form the “rural domain”, 10 is WATER
# See GHS WhitePaper for info: https://ghsl.jrc.ec.europa.eu/documents/GHSL_Data_Package_2019.pdf?t=1478q532234372
np.unique(smod_arr)

# Make masks
# Codes: -200 = NaN, 10 = Water, 111 = Rural, 222 = Urban

# rural set to 1, urban set to 2
smod_arr[(smod_arr > 10) & (smod_arr < 21)] = 111  # RURAL 
smod_arr[(smod_arr >= 21) & (smod_arr < 111)] = 222 # URBAN 

print(np.unique(smod_arr))

def raster_write(meta, array, file_out):
    """ function to write out a raster file with an np array
    requires meta data for raster, np array & file out path and name

    Args
        meta = meta data for out raster
        array = array to write out as raster
        file_out = file name to write out
    """
    
    kwargs = meta

    # Update kwargs (change in data type)
    kwargs.update(dtype=rasterio.float32, count = 1)

    with rasterio.open(file_out, 'w', **kwargs) as dst:
        dst.write_band(1, array.astype(rasterio.float32))

# Get meta
meta = smod2015.meta

# Set file name
out_fn = smod2015_fn = DATA_OUT+'GHS_SMOD_POP2015_GLOBE_R2019A_54009_1K_V1_0_Urban-Rural.tif'

# raster_write(meta, smod_arr, out_fn)
