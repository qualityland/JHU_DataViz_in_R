library(tidyverse)

# first line as header
read_csv("a,b,c
1,2,3
4,5,6")

# skip lines with meta data
read_csv("first line with meta data
second line with meta data
a,b,c
1,2,3
4,5,6", skip=2)

# skip comments
read_csv("# first comment with meta data
# second line with meta data
a,b,c
#----
1,2,3
4,5,6", comment="#")

# no headings (default: X1...Xn)
read_csv("1,2,3\n4,5,6", col_names = FALSE)

# define headings
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

# define NA character
read_csv("a,b,c\n1,2,3\n4,.,6", na = ".")



# what are the argument names of a function? (here: read_csv())
names(formals(read_csv))

# what arguments have these functions in common: read_csv(), read_tsv()?
intersect(names(formals(read_csv)), names(formals(read_tsv)))

# do they even have identical arguments?
identical(names(formals(read_csv)), names(formals(read_tsv)))

heights <- read_csv("01_getting_started/data/heights.csv")
ggplot(data=heights) +
  geom_density(mapping=aes(x=height * 2.54, color=sex)) +
  ggtitle("Body Size") +
  xlab("size (cm)")


# Excercises

# 1. What function would you use to read a file where fields were
#    separated with "|"?
read_delim("a|b|c
1|2|3
4|5|6", delim="|")

# 2. Apart from file, skip, and comment, what other arguments do
#    read_csv() and read_tsv() have in common?
intersect(names(formals(read_csv)), names(formals(read_tsv)))

# 3. What are the most important arguments to read_fwf()?
names(formals(read_fwf))

# 4. Sometimes strings in a CSV file contain commas. To prevent them from
#    causing problems they need to be surrounded by a quoting character, like "
#    or '. By default, read_csv() assumes that the quoting character will be ".
#    What argument to read_csv() do you need to specify to read the following
#    text into a data frame?
#    "x,y\n1,'a,b'"
read_csv("x,y\n1,'a,b'", quote = "\'")

# 5. Identify what is wrong with each of the following inline CSV files.
#    What happens when you run the code?
read_csv("a,b\n1,2,3\n4,5,6")
# 3rd heading is missing

read_csv("a,b,c\n1,2\n1,2,3,4")
# 2nd line has only 2 values, 3rd has 4

read_csv("a,b\n\"1")
# no clear intention

read_csv("a,b\n1,2\na,b")
# mixed data type in same column -> conversion to character

read_csv("a;b\n1;3")
# use read_csv2() for semicolon delimited files


# Parsing a Vector

