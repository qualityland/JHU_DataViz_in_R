library(tidyverse)

mort <- read_csv("05_data_viz_capstone/data/stmf.csv", skip = 2)

#countries <- read_csv("05_data_viz_capstone/data/countries_codes_and_coordinates.csv")
countries <- 
  read_csv(
    "https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/slim-3/slim-3.csv",
    col_select = c("name", "alpha-3"))
names(countries) <- c("Country", "CountryCode")

# check if we have country name for all our country codes
mort_codes <- sort(unique(mort$CountryCode))
country_codes <- sort(unique(countries$CountryCode))
all(mort_codes %in% country_codes)

# which country names are missing?
mort_codes[!(mort_codes %in% country_codes)]
# missing are:
# "DEUTNP"  "FRATNP"  "GBR_NIR" "GBR_SCO" "GBRTENW" "NZL_NP"
# which are:
# "Germany" "France"  "Northern Ireland" "Scottland" "Wales & England" "New Zealand"

missing_countries <- 
  tibble(
    Country = c("Germany", "France", "Northern Ireland", 
                "Scottland", "Wales & England", "New Zealand"),
    CountryCode = c("DEUTNP", "FRATNP", "GBR_NIR",
                    "GBR_SCO", "GBRTENW", "NZL_NP")
  )

# add column: Country
mort <- mort %>% 
  dplyr::left_join(rbind(countries, missing_countries), by = "CountryCode")

# any NAs?
summary(mort)

# show
mort %>% 
  select(c(Country, CountryCode)) %>% 
  distinct()

