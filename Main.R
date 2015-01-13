# Team: ZeaPol   
# Team Members: Roeland de Koning / Barbara Sienkiewicz    
# Date: 12/01/2015       
# Exercise 6

library(raster)
library(rgeos)
library(rgdal)
library(maptools)


load("data/GewataB1.rda")
load("data/GewataB5.rda")
load("data/GewataB7.rda")
load("data/GewataB2.rda")
load("data/GewataB3.rda")
load("data/GewataB4.rda")

load("data/vcfGewata.rda")

load("data/lulcGewata.rda")
load("data/LUTGewata.rda")

gewata <- brick(GewataB1,GewataB2, GewataB3, GewataB4, GewataB5, GewataB7)
names(gewata) <- c("band1", "band2", "band3", "band4",  "band5", "band7")

gewata <- calc(gewata, fun=function(x) x / 10000)

vcfGewata[vcfGewata > 100] <- NA
plot(vcfGewata)
names(vcfGewata) <- c("VCF")
summary(vcfGewata)

gewatavcf <-  addLayer(gewata,vcfGewata)

ndvi <- overlay(GewataB4, GewataB3, fun=function(x,y){(x-y)/(x+y)})

lulc <- as.factor(lulcGewata)
levels(lulc) <- LUTGewata
classes <- layerize(lulc)
names(classes) <- LUTGewata$Class
plot(classes, legend=FALSE)
forest <- classes$forest
forest[forest==0] <- NA
plot(forest, col="dark green", legend=FALSE)
gewataforest <- mask(gewatavcf,forest, filename = "output/LandSatBandsVCFForestRelationship", overwrite = T)
plot(gewataforest)

