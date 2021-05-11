library (tidyverse)
library (plotly)
library(zoo) # moving averages        
#uploading data
df_deficit_pct <- read_csv("data/deficit_pct_gdp_OECD.csv")
df_deficit_pct %>% count(`Flag Codes`)
#note that positive values in deficit_pc mean budget surpluses and negative deficits
# there are 23 E (estimate/preliminary data) and 1 B (break in series) that were put in this table
df_e_or_b <-df_deficit_pct %>% filter(!is.na(`Flag Codes`))
# they were removed from the final dataset because the uncertainty 
# was not too relevant to the overall analsyis
df_wide_deficit <- df_deficit_pct %>% 
  select(-`Flag Codes`) %>% #this removes the variable Flag Codes to make the wide dataset cleaner
  pivot_wider(names_from = TIME, values_from = deficit_pc)
df_wide_deficit %>% 
  count(LOCATION, sort=TRUE) #sort=TRUE makes it go from bigger to smaller to see if there's <1
p <- df_deficit_pct %>% #making p into a ggplot object to visualise w/ plotly
 # line below would invert surplus/deficit in deficit_pc, making higher values mean higher deficits
 # mutate(deficit_pc=-deficit_pc) %>% 
  ggplot(aes(TIME, deficit_pc, colour=LOCATION)) + 
  geom_line()
  ggplotly(p) #plotly lets me see the legend when scrolling through the plot

#creating rolling averages
  df_deficit_pct <- df_deficit_pct %>% #this function uses longform
  group_by(LOCATION) %>% 
  mutate(bal_05ya = rollmean(deficit_pc, k = 5, fill = NA),
         bal_07ya = rollmean(deficit_pc, k = 7, fill = NA),
         bal_10ya = rollmean(deficit_pc, k = 10, fill = NA)) %>% 
        ungroup() #this closes that group_by(LOCATION)
  #looking at rolling averages 5 years 
  #positive values are surpluses, negative values are deficits
    p <- df_deficit_pct %>%
    ggplot(aes(TIME, bal_05ya, colour=LOCATION)) + 
    geom_line()
    ggplotly(p) 
  #looking at rolling averages 7 years
  #positive values are surpluses, negative values are deficits
    p <- df_deficit_pct %>%
    ggplot(aes(TIME, bal_07ya, colour=LOCATION)) + 
    geom_line()
    ggplotly(p) 
  #looking at rolling averages 10 years
  #positive values are surpluses, negative values are deficits
    p <- df_deficit_pct %>%
    ggplot(aes(TIME, bal_10ya, colour=LOCATION)) + 
    geom_line()
    ggplotly(p) 