library(tidyverse)
library(nycflights13)

## filter()

flights %>% filter(month == 1, day == 1)      # Jan 1st flights
flights %>% filter(month == 11 | month == 12) # Nov or Dec flights
flights %>% filter(month %in% c(11, 12))      # Nov or Dec flights

# flights with arrival- or department- delay of up to 2 hours
flights %>% filter(!(arr_delay > 120 | dep_delay > 120))
flights %>% filter(arr_delay <= 120, dep_delay <= 120)

colSums(is.na(flights))

# Exercises
# 1. Find all flights that
#  a) Had an arrival delay of two or more hours
flights %>% filter(arr_delay >= 120)

#  b) Flew to Houston (IAH or HOU)
flights %>% filter(dest %in% c("IAH", "HOU"))

#  c) Were operated by United, American, or Delta
flights %>% filter(carrier %in% c("AA", "DL", "UA"))

#  d) Departed in summer (July, August, and September)
flights %>% filter(month >= 7, month <= 9)
flights %>% filter(between(month, 7, 9))
flights %>% filter(month %in% 7:9)

#  e) Arrived more than two hours late, but didn’t leave late
flights %>% filter(arr_delay > 120, dep_delay <= 0)

#  f) Were delayed by at least an hour, but made up over 30 minutes in flight
flights %>% filter(dep_delay >= 60, dep_delay - arr_delay > 30)

#  g) Departed between midnight and 6am (inclusive)
flights %>% filter(dep_time <= 600 | dep_time == 2400)

# 2. Another useful dplyr filtering helper is between(). What does it do?
#    Can you use it to simplify the code needed to answer the previous
#    challenges?
flights %>% filter(between(month, 7, 9))

# 3. How many flights have a missing dep_time?
sum(is.na(flights$dep_time))

#    What other variables are missing?
colSums(is.na(flights))
summary(flights)         # also reports NA's

#    What might these rows represent?
flights %>% filter(is.na(dep_time))
# most probably cancelled flights!

# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing?
#    Why is FALSE & NA not missing? Can you figure out the general rule?
#    (NA * 0 is a tricky counterexample!)


## arrange()

# top department delay is 1301 min - more than 20 hours!
flights %>%
  arrange(desc(dep_delay))

# NA's are always sorted at the end
flights %>% 
  arrange(desc(dep_delay)) %>%
  tail()

