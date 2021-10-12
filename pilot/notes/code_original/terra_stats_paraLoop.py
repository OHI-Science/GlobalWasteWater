# terra_stats.py
# calculate per-basin statistics
# Author: scw <walbridge@nceas.ucsb.edu>
# Date: 3.20.2007
# Usage: terra_stats_paraLoop.py
# modified by brun@nceas.ucsb.edu to use mlutiple cores,  May 2015
# Note: run out of memory on Bumbelbee

# Import system modules
import sys, string, os

#For parallel #JB
#from joblib import Parallel, delayed
from multiprocessing import Pool
num_cores = 2
pool = Pool(num_cores)

# Create the geoprocessor object
try:
    import arcgisscripting
    gp = arcgisscripting.create()

except:
    import win32com.client
    gp = win32com.client.Dispatch("esriGeoprocessing.GpDispatch.1")

# Geoprocessor configuration
gp.CheckOutExtension("spatial")                                 # Check out the required license
gp.overwriteoutput = 1                                          # Overwrite existing files

"""
if len(sys.argv) < 4:
	print "Usage: basinBump <prefix> <elevation> <modifications dir> <output dir>"
	sys.exit()
"""

# Create function to allow parallelization #JB
def zonstat(region):
    #Check if the output directory exists and creat it if not JB
    outfullpath = "%s\\%s" %(outpath, region) #JB
    print outfullpath  #JB
    if not os.path.isdir(outfullpath): #JB
        os.mkdir(outfullpath) #JB
    zones = "%s\\%s_bas.shp" % (basins, region)
    rast = "%s\\%s_%s.tif" % (rasterbase, region, r)
    table = "%s\\%s\\%s_zonal_stats_%s.dbf" % (outpath, region, region, r)
    gp.ZonalStatisticsAsTable_sa(zones, "basin_id", rast, table, "DATA")





if __name__ == "__main__":
    try:
        prefix = sys.argv[1]
        demarg = sys.argv[2]
        modDir = sys.argv[3]
        outputDir  = sys.argv[4]

    except:
        prefixes   = ['af', 'as', 'au', 'eu', 'na', 'pa', 'sa']
        outpath    = r"C:\Users\Brun\Plume\20112012\step5\output"
        #rasters    = ['fert_2003_2006','pest_2003_2006','fert_2007_2010','pest_2007_2010']
        rasters    = ['fert_2011_2012','pest_2011_2012'] #'fert_2007_2010','pest_2007_2010'] #JB
        rasterbase = r"C:\Users\Brun\Plume\step4\output"
        basins     = r"C:\Users\Brun\Plume\[0]_og_input\\basins_laea"

    try:
        for r in rasters:
            gp.workspace = "%s\\%s" % (rasterbase, r)
            #Parallel processing added by JB
            pool.map(zonstat,prefixes) #JB
            #moved into a function by JB
            '''for p in prefixes:
            #Check if the output directory exists and creat it if not JB
            outfullpath = "%s\\%s" %(outpath, p) #JB
            print outfullpath  #JB
            if not os.path.isdir(outfullpath): #JB
                os.mkdir(outfullpath) #JB
            zones = "%s\\%s_bas.shp" % (basins, p)
            rast = "%s\\%s_%s.tif" % (rasterbase, p, r)
            table = "%s\\%s\\%s_zonal_stats_%s.dbf" % (outpath, p, p, r)
            gp.ZonalStatisticsAsTable_sa(zones, "basin_id", rast, table, "DATA")'''

    except:
        # report geoprocessing errors
        print gp.GetMessages()
