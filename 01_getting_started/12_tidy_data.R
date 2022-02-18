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

### Tidy Data

table1

# compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)

# count cases for each year
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


### Pivoting

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
    names_to = "year",            # must be quoted
    values_to = "population"      # since these columns do not yet exist
  )
tidy4b

# put "cases" and "population" together
left_join(tidy4a, tidy4b, by = c("country", "year"))

# Problem: one variable is spread across multiple rows
# Result: variables are values in cells
# here: "cases" and "population" are values in column "type",
#       but should be columns
table2
# tidy by separating these variables
table2 %>% 
  pivot_wider(
    names_from = type,            # no quotes needed
    values_from = count           # since already a column
  )

# Exercises
# 1. Why are pivot_longer() and pivot_wider() not perfectly symmetrical?
#    Carefully consider the following example:
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(    1,    2,    1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

stocks %>%
  pivot_wider(
    names_from = year,
    values_from = return) %>%
  pivot_longer(
    cols = c(`2015`, `2016`),
    names_to = "year",
    values_to = "return",
    names_transform = list(year = as.numeric) # fix wrong data type
  )

# 2. Why does this code fail?
table4a %>%
  pivot_longer(cols = c(1999, 2000),
               names_to = "year",
               values_to = "cases")
# column names have to be:
#   - non-syntactic c(`1999`, `2000`) or
#   - characters c("1999", "2000")

# 3. What would happen if you widen this table? Why?
#    How could you add a new column to uniquely identify each value?
people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
people %>%pivot_wider(names_from = "names",
                      values_from = "values")


# 4. Tidy the simple tibble below.
#    Do you need to make it wider or longer? What are the variables?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)
preg
preg %>%
  pivot_longer(
    cols = c("male", "female"),
    names_to = "sex",
    values_to = "count",
    values_drop_na = TRUE
  )


### Separating and Uniting

table3

# separate "cases" and "population" from "rate"
table3 %>% 
  separate(col = "rate", into = c("cases", "population"))
# with type conversion (make "cases" and "population" integers)
table3 %>% 
  separate(col = "rate", into = c("cases", "population"), convert = TRUE)

table5
# unite "century" and "year"
table5 %>% 
  unite(col = "new", c("century", "year"), sep = "") %>% 
  mutate(across(new, as.integer))

# Exercises
# 1. What do the extra and fill arguments do in separate()?
#    Experiment with the various options for the following two toy datasets.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))
# merge extra values in last column
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
# fill missing values on the right
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill="right", remove = FALSE)
# 2. Both unite() and separate() have a remove argument. What does it do?
#    Why would you set it to FALSE?

#    To compare with the original column
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(
    col = x,
    into = c("one", "two", "three"),
    fill="right",
    remove = FALSE)

### Missing Values

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
# Q4/2015 is explicitly missing (NA)
# Q1/2016 is implicitly missing (no row!)
stocks
# make implicitly missing values explicit
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year")
# using complete()
stocks %>% 
  complete(year, qtr)

# here: missing data means "take previous value forward"
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment
# this can be accomplished using fill()
treatment %>% 
  fill(person)


### Case Study

# WHO Tuberculosis report 2014
who

# put 
who1 <- who %>%
  pivot_longer(
    new_sp_m014:newrel_f65,
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  )
who1 %>% count(key)

# correct inconsistent keys (newrel instead of new_rel)
who2 <- who1 %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

# separate if case is "new", the TB "type" 
# from the combination of "sex" and "age"
who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3

# are all cases new? yes
who3 %>% 
  count(new)

# let's remove "new" and redundant country information (iso2/iso3)
who4 <- who3 %>% select(-new, -iso2, -iso3)
who4

# now separate "sex" from "age" (by position)
who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5


# the whole procedure in one step
who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)
