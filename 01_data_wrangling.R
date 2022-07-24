library(tidyverse)

#### Countries and Country Codes ####

# get country names and country codes
countries <- 
  read_csv(file = "05_data_viz_capstone/data/slim-3.csv",
           col_select = c("name", "alpha-3"))

# change column names
names(countries) <- c("Country", "CountryCode")

# missing countries
missing_countries <- 
  tibble(
    Country = c("Germany", "France", "Northern Ireland", 
                "Scottland", "Wales & England", "New Zealand"),
    CountryCode = c("DEUTNP", "FRATNP", "GBR_NIR",
                    "GBR_SCO", "GBRTENW", "NZL_NP"))
# add missing countries
countries <- rbind(countries, missing_countries)


#### Mortality Data ####

# get mortality data
mort <- read_csv("05_data_viz_capstone/data/stmf.csv", skip = 2)

# add column: Country
mort <- mort %>% 
  dplyr::left_join(countries, by = "CountryCode") %>% 
  relocate("Country")

# select required columns
mort <- mort %>% 
  filter(Sex == "b") %>% 
  select(Country,
         CountryCode,
         Year,
         Week,
         D0_14, D15_64, D65_74, D75_84, D85p, DTotal)

# write csv file
write_csv(mort, "05_data_viz_capstone/data/mortality.csv")

