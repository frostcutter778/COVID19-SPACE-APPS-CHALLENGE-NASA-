library(dplyr)
library(ggplot2)

#Loading the data into R
dat <- read.csv('exchangeRate_data.csv')

dat<- filter(dat, CURRENCY != "Indonesian rupiah")


#creating the plot in png device
png("exchange_rate.png",height = 500, width = 800 )

dat$CURRENCY <- as.factor(dat$CURRENCY)

ggplot() + 
  geom_point(data =dat, aes(x = CURRENCY, y =X2019.mean.,color='red'),shape=15) +
  geom_point(data = dat, aes(x = CURRENCY, y =X2020.mean.,color='black'),shape=0)+
  theme(axis.text.x = element_text(angle = 90),plot.title = element_text(hjust = 0.5))+
  ggtitle('Comparison of Mean Exchange Rate of different Countries')+
  labs(y= "Values", x = "Currency")+
  scale_color_identity(name = "Year",
                       breaks = c("red", "black"),
                       labels = c("2019","2020"),
                       guide = "legend")


#closing the png device , it's important !
dev.off()

