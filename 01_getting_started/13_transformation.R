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

# use desc(<columns>) to change order
flights %>%
  arrange(desc(dep_delay))
# top department delay is 1301 min - more than 20 hours!

# Missing values are ALWAYS sorted at the end
tibble(x = c(5, 2, NA)) %>% 
  arrange(x)

tibble(x = c(5, 2, NA)) %>% 
  arrange(desc(x))

# Exercises
# 1. How could you use arrange() to sort all missing values to the start?
#    Hint: use is.na()
flights %>% 
  arrange(desc(is.na(dep_time)), dep_time)

# 2. Sort flights to find the most delayed flights.
flights %>% 
  arrange(desc(dep_delay))
#    Find the flights that left earliest.
flights %>% 
  arrange(dep_delay)

# 3. Sort flights to find the fastest (highest speed) flights.
flights %>% 
  mutate(v=distance / (air_time / 60)) %>% 
  select(year, month, day, dep_time, arr_time, distance, air_time, v) %>% 
  arrange(desc(v))

# 4. Which flights travelled the farthest?
flights %>% 
  arrange(desc(distance))
#    Which travelled the shortest?
flights %>% 
  arrange(distance)

## select()

# columns from:to
flights %>% 
  select(year:day)

# except columns from:to
flights %>% 
  select(-(year:day))

# columns ending with...
flights %>% 
  select(ends_with("delay"))

# Exercises
# 1. Brainstorm as many ways as possible to select
#    dep_time, dep_delay, arr_time, and arr_delay from flights.
flights %>%
  select(starts_with("dep") | starts_with("arr"))
flights %>%
  select(matches("^(dep|arr)_(delay|time)$"))
flights %>%
  select(contains("^(dep|arr)_(delay|time)$"))

# 2. What happens if you include the name of a variable multiple times in
#    a select() call?
flights %>% 
  select(year, month, year)  # ignores duplication

# 3. What does the any_of() function do?
#    Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay", "trallala")
flights %>% 
  select(any_of(vars))
# Error: Column "trallala" doesn't exist.
flights %>% 
  select(all_of(vars))

# 4. Does the result of running the following code surprise you?
flights %>% 
  select(contains("TIME"))

#    How do the select helpers deal with case by default?
flights %>% 
  select(contains("TIME", ignore.case = TRUE)) #    case-insensitive

#    How can you change that default?
flights %>%
  select(contains("TIME", ignore.case=FALSE))


## mutate()

# add new columns
flights %>%                  # reduce number of columns
  select(year:day,
         ends_with("delay"),
         distance,
         air_time) %>%
  # calculate gain and speed
  mutate(gain = dep_delay - arr_delay,
         speed = distance / air_time * 60)

# columns just created, can be referred to immediately
flights %>%                  # reduce number of columns
  select(year:day,
         ends_with("delay"),
         distance,
         air_time) %>%
  # new columns immediately used
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours
  )

# transmute() - only keeps the newly created columns
flights %>%                  # reduce number of columns
  # keep only the new columns
  transmute(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours
  )

# modular arithmetic
flights %>%
  transmute(dep_time,
            hour = dep_time %/% 100,   # integer division
            minute = dep_time %% 100)  # modulo operator

# offsets: lead() and lag()
(x <- 1:10)
#  allow you to refer to lagging values
lag(x)
#  allow you to refer to leading values
lead(x)

# cumulative aggregates
x
# cumulative sum
cumsum(x)
# cumulative mean
cummean(x)

# Exercises
# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard
#    to compute with because they’re not really continuous numbers.
#    Convert them to a more convenient representation of number of minutes
#    since midnight.
flights %>%
  transmute(
    dep_time,
    dep_min = dep_time %/% 100 * 60 + dep_time %% 100,
    sched_dep_time,
    sched_dep_min = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100
  )

# 2. Compare air_time with arr_time - dep_time. What do you expect to see?
# air_time: in min; dep_time, arr_time: hmm (hour, min, min)
# Expectation: air_time = arr_time (min) - dep_time (min)
flights %>%
  transmute(air_time,
            arr_time,
            dep_time,
            d_time = arr_time - dep_time)
#    What do you see?
#    It is always more, so taxing and waiting is probably not included.
#    What do you need to do to fix it?
#    Take-off and landing times are needed.

# 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect
#    those three numbers to be related?
#    Expectation: dep_time = sched_dep_time + dep_delay
flights %>% 
  transmute(dep_time,
            d_time = sched_dep_time + dep_delay,
            sched_dep_time,
            dep_delay)


## summarize()

flights %>% 
summarise(delay = mean(dep_delay, na.rm = TRUE))

# combination with group_by() makes more sense
flights %>%
  group_by(year, month, day) %>%                    # group by date
  summarise(delay = mean(dep_delay, na.rm = TRUE))  # mean delay

# group by, summarize and plot (delay vs. distance to destination)
flights %>%
  group_by(dest) %>%                             # group by destination
  summarise(
    count = n(),                                 # number of flights to dest
    dist = mean(distance, na.rm = TRUE),         # distance to destination
    delay = mean(arr_delay, na.rm = TRUE)        # avg delay at destination
  ) %>%
  filter(
    count > 20,                                  # remove rare destinations
    dest != "HNL") %>%                           # remove Honolulu (too far)
  ggplot(mapping = aes(x = dist, y = delay)) +   # delay vs. distance
  geom_point(aes(size = count), alpha = 1 / 3) +
  geom_smooth(se = FALSE)                        # smoother





flights %>%
  filter(
    !is.na(dep_delay),                           # remove cancelled flights
    !is.na(arr_delay)) %>%
  group_by(tailnum) %>%                          # group by plane (tail number)
  summarise(delay = mean(arr_delay)) %>%         # avg delay of each plane
  ggplot(mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)
# some planes have > 300 min delay


flights %>%
  filter(
    !is.na(dep_delay),
    !is.na(arr_delay)) %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE),
            n = n()) %>%                        # flights of this plane
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1 / 10)
# rare flights have a high variation of delays,
# more regular ones have small variation of delays



flights %>%
  filter(
    !is.na(dep_delay),
    !is.na(arr_delay)) %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE),
            n = n()) %>%                        # flights of this plane
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1 / 10)
