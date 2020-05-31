
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

nc_data <- nc_open('CRUTEM.4.6.0.0.anomalies.nc')
# Save the print(nc) dump to a text file

{
  sink('CRUTEM.4.6.0.0.anomalies.txt')
  print(nc_data)
  sink()
}


#get longitutes and latitudes 

lon <- ncvar_get(nc_data, "longitude")
lat <- ncvar_get(nc_data, "latitude", verbose = F)
t <- ncvar_get(nc_data, "time")

tunits <<- ncatt_get(nc_data,"time","units") 
tunits

head(lon) # look at the first few entries in the longitude vector

dname <- "temperature_anomaly"

my.array <- ncvar_get(nc_data,dname) # store the data in a 3-dimensional array
dim(my.array)



dlname <- ncatt_get(nc_data,dname,"long_name") 

dunits<- ncatt_get(nc_data,dname,"units") 

fillvalue <- ncatt_get(nc_data,dname,"_FillValue")

# split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth = as.integer(unlist(tdstr)[2])
tday = as.integer(unlist(tdstr)[3])
tyear = as.integer(unlist(tdstr)[1])
chron(t, origin = c(tmonth, tday, tyear))

#get the global attributes

title <- ncatt_get(nc_data, 0, "title")
institution <- ncatt_get(nc_data, 0, "institution")
datasource <- ncatt_get(nc_data, 0, "source")
references <- ncatt_get(nc_data, 0, "references")
history <- ncatt_get(nc_data, 0, "history")
Conventions <- ncatt_get(nc_data, 0, "Conventions")



#image(lon, lat, my.array, col = rev(brewer.pal(10, "RdBu")))


nc_close(nc_data)


m <- 2043 

#2043th month: march 2020  

#2031th month: march 2019


#slicing the array in according to months
slice.array <- my.array[, , m]


mapCDFtemp <- function(lat,lon,tas) #model and perc should be a string
  
{
  
  titletext <- "temperature_anomaly for March 2020"
  
  expand.grid(lon, lat) %>%
    
    rename(lon = Var1, lat = Var2) %>%
    
    mutate(lon = ifelse(lon > 180, -(360 - lon), lon),
           
           tas = as.vector(tas)) %>% 
    
    ggplot() + 
    
    geom_point(aes(x = lon, y = lat, color = tas),
               
               size = 3.0) + 
    
    borders("world", colour="black", fill=NA) + 
    
    scale_color_viridis(na.value="white",name = "temperature(K)") + 
    
    theme(plot.title = element_text(hjust = 0.5),legend.direction="vertical",
          legend.position="right", legend.key.width=unit(0.4,"cm"), legend.key.heigh=unit(2,"cm")) + 
    
    coord_quickmap() + 
    
    ggtitle(titletext) 
  
}

mapCDFtemp(lat,lon,slice.array)






