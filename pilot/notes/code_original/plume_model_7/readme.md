These are the instructions lifted from [here](https://github.com/jkibele/wastewater/tree/master/notes/docs_original/land_based_layers_workflow_2011_2012) just for extra convenience.

Step 7: Plume Model
----------------------------------------------------------
*Run global plume model.*

  - run `plume_distributions.R` script (will need to install maptools package in R: install.packages('maptools')). Use the "0.05%" values in log output to manually update `plume_buffer.py` limits values for pesticides and fertilizer.

        $ R --vanilla < plume_distributions.R
        
### Note: ###
This next step relies on *grass*, you can find the grass setup I used here:
`/var/cache/halpern-et-al/mnt/storage/marine_threats/grass_jb`

To define the location extent, I used the extent of the ocean_mask file.

The mapset projection was set using the projection of global_plume_*.shp

  - launch grass64
  - select a the PERMANENT mapset
  - add the ocean mask to the PERMANENT mapset: `r.in.gdal -o input="impact_layers_redo/land_based/201112/step0/ocean_mask/ocean_mask.tif" output=ocean`
  
  **Note**: This need only to be done once

  - run: `./run_2011_2012.sh`
  
  **Note**: you need to uncomment the part you would like to run and change the year period accordingly to your global\_plume_*.shp
  **tip**: run 8 mapsets simultaneously during plume_buffer.py for efficiency

  - When all the plume runs are done combine plumes into single global raster:

        ./gdal_add.py -o global_plumes_pest_2011_2012_raw.tif -ot Float32 plume_pest*.tif
        ./gdal_add.py -o global_plumes_fert_2011_2012_raw.tif -ot Float32 plume_fert*.tif
        # note: may need to add plumes in stages

  - repeat above steps for other time period
