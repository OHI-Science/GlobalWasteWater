"""
Split a big set of vector features from one file into multiple files and load them into GRASS.
This will need to be run from within a grass session.
Jared Kibele, April 2019
"""
import geopandas as gpd
import os
import sys

def new_shp_fn(filename, number):
    return os.path.abspath(filename).replace('.shp', '_{}.shp'.format(number))
    
def list_of_dfs(df, size):
    return [df.iloc[i:i+size,:] for i in range(0, len(df),size)]
    
def split_and_save(gdf_fn, size):
    gdf = gpd.read_file(gdf_fn)
    filenames = []
    for i,newdf in enumerate(list_of_dfs(gdf, size)):
        new_fn = new_shp_fn(gdf_fn,i+1)
        filenames.append(new_fn)
        newdf.to_file(new_fn)
        print("Just wrote {} features to {}".format(len(newdf), new_fn))
        
    return filenames
        
if __name__ == '__main__':
    try:
        filename = sys.argv[1]
        split_num = int(sys.argv[2])
    except:
        print sys.argv[0] + " usage: filename split_num"
        sys.exit(1)
        
    fn_list = split_and_save(filename, split_num)
    
    for i, fn in enumerate(fn_list):
        cmd = "v.in.ogr input={} output=pourpnts{}".format(fn, i+1)
        print(cmd)
        os.popen(cmd)
