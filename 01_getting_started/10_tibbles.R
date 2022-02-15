library(tidyverse)

# coerce a data frame to a tibble
as_tibble(iris)

# recycle inputs of length 1 (here: y)
# allows to refer to just created variables (here: x, y)
tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

# transposed tibble
# allow to layout data in an easy to read form
schmidts <- tribble(
  ~first_name,   ~last_name,   ~birth_date,   ~city,
  #-----------|-------------|--------------|---------------
  "Helga",     "Schmidt",    "1939-01-09",  "Schallstadt",
  "Marion",    "Zehrer",     "1973-01-06",  "Berlin",
  "Georg",     "Hofstetter", "1969-02-11",  "Umkirch",
  "Stefan",    "Schmidt",    "1967-07-07",  "Riehen"
)

schmidts$birth_date <- lubridate::ymd(schmidts$birth_date)
schmidts


df <- data.frame(abc = 1, xyz = "a", xa = "xa")
df$x                         # picks the matching column!
                             # even returns NULL if not unique!
df[, "xyz"]                  # returns a vector!
df[, c("abc", "xyz")]        # returns a data.frame

# tibbles are more consistent:
tb <- tibble(abc = 1, xyz = "a")
tb$x                         # does not guess what column is meant
tb[, "xyz"]                  # always returns a tibble!
tb[, c("abc", "xyz")]        # independent of the number of columns

# printing
# shows only the first 10 rows (of our 1000 row tibble)
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

# only as many columns that fit to the screen
nycflights13::flights

# can be overwritten setting a print option
nycflights13::flights %>% 
  print(n = 10, width = Inf)

# column extraction
# similar to data.frame()
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
# column by name
df$x
df[["x"]]
var <- "x"
df[[var]]

# column by position
df[[1]]


# Excercises
# 1. How can you tell if an object is a tibble?
# tibble prints first 10 rows
as_tibble(mtcars)
# data.frame prints all or up to 1000 rows
mtcars

# 2. Compare and contrast the following operations on a data.frame
# and equivalent tibble. What is different?
# Why might the default data frame behaviours cause you frustration?
df <- data.frame(abc = 1, xyz = "a")
df$x                         # expands to column name
df[, "xyz"]                  # returns a vector!
df[, c("abc", "xyz")]        # returns a data.frame

# 3. If you have the name of a variable stored in an object, like:
var <- "mpg"
#   How can you extract the reference variable from a tibble?
t1 <- as_tibble(mtcars)
t1[[var]]

# 4. Practice referring to non-syntactic names in the following data frame:
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
# a) Extracting the variable called 1:
annoying$`1`
annoying[['1']]
# b) Plotting a scatterplot of 1 vs 2.
plot(x=annoying$`1`, y=annoying$`2`)

# c) Creating a new column called 3 which is 2 divided by 1.
annoying$`3` <- annoying$`2` / annoying$`1`
annoying
# d) Renaming the columns to "one", "two" and "three."
annoying <- rename(annoying, one=`1`, two=`2`, three=`3`)
annoying


# 5. What does tibble::enframe() do? When might you use it?
# converts named vector to data frame. e.g.:

# overview of R package licenses
t <- as_tibble(installed.packages())
# tibble::enframe() makes vector names a column "name"
lics <- tibble::enframe(table(str_remove(t$License, "[ _-].*")),
                        name="license",
                        value="count")
lics

# 6. What option controls how many additional column names
#    are printed at the footer of a tibble?
?print.tbl