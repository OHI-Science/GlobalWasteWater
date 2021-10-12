              Land-based coastal pollution procedure
              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

General Procedure
-----------------

We created land-based run-off coastal pollution layers -- nutrients (fertilizers) and organic pollutants (pesticides) -- for two time periods: 2003-2006 and 2007-2010 (these years were chosen based on FAO data availability).

Fertilizer and pesticide consumption was averaged over the time periods, with missing values filled in by regression between fertilizer and pesticides when possible, and when not possible with agricultural GDP as proxy.  These values were dasymetrically distributed over the countries by using global landcover data from the years 2005 (for the 2003-2006 time period) and 2009 (for the 2007-2010 time period), derived from the MODIS satellite at ~500m resolution.  These values were then aggregated by ~140,000 global basins (re-used from the original Halpern 2008 study) and plumes were modeled from the basin pourpoints.  The final non-zero plumes (about ~76,000) were aggregated into ~1km Mollweide (wgs84) projection rasters.


Data Products
-------------

We produced "raw" plume-aggregated pollution rasters, called (for both time periods):
global_plumes_fert_2003_2006_raw.tif
global_plumes_pest_2003_2006_raw.tif

These were transformed via log(x+1) and normalized to 0-1 into these files:
global_plumes_fert_2003_2006_trans.tif
global_plumes_pest_2003_2006_trans.tif

We also created pixel-by-pixel difference maps.  These were made by subtracting the later raster (2010-2007) from the earlier one (2003-2006), so positive values indicate an increase in pesticide/fertilizer for that 1-km^2 pixel and negative values indicate a decrease.  These are named:
global_plumes_fert_2007_2010_raw_minus_2003_2006_raw.tif
global_plumes_pest_2007_2010_raw_minus_2003_2006_raw.tif

We also transformed these difference layers via log(absolute_value(x)+1) for both positive and negative differences.  These were normalized out of the maximum absolute pixel value (positive or negative), so final values were in the range from -1 to 1.  Here again positive values indicate a temporal increase in pesticides/fertilizers for that pixel.  These files are called:
global_plumes_fert_2007_2010_raw_minus_2003_2006_raw_trans.tif
global_plumes_pest_2007_2010_raw_minus_2003_2006_raw_trans.tif

The 'plume_histogram_plots' folder contains pixel count histogram plots from the above layers.  These show log-transformed pixel distributions of the raw values and raw value differences (positive and negative) for fertilizers and pesticides in both time periods.

The 'final_products/fao_fert_pest_plots' folder contains plots of the FAO pesticide/fertilizer values used for the plume models.


Overall Results
---------------

Doing a simple visual and pixel-count comparison of the agriculture landcover classes shows that globally these classes have not changed much during our time period (to the 500m resolution of the data).  However, global pesticide/fertilizer consumption has shown a small, but significant increase globally (roughly 4-8% over our time period).

We caution against reading too much into differences at specific pixel locations, since the landcover, FAO, and basin data are not perfectly precise (e.g. many countries have missing FAO data for several years and the regression approach is not ideal).


Inorganic pollution
--------------------

We did not create an updated inorganic pollution layer because of the difficulty in finding an impermeable surface dataset spanning our time periods.  The NOAA DMSP dataset used in the original Halpern 2008 study has not been updated. We attempted to use the urban landcover classification via MODIS as a proxy for impermeable surface distribution; however, this dataset shows a very minor change in global urban classification changes during our time period (a fraction of a percent) and seems not to capture changes in impermeable surfaces too well.


--------------------
John Potapenko, Jan-April 2013 (john@scigeo.org)
