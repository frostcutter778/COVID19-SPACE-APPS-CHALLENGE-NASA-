library(data.table)
library(ggplot2)



d2 <- read.csv("C:\\Users\\user\\Desktop\\datasciencecoursera\\importPriceMean.csv")
head(d2)
#ggplot(data=d2, aes(x=GEO, y=y1), colour=c("blue","green"))
ggplot() + 
  geom_point(data=d2, aes(x=GEO,y=X2019.mean.,color='red'), shape=15) +
  geom_point(data=d2,aes(x=GEO,y=X2020.mean.,color='blue'),shape=0) +
  theme(axis.text.x = element_text(angle = 90),plot.title = element_text(hjust = 0.5))+
  ggtitle('Comparison of Mean Import Price of Countries according to Year ')+
  labs(x="Geo-Location",y="Mean Import Price")+
  scale_color_identity(name = "Year",
                       breaks = c("red", "blue"),
                       labels = c("2019","2020"),
                       guide = "legend")

