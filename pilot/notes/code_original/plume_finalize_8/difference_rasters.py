# difference_rasters.py
# =======================================
#
# Calculate difference between two rasters for each pixel.
# (output raster = raster2 - raster1)
#
# (Tested w/ ArcGIS 10.1)
# April 2013, John Potapenko (john@scigeo.org)
#
# Modified by brun@nceas.ucsb.edu, May 2015 - ArcGIS 10.3 : added loop for
# products and file name construction
#
#===============================================================================

import os, sys, arcpy
from arcpy.sa import *
arcpy.CheckOutExtension("spatial")

arcpy.env.overwriteOutput=True


#----------------------------------
# user-parameters:
#----------------------------------

"""
raster1 = "R:\\users\\potapenko\\DATA STORAGE\\impact_layers_redo\\land_based\\[8]_plume_finalize\\output\\global_plumes_fert_2003_2006_raw.tif"
raster2 = "R:\\users\\potapenko\\DATA STORAGE\\impact_layers_redo\\land_based\\[8]_plume_finalize\\output\\global_plumes_fert_2007_2010_raw.tif"
output_raster = "R:\\users\\potapenko\\DATA STORAGE\\impact_layers_redo\\land_based\\[8]_plume_finalize\\output\\global_plumes_fert_2007_2010_raw_minus_2003_2006_raw.tif"


raster1 = "R:\\users\\potapenko\\DATA STORAGE\\impact_layers_redo\\land_based\\[8]_plume_finalize\\output\\global_plumes_pest_2003_2006_raw.tif"
raster2 = "R:\\users\\potapenko\\DATA STORAGE\\impact_layers_redo\\land_based\\[8]_plume_finalize\\output\\global_plumes_pest_2007_2010_raw.tif"
output_raster = "R:\\users\\potapenko\\DATA STORAGE\\impact_layers_redo\\land_based\\[8]_plume_finalize\\output\\global_plumes_pest_2007_2010_raw_minus_2003_2006_raw.tif"
"""
##### Section added by JB to loop the process ######
path_to_raster = "G:\\201112\\"
raster_prefix = "global_plumes_"
raster_suffix ="_raw.tif"

raster1_years = "2007_2010"
raster2_years = "2011_2012"

products = ["fert", "pest"]
####################################################

#----------------------------------
# main:
#----------------------------------


for product in products: #JB
    raster1 = path_to_raster + raster_prefix + product + "_"  + raster1_years + raster_suffix #JB
    raster2 = path_to_raster + raster_prefix + product + "_" + raster2_years + raster_suffix #JB
    output_raster = path_to_raster + raster_prefix + product + "_" + raster2_years + "_raw_minus_" + raster1_years + raster_suffix #JB
    #Raster difference computation
    outRast=arcpy.Raster(raster2)-arcpy.Raster(raster1)
    outRast.save(output_raster)

del outRast #JB