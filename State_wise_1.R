library(geojsonio)
library(data.table)
library(rgdal)
library(R.utils)
library(satellite)

dt2 = read.csv('dt2.csv')
dt3 = read.csv('dt3.csv')
states <- geojsonio::geojson_read("india_states.geojson", what = "sp")
dt2[471,] 
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

statenames_json = levels(states$NAME_1)
statenames_file = levels(as.factor(dt2$STATE))
statenames = as.data.frame(cbind(NAME_1=statenames_json[-c(6,8,9,19)],STATE= statenames_file[-28]))

statenames$NAME_1 = as.character( statenames$NAME_1 )
statenames$STATE = as.character( statenames$STATE )
statenames[32,] = c('Andhra Pradesh','TELANGANA')

dt3$CPACITY.FACTOR = round((dt3$ACTUAL.GENERATION.MW+0.1)/(dt3$INSTALLED.CAPACITY.MW+0.5),2)

################
states2 = states
states2@data <- merge(states@data, dt3,all.x= T)

m <- leaflet(states2) %>%
  setView(77.229,28.612923, 5) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN')))

pal <- colorNumeric("YlOrRd", NULL)

var = colnames(states2@data)[24]

colnames(states2@data)

colnames(states2@data)
m2 = m %>% addMarkers(data = dt2[dt2$CATEGORY=='HYDRO',], popup = popupTable(dt2[dt2$CATEGORY=='HYDRO',], zcol = c('INSTALLED.CAPACITY.MW','PROGRAM.GENERATION.MW','ACTUAL.GENERATION.MW')),icon = HPP) %>%
    addMarkers(data = dt2[dt2$CATEGORY=='THERMAL',], popup = popupTable(dt2[dt2$CATEGORY=='THERMAL',], zcol = c('INSTALLED.CAPACITY.MW','PROGRAM.GENERATION.MW','ACTUAL.GENERATION.MW')),icon = TPP)%>%
    addMarkers(data = dt2[dt2$CATEGORY=='NUCLEAR',], popup = popupTable(dt2[dt2$CATEGORY=='NUCLEAR',], zcol = c('INSTALLED.CAPACITY.MW','PROGRAM.GENERATION.MW','ACTUAL.GENERATION.MW')),icon = NPP)
m2 = m2 %>% addPolygons(
    fillColor = ~pal(get(var)),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    label = ~paste0(NAME_1, ": ", formatC(get(var), big.mark = ","))) %>%
    leaflet::addLegend(pal = pal, values = ~get(var),title = var , opacity = 1.0,
              labFormat = labelFormat(transform = function(x) x))
