#!/usr/bin/python
#
# zero_dbf.py
# ----------------------
#
# Simple script to reset DBF fields to zero.
#
# April 2013, John Potapenko (john@scigeo.org)

#-------------------------------
# input params
#-------------

dbf_file="/media/nix/nceas_ohi/impact_layers_redo/land_based/[6]_plume_prepare/output/global_plume.dbf"

#-------------------------------
import ogr, os, sys, math

driver=ogr.GetDriverByName('ESRI Shapefile')
datasource=driver.Open(dbf_file,1)
if datasource is None:
  print 'Could not open dbf file.'
  sys.exit(1)
layer = datasource.GetLayer()

feature_next = layer.GetNextFeature()
while feature_next:
  feature_next.SetField('SUM_FERTC',0)
  feature_next.SetField('SUM_PESTC',0)
  feature_next.SetField('SUM_IMPV',0)
  layer.SetFeature(feature_next)
  feature_next.Destroy()
  feature_next=layer.GetNextFeature()
#layer.ResetReading()

# close up
datasource.Destroy()
sys.exit()
