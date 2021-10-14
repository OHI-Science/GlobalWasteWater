#!/bin/bash
## First steps

cd /home/shares/ohi/git-annex/land-based/wastewater/data/processed

### NITROGEN
# Effluent
gdaldem color-relief -of GTiff ../interim/effluent_N_log10.tif ../interim/N_colors.txt effluent_N_colored.tif -alpha
# Effluent open
gdaldem color-relief -of GTiff ../interim/effluent_N_open_log10.tif ../interim/N_colors.txt effluent_N_open_log10_colored.tif -alpha
# Effluent septic
gdaldem color-relief -of GTiff ../interim/effluent_N_septic_log10.tif ../interim/N_colors.txt effluent_N_septic_log10_colored.tif -alpha
# Effluent treated
gdaldem color-relief -of GTiff ../interim/effluent_N_treated_log10.tif ../interim/N_colors.txt effluent_N_treated_log10_colored.tif -alpha
# Plumes
gdaldem color-relief -of GTiff N_effluent_output/global_effluent_2015_tot_N.tif ../interim/Nplume_color.txt N_global_plume_effluent_2015_colored.tif -alpha

### FIOs
# Effluent
gdaldem color-relief -of GTiff effluent_FIO.tif FIOplume_color.txt effluent_FIO_colored.tif -alpha
# Plumes
gdaldem color-relief -of GTiff FIO_effluent_output/FIO_global_plume_effluent_2015.tif ../interim/FIOplume_color.txt FIO_global_plume_effluent_2015_colored.tif -alpha
