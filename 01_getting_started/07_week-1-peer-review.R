# Week 1 Practice Code

# Type your name here: Stefan

# Complete these coding tasks, then submit your R file for another student to
# compare against the example output.

# Problem 1 

# Create a data frame that includes two columns, one named "Animals" and the
# other named "Foods". The first column should be this vector (note the
# intentional repeated values): Dog, Cat, Fish, Fish, Lizard


# The second column should be this vector: Bread, Orange, Chocolate, Carrots, Milk


#### Write your code below:
animals <- c("Dog", "Cat", "Fish", "Fish", "Lizard")
foods <- c("Bread", "Orange", "Chocolate", "Carrots", "Milk")
(df <- data.frame("Animals"=animals, "Foods"=foods))


# Problem 2

# Using the data frame created in Problem 2, use the table() command to create
# a frequency table for the column called "Animals".

#### Write your code below:
(tb <- table(df$Animals))

# Problem 3

# Use read.csv() to import the survey data included in this assignment.
# Using that data, make a histogram of the column called "pid7".


#### Write your code below:
dat <- read.csv("https://d3c33hcgiwev3.cloudfront.net/D1LYDGZLRAmS2AxmSxQJHw_244a6af25c32479990d299bf82de1a67_cces_sample_coursera.csv?Expires=1643932800&Signature=J1koowoQ3f9AOKDn1-pBcLHFOFgr4Sxz7tpFbtP41H643AcLJ9nhpvVGDZVTxR0rylbzROQqTVizb-06y3vXaRFpS~Wx5QQ-VIBEcEm4HSPV8aT7EmwVHmNqnHfShdzcfEcVKfwkZJXfBksb-j88pH4-mmWKliP2ecl4NqvHe-w_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A")
hist(dat$pid7)
