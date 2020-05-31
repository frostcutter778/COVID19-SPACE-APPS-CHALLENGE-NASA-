library(data.table)
library(ggplot2)

d1 <- read.csv("C:\\Users\\user\\Desktop\\datasciencecoursera\\turn2.csv")
y<- na.omit(d1$X2020Q1)
mean(y)
ggplot() + 
  geom_point(data=d1, aes(x=geo.time,y=X2020Q1,color='red'), shape=15)+
  geom_point(data=d1, aes(x=geo.time,y=X2019Q1,color='blue'), shape=0)+
  theme(axis.text.x = element_text(angle = 90),plot.title = element_text(hjust = 0.5))+
  ggtitle('Comparison of Turnover Index of Countries according to Year ')+
  labs(x="Geo-Location",y="Turnover Index")+
  scale_color_identity(name = "Year",
                       breaks = c("red", "blue"),
                       labels = c("2019","2020"),
                       guide = "legend")
#plot(d1$X2020Q1~d1$geo.time, na.rm=TRUE)
#plot(d1$geo.time,d1$X2019Q1,na.rm=TRUE,type="p",pch=10, xlab="Geo-Location", ylab="Turnover Index, 2015=100(SCA)",main="Turnover Index vs Geo Location(Year 2019-Quarter1)")
abline(lm(d1$X2019Q1~d1$geo.time), col="blue")

median(d1$X2020Q1, na.rm=TRUE)
#2020 Q1 -> Median is 118.4
median(d1$X2019Q1, na.rm=TRUE)
#2019 Q1 -> Median is 122.85
min(d1$X2020Q1, na.rm=TRUE)
#2020 Q1 -> Min is 100.4
min(d1$X2019Q1, na.rm=TRUE)
#2019 Q1 -> Min is 107.5

