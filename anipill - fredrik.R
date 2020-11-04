library(tidyverse)


#read the data with impor dataset
Anipill <- read.csv("Body temp fredrik anipill test.csv")


#View and tidy names (try to make error here):
head(Anipill)
summary(Anipill)
names(Anipill) <- c("Sample", 'date', 'hour', 'Temp')
head(Anipill)

#create datetime column based on date and hour:
Anipill$datetime <- paste(Anipill$date, Anipill$hour)
head(Anipill)

#Format datetime from character to dttm format:
Anipill$datetime <- as.POSIXct(strptime(Anipill$datetime, format= "%d/%m/%Y %H:%M:%S"))

#Generate manual sleep/nosleep score:
sl <- data.frame("Sleep" = c(1:272))
head(sl)

sl$Sleep[1:127] <- 32.5
sl$Sleep[128:167] <- 30
sl$Sleep[168:223] <- 32.5
sl$Sleep[224:263] <- 30
sl$Sleep[264:272] <-32.5

Anipill$sleep <- paste(sl$Sleep)
Anipill$sleep <- as.numeric(Anipill$sleep)


#Filter out outliers:
Anipill<- Anipill %>% 
  filter(Temp > 30)


#Generate x-axis limits vector:
xlims <- as.POSIXct(strptime(c("30/10/2020 12:00:00", "01/11/2020 12:00:00"), format= "%d/%m/%Y %H:%M:%S"))        

#Make ggplot :D
ggplot(Anipill, aes(datetime,Temp))+
  geom_line(color="steelblue")+
  geom_point(color="steelblue", size = .7)+
  scale_y_continuous("Temperature", limits = c(30,40))+
  scale_x_datetime("", limits = xlims)+
  theme_minimal()+
  geom_point(aes(x=datetime, y=sleep, color=sleep), size= .2,show.legend = F)
  
                   