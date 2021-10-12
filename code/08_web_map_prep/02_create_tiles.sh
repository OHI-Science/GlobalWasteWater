#!/bin/bash
## First steps
### change directory
cd /home/shares/ohi/git-annex/land-based/wastewater/data/processed

### NITROGEN
# Effluent
gdal2tiles.py --zoom=1-8 effluent_N_colored.tif tiles/N_effluent
# Effluent open
gdal2tiles.py --zoom=1-8 effluent_N_open_log10_colored.tif tiles/N_effluent_open
# Effluent septic
gdal2tiles.py --zoom=1-8 effluent_N_septic_log10_colored.tif tiles/N_effluent_septic
# Effluent treated
gdal2tiles.py --zoom=1-8 effluent_N_treated_log10_colored.tif tiles/N_effluent_treated
# Plumes
gdal2tiles.py --zoom=1-8 N_global_plume_effluent_2015_colored.tif tiles/N_plumes

### FIOs
# Effluent
gdal2tiles.py --zoom=1-8 effluent_FIO_colored.tif tiles/FIO_effluent
# Plumes
gdal2tiles.py --zoom=1-8 FIO_global_plume_effluent_2015_colored.tif tiles/FIO_plumes
