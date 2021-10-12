##################################################
##
##   Routine makes pourpoint file for plume models
##   this data frame is the same columes
##   as the pilot so it should run in GRASS just 
##   fine. I drop pourpoints with N < 1 for speed on
##   the plumes which will lead to slight differences
##   in the land-based totals and the plume totals. 
##
##   By Cascade Tuholske June 2020
## 
##
##################################################

import geopandas as gpd
import pandas as pd
import numpy as np

#### Open Data
DATA_IN = '../../data/'
N_PP_FN = DATA_IN+'processed/N_effluent_output/effluent_N_pourpoints_all.shp'
N_PP = gpd.read_file(N_PP_FN)
cols = ['tot_N', 'open_N', 'septic_N', 'treated_N']

for col in cols:
    
    #### Get columns - Total N 
    print(col)
    gdf = N_PP[['basin_id', col]].copy()
    gdf.rename(columns={col:'effluent'}, inplace=True)
    gdf['count'] = np.nan
    gdf['area'] = np.nan
    gdf['geometry'] = N_PP['geometry'].copy()
    gdf = gpd.GeoDataFrame(gdf)

    #### reproject
    gdf.crs = {'proj': 'moll', 'lon_0': 0, 'x_0': 0, 'y_0': 0, 'ellps': 'WGS84', 'units': 'm', 'no_defs': True}
    gdf_out = gdf.to_crs(epsg=4326)

    #### Drop N > 1 g
    print(len(gdf_out))
    gdf_out = gdf_out[gdf['effluent'] >= 1]
    print(len(gdf_out))

    #### save out
    fn_out = 'processed/N_effluent_output/effluent_N_pourpoints_plumes_'+col+'.shp'
    gdf_out.to_file(DATA_IN+fn_out)
    print('\n')
    
    #### save out test
    if col == 'tot_N':
        #### save out
        fn_out = 'processed/N_effluent_output/effluent_N_pourpoints_plumes_test1000.shp'
        gdf_out[:1000].to_file(DATA_IN+fn_out)
        print('test done')

