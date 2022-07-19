library(gridExtra)
library(tidyverse)

data("anscombe")
anscombe

mean(anscombe$x1)
mean(anscombe$x2)
mean(anscombe$x3)
mean(anscombe$x4)

var(anscombe$x1)
var(anscombe$x2)
var(anscombe$x3)
var(anscombe$x4)

mean(anscombe$y1)
mean(anscombe$y2)
mean(anscombe$y3)
mean(anscombe$y4)

var(anscombe$y1)
var(anscombe$y2)
var(anscombe$y3)
var(anscombe$y4)

cor(anscombe$x1,anscombe$y1)
cor(anscombe$x2,anscombe$y2)
cor(anscombe$x3,anscombe$y3)
cor(anscombe$x4,anscombe$y4)


num1 <-ggplot(data=anscombe, aes(x=x1, y=y1)) + 
  geom_point() + 
  geom_smooth(method=lm)+
  xlim(0,20)+ylim(0,15)

num2 <-ggplot(data=anscombe, aes(x=x2, y=y2)) + 
  geom_point() + 
  geom_smooth(method=lm)+
  xlim(0,20)+ylim(0,15)

num3 <-ggplot(data=anscombe, aes(x=x3, y=y3)) + 
  geom_point() + 
  geom_smooth(method=lm)+
  xlim(0,20)+ylim(0,15)

num4 <-ggplot(data=anscombe, aes(x=x4, y=y4)) + 
  geom_point() + 
  geom_smooth(method=lm)+
  xlim(0,20)+ylim(0,15)



grid.arrange(num1,num2,num3,num4)

library(datasauRus)

ggplot(datasaurus_dozen, aes(x=x, y=y, colour=dataset))+
  geom_point()+
  theme_void()+
  theme(legend.position = "none")+
  facet_wrap(~dataset, ncol=3)

unique(datasaurus_dozen$dataset)

