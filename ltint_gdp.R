library (tidyverse)

#uploading data
total <- read_csv("data/LTINT_GDP.csv")
df_gdp <- read_csv("data/GDP_yearly.csv")
df_ltint <- read_csv("data/LTINT_yearly.csv")

#making data wide
df_ltint_wide <- df_ltint %>% pivot_wider(names_from = INDICATOR, values_from = Value)

#using names_from = MEASURE because there were two different measures of GDP (million USD and per capita)
#then dropping the INDICATOR variable that had GDP as values
df_gdp_wide <- df_gdp %>% 
  pivot_wider(names_from = MEASURE, values_from = Value, names_prefix = "GDP_") %>% 
  select(-INDICATOR)

#merging gdp and ltint
df_merged <- df_gdp_wide %>% left_join(df_ltint_wide %>% select(LOCATION, TIME, LTINT), by = c("LOCATION","TIME"))

#dataset from 2006 (date where ltint starts)
df_merged_2006_2020 <- df_merged %>% filter(TIME>=2006)
df_merged_2006_2020 %>% write_csv("gdp_ltint_2006_2020.csv")
