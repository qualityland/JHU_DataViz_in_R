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
                    "GBR_SCO", "GBRTENW", "NZL_NP"))

# add column: Country
mort <- mort %>% 
  dplyr::left_join(rbind(countries, missing_countries), by = "CountryCode") %>% 
  relocate("Country")

# any NAs?
summary(mort)

# show
mort %>% 
  select(c(1, 2)) %>% 
  distinct()

readr::write_csv(mort, "05_data_viz_capstone/data/mortality.csv")

df <- read_csv("05_data_viz_capstone/data/mortality.csv")
write_rds(df, "05_data_viz_capstone/data/mortality.rds", compress = "xz")
df2 <- read_rds("05_data_viz_capstone/data/mortality.rds")
identical(df, df2)

# explore some years
df %>% 
  select(Country, Year, Week, Sex, DTotal) %>% 
  filter(Country == "Switzerland", Year %in% c(2020, 2022), Sex == "b") %>% 
  mutate(Year = factor(Year)) %>% 
  group_by(Year) %>% 
  ggplot(aes(x = Week, y = DTotal, color=Year)) +
  geom_line()

# DOES NOT WORK!!!
u <- "https://github.com/qualityland/JHU_DataViz_in_R/blob/main/05_data_viz_capstone/data/mortality.rds"
mortality <- read_rds(url(u, method = "libcurl"))
