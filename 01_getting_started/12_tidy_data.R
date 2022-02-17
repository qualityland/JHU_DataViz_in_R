library(tidyverse)

# # extract from tidyr::who
# df <- tribble(
#   ~country,      ~year,  ~cases, ~population,
#   #-------------|-------|-------|------------
#   "Afghanistan",  1999,     745,    19987071,
#   "Afghanistan",  2000,    2666,    20595360,
#   "Brazil",       1999,   37737,   172006362,
#   "Brazil",       2000,   80488,   174504898,
#   "China",        1999,  212258,  1272915272,
#   "China",        2000,  213766,  1280428583
# ) %>% 
#   mutate(
#     across(year, as.integer),
#     across(cases, as.integer),
#     across(population, as.integer)
#   )

# compute rate per 10,000
table1 %>% 
  mutate(rate=cases/population * 10000)

table1 %>% 
  count(year, wt = cases)

# visualize changes over time
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

# Exercises
# 1. Using prose, describe how the variables and observations are organised
#    in each of the sample tables.

# btw: table1, table2, table3...are from tidyr package!
table1 # already tidy
table2 # values for cases and population both in column 'count'
table3 # cases and population in column 'rate' (as character!)
table4a # TB cases (4a) and
table4b # population (4b) in separate data frames

# 2. Compute the rate for table2, and table4a + table4b.
#    You will need to perform four operations:
# a) Extract the number of TB cases per country per year.
# b) Extract the matching population per country per year.
# c) Divide cases by population, and multiply by 10000.
# d) Store back in the appropriate place.

# table2
# a)
c <- table2 %>% 
  filter(type == "cases") %>% 
  rename(cases = count) %>% 
  arrange(country, year) %>% 
  select(cases)
# b)
p <- table2 %>% 
  filter(type=="population") %>% 
  rename(population=count) %>% 
  arrange(country, year) %>% 
  select(population)
# c)
r <- c$cases / p$population * 10000
# d)
df <- table2 %>% 
  filter(type == "cases") %>% 
  arrange(country, year) %>% 
  select(country, year) %>% 
  mutate(cases=c$cases, population=p$population, rate=r)
df
# Which representation is easiest to work with? Which is hardest? Why?


# Pivot

# Problem: one variable is spread across multiple columns
# Result: column names are values, not variables
# here: columns `1999` and `2000` are two observations
#       of the same variable "year"
table4a
# tidy TB cases which pivot_longer()
tidy4a <- table4a %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "cases"
  )
tidy4a
# CAVE: "year" is type character!

table4b
# tidy population
tidy4b <- table4b %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "population"
  )
tidy4b

# put "cases" and "population" together
left_join(tidy4a, tidy4b, by = c("country", "year"))

