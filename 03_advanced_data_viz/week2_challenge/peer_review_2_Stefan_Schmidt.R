### Problem 1 ###
# Create the following figure, using the data included in the R Markdown file.

library(tidyverse)
library(maps)

# make some data for painting the map
my_world_map <- map_data("world")
countries <- unique(my_world_map$region)
set.seed(987)
some_data_values <- 
  data.frame("region"=countries, "Score"=runif(252,0,100))

# Make sure you install any necessary libraries

# HINT:
# - use the following code to get the colors right
#    scale_fill_distiller(palette=5)
# - make sure you use left_join to combine the data_values above to the world
#    map data in my_world_map

# PUT YOUR CODE HERE
map_data_combined <-
  left_join(my_world_map, some_data_values, by = "region")

ggplot(data = map_data_combined,
       mapping = aes(
         x = long,
         y = lat,
         group = group,
         fill = Score
       )) +
  geom_polygon(color = "black") +
  scale_fill_distiller(palette=5)


### Problem 2 ###
# Create the following figure, using the data included in the R Markdown file.

# DO NOT MODIFY THIS CHUNK
set.seed(15)
Measurement<-rnorm(32,50,1)

# Make sure you load any necessary libraries

# HINT:
# OK - use a filter command to get just maps of Costa Rica, Panama, and Nicaragua
# OK - use a filter command to put in points only for cities with a population of
#   greater than 40,000. This should leave you with 32 cities.
# OK - use add_column to attach the "Measurement" variable to your data, and set
#   that to the color aesthetic when you draw the points.
# OK - set the colors for the city points with scale_color_distiller(palette=7)
# - set the size of all points to the value 5
mid_am <- 
  filter( my_world_map, region %in% c("Costa Rica", "Panama", "Nicaragua"))

mid_am_cities <- 
  filter(
    maps::world.cities,
    country.etc %in% c("Costa Rica", "Panama", "Nicaragua"),
    pop > 40000) %>% 
  add_column(Measurement)

ggplot(data = mid_am,
       mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", fill = "white") +
  geom_point(data = mid_am_cities,
             aes(x = long, y = lat, group = NULL, color = Measurement),
             size = 5) +
  scale_color_distiller(palette=7)


### Problem 3 ###
# Create the following figure, using the data included in the R Markdown file.
# Note that the code in the .rmd file will import a set of simple features data for South America. Make sure you install any necessary packages. 

# INSTALL THESE PACKAGES IF NECESSARY
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)

# DO NOT MODIFY
s_america<-ne_countries(scale="medium",continent='south america',returnclass="sf")

# make sure you load any necessary libraries

# HINT
# - the s_america object created in the chunk above is a simple features object
#   with many columns. Identify the correct column based on the solution figure
#   and use it to color in the choropleth.
# - use scale_fill_distiller and palette 10 to the match the colors.

# PUT YOUR CODE HERE
ggplot() +
  geom_sf(data = s_america, aes(fill = pop_est)) +
  scale_fill_distiller(palette=10)