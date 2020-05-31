library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
library(RColorBrewer)
library(dplyr)
library(magrittr)
library(tidyr)
library(ggmap)
library(chron)
library(weathermetrics)
library(lattice)
library(viridis)
library(maps)

nc_data <- nc_open('AERDB_M3_VIIRS_SNPP.A2019060.001.2019098000613.nc')
# Save the print(nc) dump to a text file

{
  sink('AERDB_M3_VIIRS_SNPP.A2019060.001.2019098000613.txt')
  print(nc_data)
  sink()
}


#get longitutes and latitudes 

lon <- ncvar_get(nc_data, "Longitude_1D")
lat <- ncvar_get(nc_data, "Latitude_1D", verbose = F)
#t <- ncvar_get(nc_data, "time")

#tunits <<- ncatt_get(nc_data,"time","units") 
#tunits

head(lon) # look at the first few entries in the longitude vector

my.array <- ncvar_get(nc_data, "Aerosol_Optical_Thickness_550_Land_Ocean_Maximum") # store the data in a 3-dimensional array
dim(my.array)



dlname <- ncatt_get(nc_data,"Aerosol_Optical_Thickness_550_Land_Ocean_Maximum","long_name") 

dunits<- ncatt_get(nc_data,"Aerosol_Optical_Thickness_550_Land_Ocean_Maximum","units") 

fillvalue <- ncatt_get(nc_data,"Aerosol_Optical_Thickness_550_Land_Ocean_Maximum","_FillValue")


#image(lon, lat, my.array, col = rev(brewer.pal(10, "RdBu")))


nc_close(nc_data)


mapCDFtemp <- function(lat,lon,tas) #model and perc should be a string
  
{
  
  titletext <- "Aerosol_Optical_Thickness_550nm_Land_Ocean_Maximum__ENSEMBLE__ (March,2019)"
  
  expand.grid(lon, lat) %>%
    
    rename(lon = Var1, lat = Var2) %>%
    
    mutate(lon = ifelse(lon > 180, -(360 - lon), lon),
           
           tas = as.vector(tas)) %>% 
    
    ggplot() + 
    
    geom_point(aes(x = lon, y = lat, color = tas),
               
               size = 0.8) + 
    
    borders("world", colour="black", fill=NA) + 
    
    scale_color_viridis(na.value="white",name = "Aerosol_Optical_Thickness(Units of 1)") + 
    
    theme(plot.title = element_text(hjust = 0.5),legend.direction="vertical", legend.position="right", legend.key.width=unit(0.4,"cm"), legend.key.heigh=unit(2,"cm")) + 
    
    coord_quickmap() + 
    
    ggtitle(titletext) 
  
}

mapCDFtemp(lat,lon,my.array)


