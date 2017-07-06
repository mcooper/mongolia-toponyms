setwd('D://Documents and Settings/mcooper/GitHub/mongolia-toponyms/data/')

library(sp)
library(rgdal)

cn <- readOGR('CHN_adm', 'CHN_adm1')

vills <- read.table(file = 'CN/CN.txt', header=F, sep='\t', quote=NULL, comment='')
names(vills) <- c('geonameid','name','asciiname','alternatenames','latitude','longitude','feature_class','feature_code','country_code','cc2','admin1_code','admin2_code','admin3_code','admin4_code','population','elevation','dem','timezone','modification date')

vills <- SpatialPointsDataFrame(coords = vills[, c('longitude', 'latitude')], data = vills,
                                proj4string =CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

#Jilin, Heilongjiang, Liaoning
sel <- over(vills, as(cn[cn@data$NAME_1 %in% c('Hebei', 'Henan', 'Shaanxi', 'Shandong', 'Shanxi'),], "SpatialPolygons"))

vills <- vills[!is.na(sel), ]

selnames <- c('geonameid', 'name', 'asciiname', 'alternatenames', 'latitude', 'longitude', 'feature_class', 'feature_code')
write.csv(vills@data[ , selnames], '../../mongolia-toponyms/data/china_homeland.csv', row.names=F)
