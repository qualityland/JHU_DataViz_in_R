library(flexdashboard)
library(tidyverse)
library(plotly)
library(shiny)
library(ISOweek)

mort <- 
  "https://raw.githubusercontent.com/qualityland/JHU_DataViz_in_R/main/05_data_viz_capstone/data/mortality.csv"
df <- read_csv(url(mort))
df

# Line Graphs, Switzerland, 2019 - 2022
df %>% 
  filter(Year > 2018, CountryCode == "CHE") %>% 
  mutate(Year = factor(Year)) %>% 
  group_by(Year, CountryCode) %>% 
  ggplot(aes(x = Week, y = DTotal, color = Year)) +
  geom_line() +
  labs(
    title="Mortality in Switzerland",
    x="Week of the Year",
    y="Number of Deaths")


# Bar Plots, Switzerland
df_by_age <- df %>% 
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
