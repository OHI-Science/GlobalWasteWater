#------------------------------------------------------------------------------#
## Project :  Wastewater
## Purpose :  Make figure plumes
##  Date   :  08/03/2020
## Author  :  Gordon Blasco
#------------------------------------------------------------------------------#

library(sf)
library(raster)
library(here)
library(tidyverse)
library(rasterVis)
library(patchwork)

source(here("code", "file_names.R"))

#source raster
r <- raster(effluent_N_log10_fn)

#plumes
plumes <- raster("/home/shares/ohi/git-annex/land-based/wastewater/data/processed/N_effluent_output/global_effluent_2015_tot_N.tif")

plumes_1 <- plumes +1
values(plumes_1)[values(plumes_1) <= 1] = 0

plumes10 <- log10(plumes_1)

#source raster
plumes10_t <- raster::projectRaster(plumes10, r)

#sheds
N_sheds <- sf::read_sf("/home/shares/ohi/git-annex/land-based/wastewater/data/processed/N_effluent_output/effluent_N_watersheds_all.shp")



#world vectors
vec_world <- st_read(world_vector_fn) %>% 
  filter(poly_type == "GADM") 



# fix crs of objects
moll <- crs(r)
st_crs(vec_world) = moll
st_crs(N_sheds) = moll
#crs(plumes10) <- moll


#### Make bounding box for Ganges ####
#------------------------------------------------------------------------------#

#make box with coord points
b <- st_bbox(c(xmin = 86.464, 
               xmax = 91.632, 
               ymax = 23.154, 
               ymin = 19.809), 
             crs = st_crs(4326)) %>% 
  st_as_sfc() %>% 
  st_as_sf()

#transform to moll
b_moll <- st_transform(b, crs = moll)

# filter for bangladesh and india
world_sf_b <- vec_world %>% 
  filter(ISO3 == "BGD"|ISO3 =="IND")


# crop the box
plumes_b <- crop(plumes10_t, b_moll)
map_x <- st_crop(world_sf_b, b_moll)


pl <- gplot(plumes_b, maxpixels = 1e5) + 
  geom_tile(aes(fill = value), na.rm = TRUE)+
  scale_fill_gradient(low ='yellow', high ='darkred', na.value = 'white') +
  #scale_fill_continuous()+
  scale_y_continuous(expand = c(0,0))+
  scale_x_continuous(expand = c(0,0))+
  coord_equal()


p3 <- pl +
  geom_sf(data = map_x,
          color = "black",
          fill = "tan", 
          size = 0.1,
          alpha = .5,
          inherit.aes = FALSE)+
  theme(
    axis.title.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank(),
    legend.title = element_blank()#,
    #legend.position = "bottom",
    #legend.direction = "horizontal"
  )

p3





#make box with coord points
c <- st_bbox(c(xmin = 28.433, 
               xmax = 31.244, 
               ymax = 46.592, 
               ymin = 43.89), 
             crs = st_crs(4326)) %>% 
  st_as_sfc() %>% 
  st_as_sf()

#transform to moll
c_moll <- st_transform(c, crs = moll)

# filter for bangladesh and india
world_sf_c <- vec_world %>% 
  filter(ISO3 == "ROU"|ISO3 =="UKR"|ISO3 =="MDA"|ISO3 =="BGR")


# crop the box
plumes_c <- crop(plumes10_t, c_moll)
map_y <- st_crop(world_sf_c, c_moll)


pl2 <- gplot(plumes_c, maxpixels = 1e5) + 
  geom_tile(aes(fill = value), na.rm = TRUE)+
  scale_fill_gradient(low ='yellow', high ='darkred', na.value = 'white') +
  #scale_fill_continuous()+
  scale_y_continuous(expand = c(0,0))+
  scale_x_continuous(expand = c(0,0))+
  coord_equal()


p4 <- pl2 +
  geom_sf(data = map_y,
          color = "black",
          fill = "tan", 
          size = 0.1,
          alpha = .5,
          inherit.aes = FALSE)+
  theme(
    axis.title.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank(),
    legend.title = element_blank()#,
    #legend.position = "bottom",
    #legend.direction = "horizontal"
  )

p4





p3+p4+
  plot_layout(guides = 'collect')





d <- st_bbox(c(xmin = 120.20, 
               xmax = 123.20, 
               ymax = 32.17, 
               ymin = 29.67), 
             crs = st_crs(4326)) %>% 
  st_as_sfc() %>% 
  st_as_sf()




#transform to moll
d_moll <- st_transform(d, crs = moll)

# filter for bangladesh and india
world_sf_d <- vec_world %>% 
  filter(ISO3 == "CHN"|ISO3 =="UKR"|ISO3 =="MDA"|ISO3 =="BGR")


# crop the box
plumes_d <- crop(plumes10_t, d_moll)
map_z <- st_crop(world_sf_d, d_moll)


pl3 <- gplot(plumes_d, maxpixels = 1e5) + 
  geom_tile(aes(fill = value), na.rm = TRUE)+
  scale_fill_gradient(low ='gold', high ='brown1', na.value = 'white') +
  #scale_fill_continuous()+
  scale_y_continuous(expand = c(0,0))+
  scale_x_continuous(expand = c(0,0))+
  coord_equal()

pl3

p5 <- pl3 +
  geom_sf(data = map_z,
          color = "black",
          fill = "tan", 
          size = 0.1,
          alpha = .5,
          inherit.aes = FALSE)+
  theme(
    axis.title.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank(),
    legend.title = element_blank()#,
    #legend.position = "bottom",
    #legend.direction = "horizontal"
  )



parts<- p3+p4+p5+
  plot_layout(guides = 'collect')&
  theme(legend.position = "none")&
  scale_fill_gradient(low ='gold', 
                      high ='firebrick3', 
                      na.value = 'white')
  #scale_fill_viridis(limits=c(0, max_lim),
  #                   na.value = 'white',
  #                   direction = -1,
  #                    option = "plasma")
parts











# plumes_b_r <- raster::projectRaster(plumes_b, r)
# plumes_b_2 <- crop(plumes_b_r, b_moll)
# 
# 
# world_sp_b <- vec_world %>% 
#   filter(ISO3 == "BGD"|ISO3 =="IND")
# 
# x <- st_crop(world_sp_b, b_moll)
# 
# ggplot()+
#   geom_sf(data = x)+
#   #coord_sf(xlim = c(85.464, 91.632), ylim = c(20.109, 24.154), expand = FALSE)+
#   #geom_sf(data = b, color = "red", fill = "red", size = 100)+
#   theme_bw()
# 
# b_sp <- as(b, Class = "Spatial")
# 
# world_b <- gIntersection(world_sp_b, b_sp)
# 
# world_b_sf <- world_b %>% 
#   st_as_sf() 
# 
# 
# 
# 
# # to crop and plot dunshabe
# 
# #set box
# 
# 
# c <- st_bbox(c(xmin = 28.433, 
#                xmax = 31.244, 
#                ymax = 46.592, 
#                ymin = 43.89), 
#              crs = st_crs(moll)) %>% 
#   st_as_sfc() %>% 
#   st_as_sf()
# 
# # crop the box
# plumes_c<- crop(plumes10, c)
# plot(plumes_c)
# 
# 
# 
# # to crop and plot china
# 
# #set box
# 
# 
# d <- st_bbox(c(xmin = 120.20, 
#                xmax = 123.20, 
#                ymax = 32.17, 
#                ymin = 29.67), 
#              crs = st_crs(moll)) %>% 
#   st_as_sfc() %>% 
#   st_as_sf()
# 
# # crop the box
# plumes_d<- crop(plumes10, d)
# plot(plumes_d)
# Q