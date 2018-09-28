#"http://www.iconsplace.com/icons/preview/maroon/nuclear-power-plant-256.png",
#https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Thermal_power_plant_Icon.svg/2000px-Thermal_power_plant_Icon.svg.png,
#https://cdn0.iconfinder.com/data/icons/energy-technology-1/2048/Water_Dam-512.png

############# ICONS

TPP <- makeIcon(
  iconUrl =  "Thermal_power_plant_Icon.svg.png",
    iconWidth = 20, iconHeight = 20
)

NPP <- makeIcon(
  iconUrl = "nuclear-power-plant-256.png",
  iconWidth = 20, iconHeight = 20
)

HPP <- makeIcon(
  iconUrl = "Water_Dam-512.png",
  iconWidth = 20, iconHeight = 20
)


m <- leaflet(states2) %>%
  setView(77.229,28.612923, 5) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))


#hist(dt3$INST_CAP)
#bins <- c(0:36)
#pal <- colorBin("YlOrRd", domain = states2@data$ID_1, bins = bins)
pal <- colorNumeric("YlOrRd", NULL)

str(pal)
m2 <- m %>% addPolygons(
  fillColor = ~pal(INSTALLED.CAPACITY.MW),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  label = ~paste0(NAME_1, ": ", formatC(INSTALLED.CAPACITY.MW, big.mark = ","))) %>%
  addLegend(pal = pal, values = ~INSTALLED.CAPACITY.MW , opacity = 1.0,
            labFormat = labelFormat(transform = function(x) x))

m4 %>% 
  addMarkers(data = dt2[dt2$CATEGORY=='HYDRO',], popup = popupTable(dt2[dt2$CATEGORY=='HYDRO',], zcol = c('INSTALLED.CAPACITY.MW','PROGRAM.GENERATION.MW','ACTUAL.GENERATION.MW')),icon = HPP)%>%
  addMarkers(data = dt2[dt2$CATEGORY=='THERMAL',], popup = popupTable(dt2[dt2$CATEGORY=='THERMAL',], zcol = c('INSTALLED.CAPACITY.MW','PROGRAM.GENERATION.MW','ACTUAL.GENERATION.MW')),icon = TPP)%>%
addMarkers(data = dt2[dt2$CATEGORY=='NUCLEAR',], popup = popupTable(dt2[dt2$CATEGORY=='NUCLEAR',], zcol = c('INSTALLED.CAPACITY.MW','PROGRAM.GENERATION.MW','ACTUAL.GENERATION.MW')),icon = NPP)


dt2[dt2$CATEGORY=='HYDRO',][190]
