# terra_stats.py
# calculate per-basin statistics
# Author: scw <walbridge@nceas.ucsb.edu>
# Date: 3.20.2007
# Usage: terra_stats_fert.py
# modified by brun@nceas.ucsb.edu to automatically create the output folder structure, May 2015


# Import system modules
import sys, string, os

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


try:

    prefix = sys.argv[1]
    demarg = sys.argv[2]
    modDir = sys.argv[3]
    outputDir  = sys.argv[4]

except:
    prefixes   = ['af', 'as', 'au', 'eu', 'na', 'pa', 'sa']
    outpath    = r"C:\Users\Brun\Plume\201112\step5\output"
    #rasters    = ['fert_2003_2006','pest_2003_2006','fert_2007_2010','pest_2007_2010']
    rasters    = ['fert_2007_2010','fert_2011_2012'] #,'pest_2007_2010'] JB
    rasterbase = r"C:\Users\Brun\Plume\201112\step4\output"
    basins     = r"C:\Users\Brun\Plume\[0]_og_input\\basins_laea"

try:
    for r in rasters:
        print r
        gp.workspace = "%s\\%s" % (rasterbase, r)
        for p in prefixes:
            print p
            #Check if the output directory exists and creat it if not JB
            outfullpath = "%s\\%s" %(outpath, p) #JB
            print outfullpath  #JB
            if (not os.path.isdir(outfullpath)): #JB
                os.mkdir(outfullpath) #JB
            zones = "%s\\%s_bas.shp" % (basins, p)
            rast = "%s\\%s_%s.tif" % (rasterbase, p, r)
            table = "%s\\%s\\%s_zonal_stats_%s.dbf" % (outpath, p, p, r)
            gp.ZonalStatisticsAsTable_sa(zones, "basin_id", rast, table, "DATA")

except:
    # report geoprocessing errors
    print gp.GetMessages()
