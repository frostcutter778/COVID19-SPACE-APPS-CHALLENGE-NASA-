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

nc_data <- nc_open('AERDB_M3_VIIRS_SNPP.A2020001.001.2020039000707.nc')
# Save the print(nc) dump to a text file

{
  sink('AERDB_M3_VIIRS_SNPP.A2020001.001.2020039000707.txt')
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
  
  titletext <- "Aerosol_Optical_Thickness_550nm_Land_Ocean_Maximum__ENSEMBLE__ (April,2019)"
  
  expand.grid(lon, lat) %>%
    
    rename(lon = Var1, lat = Var2) %>%
    
    mutate(lon = 
             ggplot(), 
             #ifelse(lon > 180, -(360 - lon), lon),
             
             tas = as.vector(tas)) %>% 
    
    
    geom_point(aes(x = lon, y = lat, color = tas),
               
               size = 0.8) + 
    
    borders("world", colour="black", fill=NA) + 
    
    scale_color_viridis(na.value="white",name = "Aerosol_Optical_Thickness(Units of 1)") + 
    
    theme(plot.title = element_text(hjust = 0.5),legend.direction="vertical", legend.position="right", legend.key.width=unit(0.4,"cm"), legend.key.heigh=unit(2,"cm")) + 
    
    coord_quickmap() + 
    
    ggtitle(titletext) 
  
}

mapCDFtemp(lat,lon,my.array)






fillvalue <- ncatt_get(nc_data, "OCSMASS", "_FillValue")
fillvalue

nc_close(nc_data) #closing the netCDF file

#==================================================

my.array[my.array == fillvalue$value] <- NA


r <- raster(t(my.array), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

r <- flip(r, direction='y')

plot(r)

writeRaster(r, "MERRA2_400.tavgM_2d_aer_Nx.202003.tif", "GTiff", overwrite=TRUE)

#=======================================================

r_brick <- brick(my.array, xmn=min(lat), xmx=max(lat), ymn=min(lon), ymx=max(lon),
                 crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

# note that you may have to play around with the transpose 
#(the t() function) and flip() before the data are oriented correctly. 
#In this example, the netcdf file recorded latitude on the X and longitude on the Y, 
#so both a transpose and a flip in the y direction were required.

r_brick <- flip(t(r_brick), direction='y')


fname <- "MERRA2_400.tavgM_2d_aer_Nx.202003.nc4" #You will need to specify your location here
HadISST.b <- brick(fname) 

r <- HadISST.b
r[r < -300] <- NA

png(filename = 'save2.png')

plot(HadISST.b)

dev.off()


















