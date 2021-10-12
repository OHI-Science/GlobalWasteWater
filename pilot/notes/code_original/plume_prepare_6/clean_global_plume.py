#!/usr/bin/python
#
# clean_global_plume.py
# ----------------------
#
# This script removes features from the global plume shapefile that 
# have zero values for pesticides, fertilizer, and impervious surface.
#
# April 2013, John Potapenko (john@scigeo.org)

#-------------------------------
# input params
#-------------

# global plume shapefile
#global_plume_shp="/media/nix/nceas_ohi/impact_layers_redo/land_based/[6]_plume_prepare/output/global_plume_2003_2006.shp"
global_plume_shp="/media/nix/nceas_ohi/impact_layers_redo/land_based/[6]_plume_prepare/output/global_plume_2007_2010.shp"
# fields to test for zero values
global_plume_fields=['SUM_FERTC','SUM_PESTC', 'SUM_IMPV']

#-------------------------------
import ogr, os, sys, math

driver=ogr.GetDriverByName('ESRI Shapefile')
datasource=driver.Open(global_plume_shp,1)
if datasource is None:
  print 'Could not open shp file.'
  sys.exit(1)
layer = datasource.GetLayer()

feature_next = layer.GetNextFeature()
while feature_next:
  zero_fields=0
  for global_plume_field in global_plume_fields:
    if float(feature_next.GetField(global_plume_field))==0.0000000:
      zero_fields=zero_fields+1
  if zero_fields>=len(global_plume_fields):
    print "Erasing blank feature..."
    layer.DeleteFeature(feature_next.GetFID())
  feature_next.Destroy()
  feature_next=layer.GetNextFeature()
#layer.ResetReading()
print 'Done erasing blank features.'

# close up
datasource.Destroy()
sys.exit()
