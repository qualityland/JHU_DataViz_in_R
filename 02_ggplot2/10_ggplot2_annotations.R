library(tidyverse)

# plot and axis titles
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = factor(cyl))) +
  labs(
    x = "Engine displacement (litres)",
    y = "Highway miles per gallon",
    colour = "Number of cylinders",
    title = "Mileage by engine size and cylinders",
    subtitle = "Source: http://fueleconomy.gov"
  )

# mathematical quotes
values <- seq(from = -2, to = 2, by = .01)
df <- data.frame(x = values, y = values ^ 3)
ggplot(df, aes(x, y)) +
  geom_path() +
  labs(y = quote(f(x) == x ^ 3))

# include markdown
df <- data.frame(x = 1:3, y = 1:3)
base <- ggplot(df, aes(x, y)) +
  geom_point() +
  labs(x = "Axis title with *italics* and **boldface**")

base
base + theme(axis.title.x = ggtext::element_markdown())

# font families
df <-
  data.frame(x = 1,
             y = 3:1,
             family = c("sans", "serif", "mono"))
ggplot(df, aes(x, y)) +
  geom_text(aes(label = family, family = family))

# remove overlapping labels
ggplot(mpg, aes(displ, hwy)) +
  geom_text(aes(label = model)) +
  xlim(1, 8)
ggplot(mpg, aes(displ, hwy)) +
  geom_text(aes(label = model), check_overlap = TRUE) +
  xlim(1, 8)

# labels instead of text
labels <- data.frame(
  waiting = c(55, 80),
  eruptions = c(2, 4.3),
  label = c("peak one", "peak two")
)

# text
ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_tile(aes(fill = density)) +
  geom_text(data = labels, aes(label = label))

# label
ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_tile(aes(fill = density)) +
  geom_label(data = labels, aes(label = label))

# prevent overplotting
mini_mpg <- mpg[sample(nrow(mpg), 20), ]
ggplot(mpg, aes(displ, hwy)) + geom_point(colour = "red") +
  ggrepel::geom_text_repel(data = mini_mpg, aes(label = class))


# custom annotations
presidential <- subset(presidential, start > economics$date[1])

ggplot(economics) +
  geom_rect(
    aes(xmin = start, xmax = end, fill = party),
    ymin = -Inf,
    ymax = Inf,
    alpha = 0.2,
    data = presidential
  ) +
  geom_vline(
    aes(xintercept = as.numeric(start)),
    data = presidential,
    colour = "grey50",
    alpha = 0.5
  ) +
  geom_text(
    aes(x = start, y = 2500, label = name),
    data = presidential,
    size = 3,
    vjust = 0,
    hjust = 0,
    nudge_x = 50
  ) +
  geom_line(aes(date, unemploy)) +
  scale_fill_manual(values = c("blue", "red")) +
  xlab("date") +
  ylab("unemployment")


# common labeling
ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point()

# direct labeling
ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point(show.legend = FALSE) +
  directlabels::geom_dl(aes(label = class), method = "smart.grid")

# colored, bigger points for one manufacturer
p <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(
    data = filter(mpg, manufacturer == "subaru"), 
    colour = "orange",
    size = 3
  ) +
  geom_point() 
# legend
p + 
  annotate(geom = "point", x = 5.5, y = 40, colour = "orange", size = 3) + 
  annotate(geom = "point", x = 5.5, y = 40) + 
  annotate(geom = "text", x = 5.6, y = 40, label = "subaru", hjust = "left")

# arrow
p + 
  annotate(
    geom = "curve", x = 4, y = 35, xend = 2.65, yend = 27, 
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  ) +
  annotate(geom = "text", x = 4.1, y = 35, label = "subaru", hjust = "left")

# gghighlight
ggplot(mpg, aes(displ, hwy, colour = factor(cyl))) +
  geom_point() + 
  gghighlight::gghighlight() + 
  facet_wrap(vars(cyl))
