##############################################################################################################
####
####   Final Data
####   By Cascade Tuholske Feb 2021
####
####   Subset top 100 pour points for N (all, treated, sep, sewer) and FIO all
####   for final dataset.
####
####   MAKE SURE interim/effluent_FIO_watersheds.shp has been copied to processed/FIO_effluent_output/
####
##############################################################################################################

#### Dependencies
##############################################################################################################
import pandas as pd
import numpy as np
import geopandas as gpd

#### File Names and DIR
DATA_IN = '/home/cascade/projects/wastewater/data/'
PP_N_ALL_FN = 'processed/N_effluent_output/effluent_N_pourpoints_all.shp'
PP_N_ALL = gpd.read_file(DATA_IN+PP_N_ALL_FN)
FIO_WATERSHED_FN = 'processed/FIO_effluent_output/effluent_FIO_watersheds.shp'
FIO_WATERSHED = gpd.read_file(DATA_IN+FIO_WATERSHED_FN)

#### Subset Top 100 for FIO & Match to PP Location
##############################################################################################################
treat_type = 'effluent'
fn_out = 'processed/FIO_effluent_output/effluent_FIO_pourpoints_100.shp'
data_out = FIO_WATERSHED.sort_values(by = treat_type, ascending = False).head(100)
data_out = data_out[['basin_id','effluent']]
data_out.rename(columns={'effluent':'FIO_effluent'}, inplace=True)
data_out = gpd.GeoDataFrame(pd.merge(data_out, PP_N_ALL[['basin_id', 'geometry']], on = 'basin_id', how = 'inner'))
data_out['rank'] = list(range(1,101))
data_out.to_file(DATA_IN+fn_out)

#### Subset Top 100 N by Type
##############################################################################################################
treat_types = ['tot_N', 'septic_N', 'open_N', 'treated_N']

for treat_type in treat_types:

    fn_out = 'processed/N_effluent_output/effluent_N_pourpoints_'+treat_type+'100.shp'
    data_out = PP_N_ALL.sort_values(by = treat_type, ascending = False).head(100)
    data_out = data_out[['basin_id', 'geometry', treat_type]]
    data_out['rank'] = list(range(1,101))

    data_out.to_file(DATA_IN+fn_out)