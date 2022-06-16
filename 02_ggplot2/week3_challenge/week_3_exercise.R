library(tidyverse)

cces <- drop_na(read_csv(url("https://www.dropbox.com/s/ahmt12y39unicd2/cces_sample_coursera.csv?raw=1")))
cel <- drop_na(read_csv(url("https://www.dropbox.com/s/4ebgnkdhhxo5rac/cel_volden_wiseman%20_coursera.csv?raw=1")))


### Scatterplot ###

## Seniority and Bills Passed by Gender
cel115 <- cel %>%
  filter(congress == 115) %>%
  select("seniority", "all_pass", "female") %>% 
  mutate(Gender=recode(female, `1` = "Female", `0` = "Male"))

# different colors for gender
cel %>%
  filter(congress == 115) %>%
  select("seniority", "all_pass", "female") %>% 
  mutate(Gender=recode(female, `1` = "Female", `0` = "Male")) %>% 
  ggplot(aes(x = seniority, y = all_pass, color = Gender)) +
    geom_jitter() +
    labs(x = "Seniority",
         y = "Bills Passed",
         title = "Seniority and Bills Passed in the 115th Congress")

# separate plots for each gender
cel %>%
  filter(congress == 115) %>%
  select("seniority", "all_pass", "female") %>% 
  mutate(Gender=recode(female, `1` = "Female", `0` = "Male")) %>% 
  ggplot(aes(x = seniority, y = all_pass, color = Gender)) +
    geom_jitter() +
    labs(x = "Seniority",
         y = "Bills Passed",
         title = "Members Seniority and Bills Passed in the 115th Congress",
         subtitle = "by Gender") +
    facet_wrap(~ Gender) +
  guides(color = "none")


### Boxplot ###
cel %>%
  filter(congress == 115) %>%
  select("seniority", "all_pass", "female") %>% 
  mutate(Gender=recode(female, `1` = "Female", `0` = "Male")) %>% 
  ggplot(aes(y = all_pass, x = Gender)) +
    geom_boxplot() +
    labs(x = "Gender",
         y = "Bills Passed",
         title = "Distribution of Bills Passed in the 115th Congress",
         subtitle = "by Gender")


### Density ###
cel %>%
  filter(congress == 115) %>%
  select("seniority", "all_pass", "female") %>% 
  mutate(Gender=recode(female, `1` = "Female", `0` = "Male")) %>% 
  ggplot(aes(x = all_pass, fill = Gender, alpha = .5)) +
    geom_density() +
    scale_fill_manual(values = c(Female="orange", Male="gray")) +
    labs(x = "Bills Passed",
         y = "Density",
         title = "Distribution of Bills Passed in the 115th Congress",
         subtitle = "by Gender") +
    guides(alpha = "none")

### Histogram ###
cel %>%
  filter(congress == 115) %>%
  select("seniority", "all_pass", "female") %>% 
  mutate(Gender=recode(female, `1` = "Female", `0` = "Male")) %>% 
  ggplot(aes(x = all_pass, fill = Gender)) +
    geom_histogram(position = "dodge") +
    labs(x = "Bills Passed",
         y = "Count",
         title = "Distribution of Bills Passed in the 115th Congress",
         subtitle = "by Gender")


### Barplot ###
cel %>%
  filter(congress == 115) %>%
  mutate(Party=recode(dem, `1` = "Democrats", `0` = "Republicans")) %>% 
  ggplot(aes(x = Party, fill=Party)) +
  geom_bar() +
  labs(
    title = "Number of  Democrats and Republicans in the 115th Congress",
    y = "Count") +
  scale_fill_manual(values = c(Democrats="blue", Republicans="red")) +
  guides(fill = "none")

### Line Plot ###
cel %>%
  group_by(year) %>%
  summarise(Democrats=sum(dem), Republicans=n() - sum(dem)) %>%
  pivot_longer(cols = Democrats:Republicans,
               names_to = "Party",
               values_to = "Count") %>%
  ggplot(aes(x = year,
             y = Count,
             color = Party)) +
  geom_line() +
  scale_color_manual(values = c(Democrats="blue", Republicans="red")) +
  labs(x = "Year",
       title = "Number of Democrats and Republicans in Congress",
       subtitle = "1973 - 2017") +
  theme_bw()


  
labs(x = "Seniority",
     y = "Bills Passed",
     title = "Seniority and Bills Passed in the 115th Congress") +
  scale_color_manual(values = c("blue", "red"))


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