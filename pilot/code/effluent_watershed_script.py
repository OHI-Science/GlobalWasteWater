#!/usr/bin/python3
from rasterstats import zonal_stats, gen_zonal_stats
import numpy as np
import pandas as pd
import geopandas as gpd
import rasterio
import os

data_dir = "/home/shares/ohi/git-annex/land-based/wastewater"
intermediate_dir = os.path.join(data_dir, "intermediate_files")
basins_dir = os.path.join(data_dir, "basins_laea")
shps = [os.path.join(basins_dir, fn) for fn in os.listdir(basins_dir) if fn.endswith(".shp")]
effluent_fn = os.path.join(intermediate_dir, "effluent_density.tif")
output_fn = os.path.join(intermediate_dir, "effluent_watersheds.shp")

feature_list = []
for shp_fn in shps:
    watersheds = gpd.read_file(shp_fn).to_crs(epsg=4326)
    zs_feats = zonal_stats(watersheds, effluent_fn, stats="sum count", geojson_out=True)
    feature_list.extend(zs_feats)
    
zgdf = gpd.GeoDataFrame.from_features(feature_list, crs=watersheds.crs)
zgdf = zgdf.rename(columns={'sum': 'effluent'})
zgdf.effluent = zgdf.effluent.fillna(0)
zgdf.to_file(output_fn)
