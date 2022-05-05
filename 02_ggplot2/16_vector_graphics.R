library(tidyverse)

# line chart
units <- letters[1:2]
time <- seq(1:10)

time_series <- expand.grid(units = units, time = time)

time_series$variable <- runif(20, 0, 5)

line_plot <-
  ggplot(time_series, (aes(
    x = time, y = variable, group = units
  ))) + geom_line()

# scatterplot
x_axis <- seq(1:10)
y_axis <- runif(10, 0, 5)

scatter_dat <- data.frame(x = x_axis, y = y_axis)

scatter_plot <- ggplot(scatter_dat, aes(x = x, y = y)) + geom_point()

# barplot
cases <- letters[1:5]
y_axis1 <- runif(5, 0, 5)
y_axis2 <- runif(5, 0, 5)
y_axis3 <- runif(5, 0, 5)

bar_dat <- data.frame(cases = cases,
                      y1 = y_axis1,
                      y2 = y_axis2,
                      y3 = y_axis3)

long_bar_dat <-
  pivot_longer(bar_dat,
               c("y1", "y2", "y3"),
               names_to = "measure",
               values_to = "value")

bar_plot <-
  ggplot(long_bar_dat, aes(x = cases, y = value, fill = measure)) +
  geom_bar(stat = "identity", position = "dodge")

line_plot
scatter_plot
bar_plot

# setwd(YOUR FILE PATH) -- file location when you ggsave them

ggsave("lineplot.jpg", plot = line_plot)
ggsave("lineplot.pdf", plot = line_plot)

# to save files as .svg from ggsave
#install.packages("svglite")
library(svglite)

ggsave("lineplot.svg", plot = line_plot)
