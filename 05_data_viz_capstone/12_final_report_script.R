library(flexdashboard)
library(tidyverse)
library(lubridate)
library(plotly)
library(shiny)
library(ISOweek)

url_node = "https://raw.githubusercontent.com"
url_dir = "/qualityland/JHU_DataViz_in_R/main/05_data_viz_capstone/data/"
url_file = "mortality_2022-08-11.csv"
data_file = paste0(url_node, url_dir, url_file)
df_mort <- read_csv(url(data_file))

df_mort

# Years available for a specific Country
df_mort %>% 
  filter(Country == "Switzerland") %>% 
  select(Year) %>% 
  unique() %>% 
  arrange(Year) %>% 
  as_vector()

# df %>% 
#   group_by(Country) %>% 
#   summarize(MinYear = min(Year),
#             MaxYear = max(Year)) %>% 
#   arrange(desc(MinYear)) %>% 
#   as.data.frame()

# Crude Death Rate for several Countries
# https://en.wikipedia.org/wiki/Mortality_rate#Crude_death_rate,_globally
df_mort %>% 
  filter(Country %in% c("Germany", "Switzerland", "Italy", "France", "USA")) %>% 
  mutate(population = DTotal / RTotal, Year = ymd(Year, truncated = 2)) %>% 
  group_by(Year, Country) %>% 
  summarise(CDR = sum(DTotal) / sum(population), .groups = "drop") %>% 
  ggplot(aes(x = Year, y = CDR, color = Country)) +
  geom_line(size = 1) +
  ylab("Crude Death Rate")





# Line Graphs, Switzerland, 2019 - 2022
df_mort %>% 
  filter(Year > 2018, Country == "Switzerland") %>% 
  mutate(Year = factor(Year)) %>% 
  group_by(Year, Country) %>% 
  ggplot(aes(x = Week, y = RTotal * 10^3, color = Year)) +
  geom_line() +
  labs(
    title="relative Mortality in Switzerland",
    x="Week of the Year",
    y="Death Rate")



df_mort %>% 
  filter(
    Country %in% c("France", "Germany", "Switzerland", "Wales & England",
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
df_mort %>% 
  filter(CountryCode == "CHE", Year == 2021) %>% 
  select(Country, Year, Week, D0_14, D15_64, D65_74, D75_84, D85p, DTotal) %>% 
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
                      `85p` = "85+ years",
                      `Total` = "all ages")) %>% 
  mutate(Age = factor(Age)) %>% 
  ggplot(aes(Week, Deaths, color = Age)) +
  geom_line()



# Bar Plots, Switzerland
df_mort %>% 
  filter(CountryCode == "CHE") %>% 
  select(Country, CountryCode, Year, Week, D0_14, D15_64, D65_74, D75_84,  D85p) %>% 
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
  mutate(Age = factor(Age)) %>% 
  mutate(RDate = paste0(Year, "-W", Week, "-1"))

df_by_age
any(is.na(df_by_age$RDate))

# Barplots - by Age Group and Year
ggplot(df_by_age, aes(x = Age, y = Deaths, fill = Age)) +
geom_col() +
facet_wrap(~Year)

library(ISOweek)
ISOweek2date("2020-W53-1")


# ISOweek experiments
w <- paste("2009-W53", 1:7, sep = "-")
data.frame(weekdate = w, date = ISOweek2date(w))
# convert from calendar date to week date and back to calendar date
x <- paste(1999:2011, "-12-31", sep = "")
w <- date2ISOweek(x)
d <- ISOweek2date(w)
data.frame(date = x, weekdate = w, date2 = d)
