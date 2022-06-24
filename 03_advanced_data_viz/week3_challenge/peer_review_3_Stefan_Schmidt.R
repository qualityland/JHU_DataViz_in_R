
### Problem 1 ###

library(tidyverse)

Category <- c("Alpha", "Beta", "Zeta")
City <- c("Hong Kong", "London", "Nairobi")
my_dat <- expand_grid(Category, City)
set.seed(84684)
my_dat$Value <- sample(1:10, 9, replace = T)

library(gganimate)
library(gifski)

# PUT YOUR ggplot figure with the appropriate gganimate functions here.
# It will compile in the html R Markdown report.
anim1 <-
  ggplot(my_dat, aes(x = Category, y = Value, fill = City)) +
  geom_col() +
  transition_states(City) +
  enter_fade() +
  exit_fade()

anim1

### Problem 2 ###

# DO NOT MODIFY THIS CHUNK
Response <- c("Energize", "Amazing", "Great")
set.seed(9819)
Energize <-
  tibble(Company = rep("Energize", 100),
         Output = rnorm(100, 50, 20))
set.seed(9819)
Amazing <- tibble(Company = rep("Amazing", 100),
                  Output = rnorm(100, 50, 10))
set.seed(9819)
Great <- tibble(Company = rep("Great", 100),
                Output = rnorm(100, 40, 5))

my_dat <- bind_rows(Energize, Amazing, Great)


library(plotly)
# PUT YOUR ggplotly() figure here. It will compile in the R Markdown report.
ggplotly(
  ggplot(my_dat, aes(x = Company, y = Output, fill = Company)) +
    geom_boxplot()
)

### Problem 3 ###

library(plotly)
Category<-seq(from=1,to=10)
Time<-seq(from=1,to=10)
dat3<-expand_grid(Category,Time)
set.seed(78957)
dat3$Quantity<-runif(100,0,10)
library(plotly)
# PUT YOUR ggplotly() figure here. It will compile in the R Markdown report.
ggplotly(
  ggplot(dat3, aes(x = Category, y = Quantity, frame = Time,
                  ids = Category)) +   # adds the object constancy
    geom_point() +
    geom_segment(aes(x = Category, xend = Category, y = 0, yend = Quantity)) +
    labs(x = "Category", y = "Quantity")
)

  