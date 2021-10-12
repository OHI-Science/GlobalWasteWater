library(tidyverse)
library(leaflet)
library(sf)
library(rgdal)
tryCatch( source("./file_names.R"), warning=function(cond) {source("code/file_names.R")} )

# These plume tiles were exported with QTiles QGIS plugin in WMTS ordering
# tile_dir_url <- "https://aurora.nceas.ucsb.edu/~jkibele/tiles/effluent/{z}/{x}/{y}.png"
# The impact tiles were exported using gdal2tiles in TMS order
# explanation here: https://github.com/jkibele/whathaveidone/blob/master/geospatial/tiles.md



#fio_url <- "/home/shares/ohi/git-annex/land-based/wastewater/data/interim/FIO_tiles/{z}/{x}/{y}.png"
#fio_url2    <- "https://aurora.nceas.ucsb.edu/~home/shares/ohi/git-annex/land-based/wastewater/data/interim/FIO_tiles/{z}/{x}/{y}.png"
#fio_url3 <- "https://mazu.nceas.ucsb.edu/~home/shares/ohi/git-annex/land-based/wastewater/data/interim/FIO_tiles"
#imapact_url <- "https://aurora.nceas.ucsb.edu/~jkibele/tiles/effluent_impact/{z}/{x}/{y}.png"




# Read in all the data


## Rasters and tile layers



fio_url <- "https://aurora.nceas.ucsb.edu/~jkibele/tiles/effluent_impact/{z}/{x}/{y}.png"# "https://mazu.nceas.ucsb.edu/wastewater/FIO_tiles/{z}/{x}/{y}.png"
fio_plumes <- "https://mazu.nceas.ucsb.edu/wastewater/fio_plumes/{z}/{x}/{y}.png"


leaflet() %>% 
  addTiles(urlTemplate = fio_url,
           options = tileOptions(minZoom = 1, maxZoom = 8,
                                 opacity = 1.0, tms = TRUE))
## Pour points
fio_points <- "/home/shares/ohi/git-annex/land-based/wastewater/data/processed/FIO_effluent_output/effluent_FIO_pourpoints.shp"
fio_points_filtered <- sf::read_sf(fio_points) %>%
  arrange(-effluent) %>% 
  head(100)



n_points <- "/home/shares/ohi/git-annex/land-based/wastewater/data/processed/N_effluent_output/effluent_N_pourpoints.shp"
n_points_filtered <- sf::read_sf(n_points) %>%
  arrange(-effluent) %>% 
  head(100)






## Watersheds 
 #$%>% #st_simplify(dTolerance = 200)

#fio_tes <- st_transform(fio_watersheds_filtered, "+init=epsg:4326")




# #####Simplify workflow
# 
# # possible libraries 
# library(rmapshaper) 
# library(geojsonio)
# # load data
# fio_watersheds_fn  <- "/home/shares/ohi/git-annex/land-based/wastewater/data/processed/FIO_effluent_output/effluent_FIO_watersheds.shp"
# fio_watersheds_sf  <- sf::read_sf(fio_watersheds_fn) %>% 
#   arrange(-area) %>% 
#   head(1000) #%>% 
#   #rmapshaper::ms_simplify(keep = 0.2, keep_shapes = TRUE)
# 
# # covert the file to proper format for simplification
# watersheds_json    <- geojson_json(fio_watersheds_sf, geometry = "polygon")#, group = "group")
# watersheds_json_sp <- geojson_sp(watersheds_json)
# 
# 
# # Run simplification 
# 
# test1 <- rmapshaper::ms_simplify(fio_watersheds_sf, keep = 0.1, keep_shapes = TRUE) 
# #test2 <- rmapshaper::ms_simplify(watersheds_json, keep = 0.001) 
# test3 <- rmapshaper::ms_simplify(watersheds_json_sp, keep = 0.001,keep_shapes = TRUE) 
# 
# efio_tes <- st_transform(test3, "+init=epsg:4326")


# leaflet test
# bins <- c(0, 100, 1099, 10999, 109998, 1099989, 10999893, 109998931, Inf)
# pal <- colorBin("YlOrRd", domain = fio_watersheds_sf$effluent, bins = bins)
# 
# leaflet() %>% 
#   addTiles() %>%
#   addPolygons(
#     data = fio_tes,
#     fillColor = ~pal(effluent)
#     )



bg_url       <- 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png'
bg_attr      <- '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
bg_lbl_url   <- 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_only_labels/{z}/{x}/{y}{r}.png'
esri_img_url <- 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
esri_attr    <-  'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'




{
make_webmap <- function() {
  hotspots <- fio_points_filtered #sf::read_sf(fio_points)
  maxZoom <- 8
  eff_colors <- c("#ffffad", "#e9a500", "#533100", "#311a00", "#00c634")
  plume_labels <- c("> 0", "3,500", "12,000", "20,000", "100,000 +")
  impact_labels <- c("> 0", "0.13", "0.39", "0.62", "2.05")
  
  m <- leaflet(hotspots) %>% 
     # addProviderTiles(providers$CartoDB.VoyagerNoLabels,
     #                  options = providerTileOptions(opacity = 0.35,
     #                                                maxZoom = 7)) %>% 
    addTiles(urlTemplate = bg_url,
              attribution = bg_attr,
              group = "Map",
              options = tileOptions(minZoom = 1, maxZoom = maxZoom)) %>% 
    addTiles(urlTemplate = esri_img_url,
             attribution = esri_attr,
             group = "Imagery",
             options = tileOptions(minZoom = 1, maxZoom = maxZoom)) %>% 
    addTiles(urlTemplate = fio_url,
             group = "FIO",
             options = tileOptions(minZoom = 1, maxZoom = maxZoom,
                                   opacity = 1.0, tms = TRUE)) %>%
    addTiles(urlTemplate = fio_plumes,
             group = "FIO_plumes",
             options = tileOptions(minZoom = 1, maxZoom = maxZoom,
                                   opacity = 1.0, tms = TRUE)) %>%
    # addPolygons(
    #   data = fio_tes,
    #   group = "watersheds",
    #   fillColor = ~pal(effluent)) %>% 
    addLegend("bottomleft",
              colors = eff_colors,
              labels = impact_labels,
              title = "FIO",
              opacity = 0.9,
              group = "FIO") %>% 

    #addTiles(urlTemplate = tile_dir_url,
    #         group = "Effluent Plumes",
    #         options = tileOptions(minZoom = 1, maxZoom = maxZoom,
    #                               opacity = 1.0)) %>% 
    # addLegend("bottomleft",
    #           colors = eff_colors,
    #           labels = plume_labels,
    #           title = "Effluent Plumes",
    #           opacity = 0.9,
    #           group = "Effluent Plumes") %>% 
    addTiles(urlTemplate = bg_lbl_url,
             group = "Place Names",
             options = tileOptions(minZoom = 1, maxZoom = maxZoom,
                                   opacity = 0.35)) %>% 
    addCircleMarkers(radius = ~effluent * 0.0000001,
                      group = "FIO pour point totals",
                      popup = ~effluent,
                      color = "darkred",
                      weight = 2,
                      opacity = 0.75,
                      fillOpacity = 0) %>% 
    addCircleMarkers(data = n_points_filtered,
                     radius = ~effluent * 0.00000000001,
                     group = "Nitrogen pour point totals",
                     popup = ~effluent,
                     color = "forestgreen",
                     weight = 2,
                     opacity = 0.75,
                     fillOpacity = 0) %>%
    addLayersControl(
      baseGroups = c( "Map", "Imagery"),
      overlayGroups = c("Place Names", "FIO", "FIO_plumes", "Nitrogen pour point totals",  "FIO pour point totals", "watersheds"
                        #"Effluent Plumes"
                        ),
      options = layersControlOptions(collapsed = FALSE)
    ) %>% 
    hideGroup(c("Effluent Plumes", "FIO"))
  
  return(m)
}

m <- make_webmap()

#htmlwidgets::saveWidget(m, "webmap.html")

m
}


