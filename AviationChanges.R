library(data.table)
library(ggplot2)


d3 <- read.csv("C:\\Users\\user\\Desktop\\datasciencecoursera\\aviationChanges.csv")
ggplot() + 
  geom_point(data=d3, aes(x=Geo,y=X2019.mean.,color='red'), shape=15) +
  geom_point(data=d3,aes(x=Geo,y=X2020.mean.,color='blue'),shape=0) +
  theme(axis.text.x = element_text(angle = 90),plot.title = element_text(hjust = 0.5))+
  ggtitle('Comparison of Mean Number of Passengers on Board in Aviation Fights according to Year ')+
  labs(x="Geo-Location",y="Mean Number Of Passengers On Board")+
  scale_color_identity(name = "Year",
                       breaks = c("red", "blue"),
                       labels = c("2019","2020"),
                       guide = "legend")

