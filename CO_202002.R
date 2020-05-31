
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

nc_data <- nc_open('MOP03TM-202002-L3V95.4.1.he5')
# Save the print(nc) dump to a text file

{
  sink('MOP03TM-202002-L3V95.4.1.txt')
  print(nc_data)
  sink()
}


#get xdim and ydim 

prs <- ncvar_get(nc_data, "MOP03/Prs")
xdim <- ncvar_get(nc_data, "MOP03/YDim", verbose = F)
ydim <- ncvar_get(nc_data, "MOP03/XDim")


head(prs) # look at the first few entries in the prs vector

dname <- "Data Fields/APrioriCOTotalColumnDay"

my.array <- ncvar_get(nc_data, dname) # store the data in an array
dim(my.array)



dlname <- ncatt_get(nc_data,dname,"long_name") 

dunits<- ncatt_get(nc_data,dname,"units") 

fillvalue <- ncatt_get(nc_data,dname,"_FillValue")


#image(xdim, ydim, my.array, col = rev(brewer.pal(10, "RdBu")))



nc_close(nc_data)


mapCDFtemp <- function(ydim,xdim,tas) #model and perc should be a string
  
{
  
  titletext <- "A Priori CO Total Column Day (February,2020)"
  
  expand.grid(xdim, ydim) %>%
    
    rename(xdim = Var1, ydim = Var2) %>%
    
    mutate(lon = ifelse(xdim > 180, -(360 - xdim), xdim),
           
           tas = as.vector(tas)) %>% 
    
    ggplot() + 
    
    geom_point(aes(x = xdim, y = ydim, color = tas),
               
               size = 0.8) + 
    
    borders("world", colour="black", fill=NA) + 
    
    scale_color_viridis(na.value="white",name = " CO (mol/cm^2)") + 
    
    theme(plot.title = element_text(hjust = 0.5),legend.direction="vertical",
          legend.position="right", legend.key.width=unit(0.4,"cm"), legend.key.heigh=unit(2,"cm")) + 
    
    coord_quickmap() + 
    
    ggtitle(titletext) 
  
}

mapCDFtemp(xdim,ydim,my.array)













