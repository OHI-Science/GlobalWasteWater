# log_normalize_rasters.py
# =======================================
#
# For each raster, compute the log10(pixel_value+1) and normalize result by highest value, giving values in range from 0 to 1.
# (The high value of 1 is guaranteed, but the low zero may not be reached if the lowest original value is not zero.)
#
# If values are negative and positive, the negative and positive pixel values are computed as log10(absolute_value(pixel_value)+1)
# and normalized out of the highest absolute pixel value.  (Thus results will be on the scale from -1 to 1, although need not span that entire range.)
#
# (Tested w/ ArcGIS 10.1)
# April 2013, John Potapenko (john@scigeo.org)
#
#===============================================================================

#----------------------------------
# user-parameters:
#----------------------------------

#raster_dir = "R:\\users\\potapenko\\DATA STORAGE\\impact_layers_redo\\land_based\\[8]_plume_finalize\\output"
raster_dir = r"G:\\201112\\" #JB
#input_raster_names = ["global_plumes_fert_2003_2006_raw", "global_plumes_pest_2003_2006_raw", "global_plumes_fert_2007_2010_raw", "global_plumes_pest_2007_2010_raw"]
input_raster_names = ["global_plumes_pest_2011_2012_raw", "global_plumes_fert_2011_2012_raw","global_plumes_pest_2007_2010_raw", "global_plumes_fert_2007_2010_raw"] #JB
#output_raster_names = ["global_plumes_fert_2003_2006_trans", "global_plumes_pest_2003_2006_trans", "global_plumes_fert_2007_2010_trans", "global_plumes_pest_2007_2010_trans"]
output_raster_names = ["global_plumes_pest_2011_2012_trans", "global_plumes_fert_2011_2012_trans","global_plumes_pest_2007_2010_trans", "global_plumes_fert_2007_2010_trans"] #JB
#input_raster_names = ["global_plumes_fert_2007_2010_raw_minus_2003_2006_raw", "global_plumes_pest_2007_2010_raw_minus_2003_2006_raw"]
#output_raster_names = ["global_plumes_fert_2007_2010_raw_minus_2003_2006_raw_trans", "global_plumes_pest_2007_2010_raw_minus_2003_2006_raw_trans"]

#----------------------------------
# main:
#----------------------------------

import os, sys, arcpy
from arcpy.sa import *
arcpy.CheckOutExtension("spatial")

arcpy.env.overwriteOutput=True

i=0
for input_raster_name in input_raster_names:
  input_raster=os.path.join(raster_dir,input_raster_name+'.tif')
  print input_raster
  output_raster=os.path.join(raster_dir,output_raster_names[i]+'.tif')
  print output_raster

  arcpy.CalculateStatistics_management(input_raster)
  max_val=float(str(arcpy.GetRasterProperties_management(input_raster,"MAXIMUM")))
  min_val=float(str(arcpy.GetRasterProperties_management(input_raster,"MINIMUM")))
  if min_val >0:
    outRast=Log10(arcpy.Raster(input_raster)+1)/Log10(max_val+1)
  else:
    max_val=max(abs(min_val),abs(max_val))
    outRast=Con(arcpy.Raster(input_raster)>0,1,-1)*Log10(Abs(arcpy.Raster(input_raster))+1)/Log10(max_val+1)
  outRast.save(output_raster)
  i=i+1
