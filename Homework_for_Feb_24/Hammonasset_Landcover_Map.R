#################
###Information###
#################

#Author: Franco Gigliotti
#Data: "Tidal Marsh Vegetation Classification DEM" provided by Correll et al.
##2019, "Fine-Scale Mapping of Coastal Plant Communities in the Northeastern USA" ;
##DEEP Property shapefile https://ct-deep-gis-open-data-website-ctdeep.hub.arcgis.com/datasets/deep-property-3?geometry=-72.662%2C41.244%2C-72.445%2C41.289
#Class: R Data Visualization
#Assignment: Visualizing Geospatial Data
#Date: 02/22/21


#################
###Description###
#################

#This code generates a .pdf 3m resolution marsh vegetation classification map for 
#Hammonasset Beach State Park in Madison, CT using publicly available landcover
#data from Correll et al. and CT DEEP. 


##############################
###Load Packages and Set WD###
##############################

library(ggplot2)
library(sf)
library(rgdal)
library(raster)
library(RColorBrewer)
library(ggsn)
library(ggmap)
setwd(choose.dir())


##################
###Read in Data###
##################

#Raster file of marsh landcover with 3m resolution
marsh<-raster("3_m_Res_Marsh_Cover/Z_3/Zone3_DEM.tif")
#plot(marsh) #checking to see if read in correctly

#Shapefile of Hammonasset Beach SP from DEEP
#Read in all State Parks shapefile
hamo<-readOGR(dsn = paste0(getwd(),"/DEEP_Property-shp"), layer = "DEP_Property")
#Select just hammonasset parcels
hamo<-hamo[grepl("Hammonasset", hamo@data$PROPERTY),]
plot(hamo) #checking to see if selected correctly (yes)

#Read in base map data for map 2 (using bounding box from hamo shp)
myMap <-get_map(location=hamo@bbox)
plot(myMap) #checking to see if dl correctly (yes)


#######################
###Data Manipulation###
#######################

###Manipulations for map 1
#Reproject hamo shp to projection of marsh raster for cropping
hamo.1<-spTransform(hamo, proj4string(marsh))

#Cropping marsh landcover file to Hammonasset boundary
marsh.1<-crop(marsh,hamo.1)

#Convert to data frame for ggplotting
marsh.1<-as.data.frame(marsh.1, xy=TRUE)

#Same goes for hamo shapefile
hamo.1<-fortify(hamo.1)

#Making marsh landcover values a factor
marsh.1$Zone3_DEM<-ifelse(marsh.1$Zone3_DEM==0,10,marsh.1$Zone3_DEM)
marsh.1$Zone3_DEM<-as.factor(marsh.1$Zone3_DEM)

#Renaming levels to landcover classes
levels(marsh.1$Zone3_DEM)<-c("High Marsh", "Low Marsh", "Mudflat", "Phragmites",
                           "Pool/Panne","Open Water", "Terrestrial Border", "Upland", "No Data")

###Manipulations for map 2
#Temporarily reproject hamo shp to projection of marsh raster for cropping
hamo.tmp<-spTransform(hamo, proj4string(marsh))

#Cropping marsh landcover file to Hammonasset boundary
marsh.2<-crop(marsh,hamo.tmp)

#Now project raster to CRS of hamo shapefile 
marsh.2<-projectRaster(marsh.2, crs = proj4string(hamo), method = "ngb")

#Convert to data frame for ggplotting
marsh.2<-as.data.frame(marsh.2, xy=TRUE)

#Making marsh landcover values a factor
marsh.2$Zone3_DEM<-ifelse(marsh.2$Zone3_DEM==0,10,marsh.2$Zone3_DEM)
marsh.2$Zone3_DEM<-as.factor(marsh.2$Zone3_DEM)

#Renaming levels to landcover classes
levels(marsh.2$Zone3_DEM)<-c("High Marsh", "Low Marsh", "Mudflat", "Phragmites",
                             "Pool/Panne","Open Water", "Terrestrial Border", "Upland", "No Data")


###################
###Plotting Data###
###################

#Selecting colors for landcover type representation on map (color-blind friendly!)
color.fill <- c("#009E73", "#F0E442", "#E69F00", "#CC79A7", 
                "#56B4E9", "#0072B2", "#D55E00", "#999999", "#000000")
#display.brewer.all() #to check out other options for color palettes if desired

###Plot 1###
##Plot of Hammonasset shapefiles overlaid on marsh cover types
pdf("Marshes_of_Hammonasset_State_Park.pdf", width = 11)
plot.1<-ggplot() +
  geom_raster(data = marsh.1, aes(x = x, y = y, fill = Zone3_DEM), alpha = 0.7) +
  scale_fill_manual(values=color.fill, name = "Marsh Cover Type") +
  geom_polygon(data = hamo.1, aes(x = long, y = lat, group = group), 
               color = "black", fill=NA, size = 0.5) +
  coord_fixed() +
  labs(x = "Longitude (UTM)", y = "Latitude (UTM)", 
       title = "Tidal Marshes of Hammonasset State Park, CT") +
  theme(axis.text = element_text(color = "gray10"),  
        axis.title.x = element_text(vjust = 1, size = 15),
        axis.title.y = element_text(angle = 90, vjust = 1, size = 15),
        legend.background = element_rect(color = "gray30"),
        legend.box.background = element_blank(),
        legend.title = element_text(hjust = 0, face = "bold"),
        panel.background = element_rect(fill = "white", color = NA),
        panel.border = element_rect(color = "gray30", fill = NA, size = 1),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 17, hjust = .5, vjust = 1, face = "bold")) +
  scalebar(hamo.1, dist = 0.5, dist_unit = "km", st.size = 3, location = "bottomleft",
            transform = FALSE)
north2(plot.1,symbol = 1, x = 0.76, y = 0.17)
dev.off()

###Plot 2###
##Plot of marsh cover types on basemap (does not work)
ggmap(myMap) + #can't plot both ggmap basemap and raster on same plot...?
  geom_raster(data = marsh.2, aes(x = x, y = y, fill = Zone3_DEM), alpha = 0.7) +
  scale_fill_manual(values=color.fill, name = "Marsh Cover Type") 
  

ggmap(myMap) #Works

ggplot() + #Also works
  geom_raster(data = marsh.2, aes(x = x, y = y, fill = Zone3_DEM), alpha = 0.7) +
  scale_fill_manual(values=color.fill, name = "Marsh Cover Type") 
