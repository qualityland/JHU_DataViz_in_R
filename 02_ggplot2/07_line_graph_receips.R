library(tidyverse)
library(gcookbook)

# using pressure dataset
(pressure)

# line
ggplot(pressure, aes(temperature, pressure)) +
  geom_line()

# line & dots
ggplot(pressure, aes(temperature, pressure)) +
  geom_line() +
  geom_point()

# using BOD dataset (Biochemical Oxygen Demand)
(BOD)
ggplot(BOD, aes(Time, demand)) +
  geom_line()

# expand limits
ggplot(BOD, aes(Time, demand)) +
  geom_line() +
  ylim(0, 30)

# or
ggplot(BOD, aes(Time, demand)) +
  geom_line() +
  expand_limits(y = c(0, 30))

# multiple lines
# map a discrete variable to color or line type

# tooth growth data
(tg)

# color
ggplot(tg, aes(x = dose, y = length, color = supp)) +
  geom_line()

# line type
ggplot(tg, aes(x = dose, y = length, linetype = supp)) +
  geom_line()
