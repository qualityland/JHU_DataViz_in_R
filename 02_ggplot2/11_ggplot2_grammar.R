library(tidyverse)

# simple plot
ggplot(mpg, aes(displ, hwy, colour = factor(cyl))) +
  geom_point()
