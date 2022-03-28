library(tidyverse)
library(nycflights13)



### data()

# explore the datasets

# datasets in nycflights:
data(package = "nycflights13")
# Data sets in package ‘nycflights13’:
#   
# airlines                   Airline names.
# airports                   Airport metadata
# flights                    Flights data
# planes                     Plane metadata.
# weather                    Hourly weather data

# tibble with 336,776 rows and 19 variables
flights

?flights



### filter() - pick observations by their values

# Jan 1st flights (842 rows)
flights %>% 
  filter(month == 1, day == 1)


# comparisons
# use near() for approximations
# (computers use finite precision arithmetic and
#  can’t store an infinite number of digits!)
sqrt(2) ^ 2 == 2
near(sqrt(2) ^ 2, 2)

1 / 49 * 49 == 1
near(1 / 49 * 49, 1)

# flights in Nov and Dec (55,403 rows)
flights %>% 
  filter(month == 11 | month == 12)
# or
flights %>% 
  filter(month %in% c(11, 12))

# De Morgan’s law:
# !(x & y) is the same as !x | !y
# and !(x | y) is the same as !x & !y
flights %>% 
  filter(!(arr_delay > 120 | dep_delay > 120))
# same as:
flights %>% 
  filter(arr_delay <= 120, dep_delay <= 120)



### arrange() - reorder rows

arrange(flights, desc(year), desc(month), desc(day))
arrange(flights, desc(dep_delay))

# missing values always sorted at the end
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))



### select() - pick variables by their names

select(flights, year, month, day)

# all columns between ... and ... (inclusive)
select(flights, year:day)

# all columns except ...
select(flights, -(year:day))

# helper functions for select:

# starts_with("arr")
select(flights, starts_with("arr"))

# ends_with("time")
select(flights, ends_with("time"))

# contains("dep")
select(flights, contains("dep"))

# matches("(.)\\1"): selects variables that match a regular expression.
# This one matches any variables that contain repeated characters.
select(flights, matches("(.)\\1"))

# num_range("x", 1:3): matches x1, x2 and x3.
df <- tibble(x1=c(5, 2),
             x2=c(4, 1),
             x3=c(3, 2),
             y1=c(2, 7),
             y2=c(1, 2))
select(df, num_range("x", 1:3))

# rename(new = old)
flights %>% 
  select(year, month, day, tailnum) %>%
  rename(tail_num = tailnum)

# everything() - useful to re-arrange variables
select(flights, time_hour, air_time, everything())



### mutate() - add new variables

flights %>%
  select(year:day, ends_with("delay"), distance, air_time) %>%
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )
# you can refer to columns that you’ve just created
flights %>%
  select(year:day, ends_with("delay"), distance, air_time) %>%
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours
  )

# transmute() - keep only the new variables
flights %>%
  select(year:day, ends_with("delay"), distance, air_time) %>%
  transmute(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours
  )

# modular arithmetic
flights %>%
  transmute(dep_time,
            hour = dep_time %/% 100,   # integer division
            minute = dep_time %% 100)  # remainder



### group_by() and summarize()

flights %>%
  group_by(year, month, day) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE))

# group by, summarize and filter
delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")
# then plot
ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# everything at once
flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL") %>% 
  ggplot(aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)


flights %>% 
  filter(dest != "HNL" & air_time < 60)
