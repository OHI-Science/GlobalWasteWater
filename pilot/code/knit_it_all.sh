#!/bin/bash
Rscript -e "library(rmarkdown); render('./datasets.Rmd')" > datasets.log
Rscript -e "library(rmarkdown); render('./sanitation_factors.Rmd')" > sanitation_factors.log
Rscript -e "library(rmarkdown); render('./world_vector_prep.Rmd')" > world_vector_prep.log
Rscript -e "library(rmarkdown); render('./effluent_density.Rmd')" > effluent_density.log
python3 ./effluent_watershed_script.py > effluent_watershed.log
Rscript -e "library(rmarkdown); render('./wastewater_index.Rmd')" > wastewater_index.log
Rscript -e "library(rmarkdown); render('./pour_points.Rmd')" > pour_points.log