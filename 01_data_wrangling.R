library(tidyverse)

### Countries and Country Codes ###

# countries with country codes
countries <- 
  read_csv(
    "https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/slim-3/slim-3.csv",
    col_select = c("name", "alpha-3"))
names(countries) <- c("Country", "CountryCode")

# mortality data
mort <- read_csv("05_data_viz_capstone/data/stmf.csv", skip = 2)


# some country codes are missing
missing_countries <- 
  tibble(
    Country = c("Germany", "France", "Northern Ireland", 
                "Scottland", "Wales & England", "New Zealand"),
    CountryCode = c("DEUTNP", "FRATNP", "GBR_NIR",
                    "GBR_SCO", "GBRTENW", "NZL_NP"))

# add missing countries
countries <- rbind(countries, missing_countries)

# map countries to country codes
mort_codes <- sort(unique(mort$CountryCode))
country_codes <- tibble(CountryCode = mort_codes)
country_codes <- 
  country_codes %>% 
  left_join(countries, by = "CountryCode")

# write country codes to csv
write_csv(country_codes, "05_data_viz_capstone/data/country_codes.csv")




### Mortality Data ###

mort <- mort %>% 
  filter(Sex == "b") %>% 
  select(CountryCode,
         Year,
         Week,
         D0_14, D15_64, D65_74, D75_84, D85p, DTotal)

write_csv(mort, "05_data_viz_capstone/data/mortality.csv")
