#!/usr/bin/python
#
# update_global_plume.py
# ----------------------
#
# Update global plume shapefile of pesticide/fertilizer sums for each basin.
#
# Start with blank version (all fields filled with 0), then run script to
# update global_plume_*.dbf file with zonal stats for each basin.
# Run twice for both years.
#
# March 2013, John Potapenko (john@scigeo.org)

#-------------------------------
# input params
#-------------

continent_regions=['af','as','au','eu','na','pa','sa']
zonal_stats_dir="/media/nix/nceas_ohi/impact_layers_redo/land_based/[5]_zonal_stats/output"
#zonal_stats_names=['_zonal_stats_fert_2003_2006','_zonal_stats_pest_2003_2006']
zonal_stats_names=['_zonal_stats_fert_2007_2010','_zonal_stats_pest_2007_2010']
#global_plume_dbf="/media/nix/nceas_ohi/impact_layers_redo/land_based/[6]_plume_prepare/output/global_plume_2003_2006.dbf"
global_plume_dbf="/media/nix/nceas_ohi/impact_layers_redo/land_based/[6]_plume_prepare/output/global_plume_2007_2010.dbf"
global_plume_fields=['SUM_FERTC','SUM_PESTC']

#-------------------------------
import ogr, os, sys, math

## open global plumes dbf
driver=ogr.GetDriverByName('ESRI Shapefile')
datasource_plume=driver.Open(global_plume_dbf,1)
if datasource_plume is None:
  print 'Could not open global_plume file.'
  sys.exit(1)
layer_plume = datasource_plume.GetLayer()

for region in continent_regions:
  print region
  global_plume_field_num=0
  for zonal_stats_name in zonal_stats_names:
    print zonal_stats_name
    ## read in zonal stats file into internal dictionary
    # open zonal stats file
    zonal_stats_dbf=os.path.join(zonal_stats_dir,region,region+zonal_stats_name+'.dbf')
    datasource_zonal=driver.Open(zonal_stats_dbf,0)
    if datasource_zonal is None:
      print 'Could not open zonal stats file.'
      sys.exit(1)
    layer_zonal = datasource_zonal.GetLayer()

    nan_count=0
    basin_table={}
    feature_next = layer_zonal.GetNextFeature()
    while feature_next:
      sum_value=feature_next.GetField('Sum')
      basin_name=feature_next.GetField('BASIN_ID')
      if basin_name!=None and sum_value!=None:
        if basin_name not in basin_table:
          basin_table[basin_name]={}
        basin_table[basin_name]['Sum']=sum_value
      else:
        nan_count=nan_count+1
      feature_next.Destroy()
      feature_next=layer_zonal.GetNextFeature()
    print "zonal_stats nans encountered: ", nan_count
    # close up file
    datasource_zonal.Destroy()

    ## update global plume file for basins found in zonal stats file
    global_plume_field=global_plume_fields[global_plume_field_num]
    nan_count=0
    feature_next = layer_plume.GetNextFeature()
    while feature_next:
      basin_name=feature_next.GetField('basin_id')
      if basin_name!=None:
        if basin_name in basin_table:
          sum_value=basin_table[basin_name]['Sum']
          feature_next.SetField(global_plume_field,sum_value)
          layer_plume.SetFeature(feature_next)
      else:
        nan_count=nan_count+1
      feature_next.Destroy()
      feature_next=layer_plume.GetNextFeature()
    layer_plume.ResetReading()
    print "global_plume nans encountered: ", nan_count
    global_plume_field_num=global_plume_field_num+1

# close up
datasource_plume.Destroy()
sys.exit()
