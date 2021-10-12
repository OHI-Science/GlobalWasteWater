##############################################################################################################
####
####   Final Data
####   By Cascade Tuholske June 2020
####
####   Merge watershed and country effluent files together
####   for final dataset.
####
####   UPDATED for GDAM CPT 2020.06.25
##############################################################################################################

# Dependencies 
##############################################################################################################
import pandas as pd
from glob import glob
import geopandas as gpd
import numpy as np

# Files and File Paths
##############################################################################################################
DATA_IN = '../../data/'

# Functions
##############################################################################################################
def dir_n_files():
    
    "Get file paths for countries_gdam and watersheds, open pourpoints"
    
    countries_gdam = glob(DATA_IN+'interim/effluent_N*countries_gdam.shp')
    watersheds = glob(DATA_IN+'interim/effluent_N*watersheds.shp')
    pp = gpd.read_file(DATA_IN+'raw/pour_points/global_plume_2007_2010.shp')
    
    return countries_gdam, watersheds, pp 

def merge_data(shps_list, geog, col):
    """ Function merges effluent columns and calc pct N of total. FIO is already done. 
    Args:
        shps_list = list of file paths to shapes
        geog = watersheds or countries_gdam as a str
        col = column label for merge('basin_id for watersheds or 'poly_id' for countries_gdam)
    """

    print(geog)
    # empty df to fill 
    df = pd.DataFrame()
    counter = 0
    
    for i, shp in enumerate(shps_list): 

        # get data type
        data = shp.split('interim/effluent_N_')[1].split(geog+'.shp')[0]
        data = data+'N'

        # rename watersheds column tot total
        if data == 'N':
            data = 'tot_N'
        print(data)

        # open data
        gdf = gpd.read_file(shp)
        gdf.rename(columns={'effluent': data}, inplace=True)
        
        # Account for N Retention Based on Beusen 2016 doi:10.5194/bg-13-2441-2016 
        # 43% retained in surface water, 57% exported to ocean 
        gdf[data] = gdf[data] * 0.57
    
        # add columns to gdf 
        if geog == 'countries_gdam':
            gdf['poly_id'] = list(range(len(gdf)))
            
        # populate df for merge
        if counter == i:
            df[col] = gdf[col]
            df['geometry'] = gdf['geometry']
            
            # add ISO3 to df
            if geog == 'countries_gdam':
                df['ISO3'] = gdf['ISO3']

        # merge data
        df = df.merge(gdf[[col, data]], on = col, how = 'inner')
    

    # Calc Pct
    df['open_N_pct'] = df['open_N'] / df['tot_N'] * 100
    df['septic_N_pct'] = df['septic_N'] / df['tot_N'] * 100
    df['treated_N_pct'] = df['treated_N'] / df['tot_N'] * 100
    df['tot_pct'] =  df['open_N_pct'] + df['septic_N_pct'] + df['treated_N_pct']
    
    gdf_out = gpd.GeoDataFrame(df)
    
    return gdf_out

# Merge it all
##############################################################################################################

# Open Files
countries_gdam, watersheds, pp = dir_n_files()

# Run it
countries_gdam_final = merge_data(countries_gdam, 'countries_gdam', 'poly_id')
watersheds_final = merge_data(watersheds, 'watersheds', 'basin_id')

# Merge PP
pp_out = pp[['basin_id', 'geometry']]

pp_out = pp_out.merge(watersheds_final.drop(columns = 'geometry'), on = 'basin_id', how = 'inner')

# Save it all
##############################################################################################################

# countries_gdam
fn_out = DATA_IN+'processed/N_effluent_output/effluent_N_countries_gdam_all.shp'
countries_gdam_final.to_file(fn_out)

# watersheds
fn_out = DATA_IN+'processed/N_effluent_output/effluent_N_watersheds_all.shp'
watersheds_final.to_file(fn_out)

# pp
fn_out = DATA_IN+'processed/N_effluent_output/effluent_N_pourpoints_all.shp'
pp_out.to_file(fn_out)