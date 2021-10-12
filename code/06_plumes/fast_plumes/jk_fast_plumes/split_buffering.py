#!/usr/bin/env python
"""
Run plume buffering on a bunch of vectors files at once.
Before running:
  - mask of 1 (for water) and null (for land) called ocean@PERMANENT
  - make sure default region of PERMANENT is set to match 'ocean' mask
  - grass76 running in relevant location (duh)
Jared Kibele, April 2019
"""
import os
import sys
from glob import glob
from subprocess import Popen, call

ww_dir = "/home/shares/ohi/git-annex/land-based/wastewater/"
ocean_mask_fn = os.path.join(ww_dir, "intermediate_files", "ocean_mask.tif")

def list_the_point_files(directory, file_pattern):
  fp_list = glob(os.path.join(directory, file_pattern))
  return fp_list
  
def setup_grass(pnt_file):
  # make mapset, switch to it
  shortname = os.path.basename(pnt_file).replace('.shp','')
  cmd = "g.mapset -c mapset={}".format(shortname)
  call(cmd, shell=True)
  # put the subset point file in there
  cmd = "v.in.ogr input={} output={}".format(pnt_file, shortname)
  call(cmd, shell=True)
  # make sure the region is the default
  cmd = "g.region -d"
  call(cmd, shell=True)
  return shortname
  
def run_buffering(shortname):
  """
  We assume we're in our subset mapset already.
  """
  cmd = "nohup ./run_subset_plumes.sh {} > split_run_{}.log &".format(shortname, shortname)
  Popen(cmd, shell=True) 


if __name__ == '__main__':
  try:
    directory = sys.argv[1]
    if len(sys.argv) == 3:
      file_pattern = sys.argv[2]
    else:
      # default file_pattern
      file_pattern = "pour_points_*.shp"
  except:
    print sys.argv[0] + " usage: directory {file_pattern}"
    sys.exit(1)

  fp_list = list_the_point_files(directory, file_pattern)
  
  for fp in fp_list:
    shortn = setup_grass(fp)
    run_buffering(shortn)
