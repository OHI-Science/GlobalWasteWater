library(tidyverse)
library(leaflet)

tryCatch( source("./file_names.R"), warning=function(cond) {source("code/file_names.R")} )

# These plume tiles were exported with QTiles QGIS plugin in WMTS ordering
tile_dir_url <- "https://aurora.nceas.ucsb.edu/~jkibele/tiles/effluent/{z}/{x}/{y}.png"
# The impact tiles were exported using gdal2tiles in TMS order
# explanation here: https://github.com/jkibele/whathaveidone/blob/master/geospatial/tiles.md
imapact_url <- "https://aurora.nceas.ucsb.edu/~jkibele/tiles/effluent_impact/{z}/{x}/{y}.png"
bg_url <- 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png'
bg_attr <- '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
bg_lbl_url <- 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_only_labels/{z}/{x}/{y}{r}.png'
esri_img_url <- 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
esri_attr <-  'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
  
make_webmap <- function() {
  hotspots <- sf::read_sf(hotspots_fn)
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
    addTiles(urlTemplate = imapact_url,
             group = "Effluent Impact",
             options = tileOptions(minZoom = 1, maxZoom = maxZoom,
                                   opacity = 1.0, tms = TRUE)) %>% 
    addLegend("bottomleft",
              colors = eff_colors,
              labels = impact_labels,
              title = "Effluent Impact",
              opacity = 0.9,
              group = "Effluent Impact") %>% 
    addTiles(urlTemplate = tile_dir_url,
             group = "Effluent Plumes",
             options = tileOptions(minZoom = 1, maxZoom = maxZoom,
                                   opacity = 1.0)) %>% 
    addLegend("bottomleft",
              colors = eff_colors,
              labels = plume_labels,
              title = "Effluent Plumes",
              opacity = 0.9,
              group = "Effluent Plumes") %>% 
    addTiles(urlTemplate = bg_lbl_url,
             group = "Place Names",
             options = tileOptions(minZoom = 1, maxZoom = maxZoom,
                                   opacity = 0.35)) %>% 
    addCircleMarkers(radius = ~pins * 0.01,
                     group = "Hotspots",
                     popup = ~local,
                     color = "darkred",
                     weight = 2,
                     opacity = 0.75,
                     fillOpacity = 0) %>% 
    addLayersControl(
      baseGroups = c( "Map", "Imagery"),
      overlayGroups = c("Hotspots", "Place Names", "Effluent Impact", "Effluent Plumes"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>% 
    hideGroup(c("Effluent Plumes"))

  return(m)
}

m <- make_webmap()

htmlwidgets::saveWidget(m, "~/wastewater/docs/webmap.html")

m
