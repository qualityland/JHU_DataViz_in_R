library(flexdashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(shiny)

# Countries
countries <- tribble(
  ~CountryCode, ~Country,
  "AUS",        "Australia",
  "AUT",        "Austria",
  "BEL",        "Belgium",
  "BGR",        "Bulgaria",
  "CAN",        "Canada",
  "CHE",        "Switzerland",
  "CHL",        "Chile",
  "CZE",        "Czechia",
  "DEUTNP",     "Germany",
  "DNK",        "Denmark",
  "ESP",        "Spain",
  "EST",        "Estonia",
  "FIN",        "Finland",
  "FRATNP",     "France",
  "GBRTENW",    "England & Wales",
  "GBR_NIR",    "Northern Ireland",
  "GBR_SCO",    "Scottland",
  "GRC",        "Greece",
  "HRV",        "Croatia",
  "HUN",        "Hungary",
  "ISL",        "Iceland",
  "ISR",        "Israel",
  "ITA",        "Italy",
  "KOR",        "Korea",
  "LTU",        "Lithuania",
  "LUX",        "Luxembourg",
  "LVA",        "Latvia",
  "NLD",        "Netherlands",
  "NOR",        "Norway",
  "NZL_NP",     "New Zealand",
  "POL",        "Poland",
  "PRT",        "Portugal",
  "RUS",        "Russia",
  "SVK",        "Slovakia",
  "SVN",        "Slovenia",
  "SWE",        "Sweden",
  "TWN",        "Taiwan",
  "USA",        "USA")

# use STMF data directly
stmf_url <- 
  "https://mortality.org/File/GetDocument/Public/STMF/Outputs/stmf.csv"
df <- read_csv(url(stmf_url), skip = 2)

# joining country names
df <- df %>% 
  dplyr::left_join(countries, by = "CountryCode") %>% 
  relocate("Country")

# country drop down list
countries <- df %>%
  select(Country) %>% 
  unique() %>% 
  arrange(Country)

#mort <- read_csv("05_data_viz_capstone/data/stmf_2022-08-11.csv", skip = 2)

#countries <- read_csv("05_data_viz_capstone/data/countries_codes_and_coordinates.csv")
# countries <- 
#   read_csv(
#     "https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/slim-3/slim-3.csv",
#     col_select = c("name", "alpha-3"))
# names(countries) <- c("Country", "CountryCode")

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
                "Scottland", "England & Wales", "New Zealand"),
    CountryCode = c("DEUTNP", "FRATNP", "GBR_NIR",
                    "GBR_SCO", "GBRTENW", "NZL_NP"))

# add column: Country
mort <- mort %>% 
  dplyr::left_join(rbind(countries, missing_countries), by = "CountryCode") %>% 
  relocate("Country")

# minimum year that all countries have in common: 2016
mort %>% 
  group_by(Country) %>% 
  summarize(MinYear = min(Year),
            MaxYear = max(Year)) %>% 
  arrange(desc(MinYear)) %>% 
  as.data.frame()


# only filter: both sexes
mort <- mort %>% 
  filter(Sex == "b") %>% 
  mutate(Country = 
           recode(
             Country,
             `Korea, Republic of`="Korea",
             `Russian Federation`="Russia",
             `Taiwan, Province of China`="Taiwan",
             `United States of America`="USA"))


# remove relative mortality and separation of sexes
# mort <- mort %>% 
#   filter(Sex == "b") %>% 
#   select(Country,
#          CountryCode,
#          Year,
#          Week,
#          D0_14, D15_64, D65_74, D75_84, D85p, DTotal)

  


readr::write_csv(mort, "05_data_viz_capstone/data/mortality_2022-08-11.csv")

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


# extract country names and codes
country_codes <- df %>% 
  select(CountryCode, Country) %>% 
  unique()
write_csv(country_codes, "./05_data_viz_capstone/data/country_codes2.csv")


# DOES NOT WORK!!!
u <- "https://github.com/qualityland/JHU_DataViz_in_R/blob/main/05_data_viz_capstone/data/mortality.rds"
mortality <- read_rds(url(u, method = "libcurl"))



