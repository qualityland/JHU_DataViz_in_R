library(tidyverse)

cces <- drop_na(read_csv(url("https://www.dropbox.com/s/ahmt12y39unicd2/cces_sample_coursera.csv?raw=1")))
cel <- drop_na(read_csv(url("https://www.dropbox.com/s/4ebgnkdhhxo5rac/cel_volden_wiseman%20_coursera.csv?raw=1")))



## Seniority and Bills Passed by Gender
fig115 <- cel %>%
  filter(congress == 115) %>%
  select("seniority", "all_pass", "female")

Gender <- recode(fig115$female, `1` = "Female", `0` = "Male")
ggplot(fig115, aes(x = seniority, y = all_pass, color = Gender)) +
  geom_jitter() +
  labs(x = "Seniority",
       y = "Bills Passed",
       title = "Seniority and Bills Passed in the 115th Congress") #+
  scale_color_manual(values = c(Male="black", Female="blue"))


  
  
  ggplot(
    cel %>%
      group_by(year) %>%
      summarise(Female=sum(female), Male=n()-sum(female)) %>%
      pivot_longer(
        cols = Female:Male,
        names_to = "isfemale",
        values_to = "count"
      ),
    aes(x = year,y = count, group = isfemale, color = isfemale)) +
    geom_line() +
    scale_color_manual(values = c(Male="blue", Female="red")) +
    labs(
      x = "Year",
      y = "Count",
      color = "Gender",
      title = "Number of Congresswomen between 1973 - 2017"
    ) +
    theme_bw()
  
  

## bullshit
ggplot(fig115, aes(y = all_pass)) +
  geom_boxplot() +
  facet_wrap(~ female)

ggplot(fig115, aes(x = seniority, y = all_pass)) +
  geom_jitter()



## Family Income by Race
cces$Race = recode(cces$race,
                   `1` = "White",
                   `2` = "Black",
                   `3` = "Hispanic",
                   `4` = "Asian",
                   `5` = "Native American",
                   `6` = "Mixed",
                   `7` = "Other",
                   `8` = "Middle Eastern")

ggplot(cces, aes(x = faminc_new)) +
  geom_density() + 
  labs(x = "Income Level",
       y = "Density",
       title = "Family Income and Race") +
  facet_wrap(~ Race)


## Education Level and Family Income by Race
ggplot(cces, aes(educ, faminc_new, color = Race)) +
  geom_jitter() +
  labs(x = "Education",
       y = "Income",
       title = "Education and Family Income") +
  facet_wrap( ~ Race)


## 