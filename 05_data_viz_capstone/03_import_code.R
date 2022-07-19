#### Common import functions from the tidyverse
library(tidyverse)

read_csv("test_import.csv")
read_csv2("test_import_semi.csv")
read_delim("test_import_delim.txt",delim="|")
read_tsv("test_import_tab.txt")

#### Arguments that might help (or hurt) with import

#treat the first row as a header/column names or not.
read_csv("test_import.csv",col_names=FALSE)

#add header
read_csv("test_import.csv",col_names=c("new1","new2"))

#skip some number of rows or read up to only some number of rows

read_csv("test_import.csv",skip=3,n_max=2,col_names=c("Var1","Var2"))

#### Data import functions from other packages

library(readxl)
#read_xls()
#read_xlsx()

library(haven)
#read_stata()
#read_spss()







