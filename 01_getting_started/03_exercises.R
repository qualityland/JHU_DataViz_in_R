# exercises from "R for Data Science", chapter 4, Workflow: basics
# https://r4ds.had.co.nz/workflow-basics.html

library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)
