##################################################
## Project: Wastewater
## Script purpose: Make a map of top 100 pour points
## Date: 4/6/2020
## Author: Gordon Blasco
##################################################


library(tidyverse)
library(leaflet)
library(sf)
library(here)
source(here::here("code","file_names.R"))


# Read in and prepare data


pours     <- sf::read_sf("/home/shares/ohi/git-annex/land-based/wastewater/data/processed/N_effluent_output/pourpoints_N_Alldata.shp")
pours_crs <- sf::read_sf(N_pourpoints_fn)

# set the crs
used_crs <- st_crs(pours_crs)
st_crs(pours) <- used_crs


total_pours <- pours %>% 
  distinct(basin_id, .keep_all = TRUE) %>% 
  select(sum, effluent_o, effluent_s, effluent_t) %>% 
  #mutate(norm_eff = effluent_a/area) %>% 
  arrange(-sum) %>% 
  head(100) %>% 
  mutate(rank = 1:nrow(.), 
         opp_rank = rev(rank)) %>% 
  mutate(
    perc_open = round((effluent_o/ sum)*100,1),
    perc_septic = round((effluent_s/ sum)*100,1),
    perc_treated = round((effluent_t/ sum)*100,1)
  ) %>% 
  mutate(
    dominated = case_when(
      perc_open > perc_septic & perc_open > perc_treated ~ "open",
      perc_septic > perc_open & perc_septic > perc_treated ~ "septic" , 
      perc_treated > perc_open & perc_treated > perc_septic ~ "treated"
    )
  )


norm_pours <- pours %>% 
  mutate(norm_eff = effluent_a/area)%>%
  distinct(basin_id, .keep_all = TRUE) %>% 
  arrange(-norm_eff) %>% 
  head(100) %>% 
  #select(sum, effluent_o, effluent_s, effluent_t) %>% 
  mutate(rank = 1:nrow(.),
         opp_rank = rev(rank)) %>% 
  mutate(
    perc_open = round((effluent_o/ sum)*100,1),
    perc_septic = round((effluent_s/ sum)*100,1),
    perc_treated = round((effluent_t/ sum)*100,1)
  ) %>% 
  mutate(
    dominated = case_when(
      perc_open > perc_septic & perc_open > perc_treated ~ "open",
      perc_septic > perc_open & perc_septic > perc_treated ~ "septic" , 
      perc_treated > perc_open & perc_treated > perc_septic ~ "treated"
    )
  )


  

tot_factpal <- colorFactor(c("blue", "red", "green"),  total_pours$dominated)
norm_factpal <- colorFactor(c("blue", "red", "green"), norm_pours$dominated)

pour_map <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data =total_pours,
                   popup = paste("Rank", total_pours$rank, "<br>",
                                 "Open", total_pours$perc_open,"%", "<br>",
                                 "Septic:", total_pours$perc_septic,"%", "<br>",
                                 "Treated:", total_pours$perc_treated,"%", "<br>"),
                   radius = ~opp_rank/8,
                   fillColor = ~tot_factpal(dominated),
                   color = 'black',
                   stroke = TRUE,
                   opacity = 1,
                   weight = 2,
                   fillOpacity = 0.2,
                   group = "Top 100 Total Effluent") %>%
  
  addCircleMarkers(data =norm_pours,
                   popup = paste("Rank", norm_pours$rank, "<br>",
                                 "Open", norm_pours$perc_open,"%", "<br>",
                                 "Septic:", norm_pours$perc_septic,"%", "<br>",
                                 "Treated:", norm_pours$perc_treated,"%", "<br>"),
                   radius = ~opp_rank/8,
                   fillColor = ~norm_factpal(dominated),
                   color = 'black',
                   stroke = TRUE,
                   opacity = 1,
                   weight = 2,
                   fillOpacity = 0.2,
                   group = "Top 100 Normalized Effluent") %>%
  
  
  
  addLayersControl(overlayGroups = c("Top 100 Total Effluent",
                                     "Top 100 Normalized Effluent"),
                   options = layersControlOptions(collapsed = FALSE)) %>% 
  
  
  hideGroup(c("Top 100 Normalized Effluent")) %>% 
  
  addLegend("bottomleft",
            colors = c("blue", "red", "green"),
            labels = c("open", "septic", "treated"),
            title = "Major Treatment Contributer",
            opacity = 0.9,
            group = "FIO")

htmlwidgets::saveWidget(pour_map, "pourpoint_webmap.html")
