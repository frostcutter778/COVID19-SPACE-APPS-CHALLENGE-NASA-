
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

nc_data <- nc_open('MISR_AM1_CGLS_FEB_2020_F06_0032.nc')
# Save the print(nc) dump to a text file

{
  sink('MISR_AM1_CGLS_FEB_2020_F06_0032.txt')
  print(nc_data)
  sink()
}


#get xdim and ydim 

lon <- ncvar_get(nc_data, "Land_Parameter_Average/Longitude")
lat <- ncvar_get(nc_data, "Land_Parameter_Average/Latitude", verbose = F)

#ydim <- ncvar_get(nc_data, "MOP03/XDim")


head(lon) # look at the first few entries in the prs vector

dname <- "Land_Parameter_Average/NDVI"

my.array <- ncvar_get(nc_data, dname) # store the data in an array
dim(my.array)



dlname <- ncatt_get(nc_data,dname,"long_name") 

dunits<- ncatt_get(nc_data,dname,"units") 

fillvalue <- ncatt_get(nc_data,dname,"_FillValue")


#image(xdim, ydim, my.array, col = rev(brewer.pal(10, "RdBu")))



nc_close(nc_data)


mapCDFtemp <- function(lat,lon,tas) #model and perc should be a string
  
{
  
  titletext <- "NDVI for February 2020"
  
  expand.grid(lon, lat) %>%
    
    rename(lon = Var1, lat = Var2) %>%
    
    mutate(lon = ifelse(lon > 180, -(360 - lon), lon),
           
           tas = as.vector(tas)) %>% 
    
    ggplot() + 
    
    geom_point(aes(x = lon, y = lat, color = tas),
               
               size = 0.8) + 
    
    borders("world", colour="black", fill=NA) + 
    
    scale_color_viridis(na.value="white",name = "NDVI") + 
    
    theme(plot.title = element_text(hjust = 0.5),legend.direction="vertical", legend.position="right", legend.key.width=unit(0.4,"cm"), legend.key.heigh=unit(2,"cm")) + 
    
    coord_quickmap() + 
    
    ggtitle(titletext) 
  
}

mapCDFtemp(lat,lon,my.array)




#r <- raster("MOP03TM-201903-L3V95.4.1.he5",
#var="Data Fields/APrioriCOMixingRatioProfileDay",ncdf=TRUE)

#plot(r)












