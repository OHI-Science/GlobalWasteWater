# plume_distibutions.R
# calculate the distributions of our three plume inputs:
# fertilizer            MT / yr
# pesticides            MT / yr
# impervious surfaces   percent coverage

# load the maptool library, parses dbfs
library(maptools)

# store the current directory
initial.dir<-getwd()
# data directory
setwd("/media/nix/nceas_ohi/impact_layers_redo/land_based/[7]_plume_model/output")

# output file
sink("plume_distributions_2003_2006.log")
#sink("plume_distributions_2007_2010.log")

# load dbf
pours <- read.dbf("/media/nix/nceas_ohi/impact_layers_redo/land_based/[6]_plume_prepare/output/global_plume_2003_2006.dbf")
#pours <- read.dbf("/media/nix/nceas_ohi/impact_layers_redo/land_based/[6]_plume_prepare/output/global_plume_2007_2010.dbf")

print ("Threshold values")
print ("----------------")
print ("Fertilizer (MT/yr):")
classes<-c(0.0005, 0.05,0.10,0.25,0.50,0.75)
fert<-ifelse(pours$SUM_FERTC == 0, NA, pours$SUM_FERTC)
quantile(sort(fert), prob=classes)

print ("Pesticide (MT/yr):")
pest<-ifelse(pours$SUM_PESTC == 0, NA, pours$SUM_PESTC)
quantile(sort(pest), prob=classes)

print ("Impervious (% cov):")
impv<-ifelse(pours$SUM_IMPV == 0, NA, pours$SUM_IMPV*0.87325077)
quantile(sort(impv), prob=classes)

# close up shop
sink()
detach("package:maptools")
setwd(initial.dir)
