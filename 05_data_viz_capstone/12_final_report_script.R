library(flexdashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(shiny)

###################                   Setup                  ###################

# Countries
countries_list <- tribble(
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
df_mort <- read_csv(url(stmf_url), skip = 2)

# joining country names
df_mort <- df_mort %>% 
  dplyr::left_join(countries_list, by = "CountryCode") %>% 
  relocate("Country")

# country drop down list
countries_list <- df_mort %>%
  select(Country) %>% 
  unique() %>% 
  arrange(Country)


# Years available for a specific Country
df_mort %>% 
  filter(Country == "Switzerland") %>% 
  select(Year) %>% 
  unique() %>% 
  arrange(Year) %>% 
  as_vector()

###################                   Graphs                 ###################

# CDR
# Crude Death Rate for several Countries
# https://en.wikipedia.org/wiki/Mortality_rate#Crude_death_rate,_globally
df_mort %>% 
  filter(Country %in% c("Germany", "Switzerland", "Italy", "France", "USA"),
         Sex == "b") %>% 
  mutate(population = DTotal / RTotal, Year = ymd(Year, truncated = 2)) %>% 
  group_by(Year, Country) %>% 
  summarise(CDR = sum(DTotal) / sum(population), .groups = "drop") %>% 
  ggplot(aes(x = Year, y = CDR, color = Country)) +
  geom_line(size = 1) +
  ylab("Crude Death Rate")




# one Coutry, multiple Years
# Line Graphs, Switzerland, 2019 - 2022
df_mort %>% 
  filter(Year > 2018,
         Country == "Switzerland",
         Sex == "b") %>% 
  mutate(Year = factor(Year)) %>% 
  group_by(Year, Country) %>% 
  ggplot(aes(x = Week, y = RTotal * 10^3, color = Year)) +
  geom_line() +
  labs(
    title="relative Mortality in Switzerland",
    x="Week of the Year",
    y="Death Rate")


# multiple Counties, same Year
df_mort %>% 
  filter(
    Country %in% c("France", "Germany", "Switzerland", "England & Wales",
                   "Sweden", "United States of America"),
    Sex == "b",
    Year == 2022) %>% 
  mutate(Year = factor(Year)) %>% 
  group_by(Year, Country) %>% 
  ggplot(aes(x = Week, y = RTotal, color = Country)) +
  geom_line() +
  labs(
    title="relative Mortality for different Countries",
    x="Week of the Year",
    y="Deathrate")


# Age Groups
# Absolute Deaths
# Area Plot
df_mort %>% 
  filter(CountryCode == "CHE",
         Year == 2021,
         Sex == "b") %>% 
  select(Country, Year, Week, D0_14, D15_64, D65_74, D75_84, D85p) %>% 
  pivot_longer(
    cols = starts_with("D"),
    names_to = "Age",
    names_prefix = "D",
    values_to = "Deaths") %>% 
  mutate(Age = recode(Age,
                      `0_14` = "0 - 14 years",
                      `15_64` = "15 - 64 years",
                      `65_74` = "65 - 74 years",
                      `75_84` = "75 - 84 years",
                      `85p` = "85+ years")) %>% 
  mutate(Age = factor(Age, )) %>% 
  ggplot(aes(Week, Deaths, fill = Age)) +
  geom_area(position = position_stack(reverse = TRUE)) +
  labs(
    title="Death Rates",
    subtitle="Absolute Numbers - depending on Countries Population",
    x="Week of the Year",
    y="Deaths / Week") +
  guides(fill = guide_legend(reverse=T))
  

# Bar Plot
df_mort %>% 
  filter(CountryCode == "CHE",
         Year == 2021,
         Sex == "b") %>% 
  select(Country, Year, Week, D0_14, D15_64, D65_74, D75_84, D85p) %>% 
  pivot_longer(
    cols = starts_with("D"),
    names_to = "Age",
    names_prefix = "D",
    values_to = "Deaths") %>% 
  mutate(Age = recode(Age,
                      `0_14` = "0 - 14 years",
                      `15_64` = "15 - 64 years",
                      `65_74` = "65 - 74 years",
                      `75_84` = "75 - 84 years",
                      `85p` = "85+ years")) %>% 
  mutate(Age = factor(Age, )) %>% 
  ggplot(aes(Week, Deaths, fill = Age)) +
  geom_col(position = position_stack(reverse = TRUE)) +
  guides(fill = guide_legend(reverse=T))


