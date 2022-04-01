CC18_325a_support = recode(dat$CC18_325a,
                           `1` = 1,
                           `2` = 0)

CC18_325b_support = recode(dat$CC18_325b,
                           `1` = 1,
                           `2` = 0)

dat %>% 
  select(CC18_325a, CC18_325b) %>% 
  mutate(tax_scale = CC18_325a_support + CC18_325b_support)
