library(sp)
library(rgdal)
library(dplyr)

setwd('D://Documents and Settings/mcooper/GitHub/mongolia-toponyms/')


points <- read.csv('results/supervised2.csv')

poly <- readOGR('data/CHN_adm', 'CHN_adm3')

sel <- poly[poly@data$NAME_1 == 'Nei Mongol', ]

coordinates(points) <- ~longitude + latitude

sp <- SpatialPointsDataFrame(points[ , c('longitude', 'latitude')], points, proj4string=poly@proj4string)

sp@data$Chinese <- sp@data$class == 'Chinese'
sp@data$Mongolian <- sp@data$class == 'Mongolian'
sp@data$Tie <- sp@data$class == 'Tie'

new <- cbind(over(sp, sel), sp@data)

new <- new %>% group_by(ID_3) %>%
  summarize(Chinese = mean(Chinese),
            Mongolian = mean(Mongolian),
            Tie = mean(Tie))

sel@data <- merge(sel@data, new)

writeOGR(sel, 'data', 'Languages.shp', driver='ESRI Shapefile', overwrite_layer = T)
