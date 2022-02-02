# Importing Data in R

# import CSV
cces_sample <-
  read.csv("01_getting_started/data/cces_sample.csv")

# write CSV
write.csv(cces_sample, "01_getting_started/data/test.csv")

# type in your directory path in setwd() or use the
# Session-->Set Working Directory menu options

old_wd <- getwd()
new_wd <- paste(old_wd, "01_getting_started/data", sep = "/")

setwd(new_wd)

# Don't need the whole file path now
cces_sample <- read.csv("01_getting_started/data/cces_sample.csv")
setwd(old_wd)
class(cces_sample)

median(cces_sample$pew_religimp, na.rm = T)

table(cces_sample$race)
