library(haven)
library(tidyverse)

hog<-readRDS("data/008-24 BBDD Procesamiento Hogares.rds")



#######
#pre-processing
line1<- hog%>%
  filter(linea_M == 1)

line2<- hog%>%
  filter(linea_M == 2)

line2<- line2 %>%
  mutate(
    P82 = case_when(
      P82 == 1 ~ "Own",
      P82 == 2 ~ "Rent",
      TRUE     ~ as.character(P82)
    ))

line1 <- line1 %>%
  mutate(
    P82 = case_when(
      P82 == 1 ~ "Own",
      P82 == 2 ~ "Rent",
      TRUE     ~ as.character(P82)
    ))

line1 <- line1%>%
  mutate(
    P86 = case_when(
      P86 == 1  ~ "Less than or equal to $500,000",
      P86 == 2  ~ "More than $500,000 and up to $1,000,000",
      P86 == 3  ~ "More than $1,000,000 and up to $1,500,000",
      P86 == 4  ~ "More than $1,500,000 and up to $2,000,000",
      P86 == 5  ~ "More than $2,000,000 and up to $3,000,000",
      P86 == 6  ~ "More than $3,000,000 and up to $4,000,000",
      P86 == 7  ~ "More than $4,000,000 and up to $5,000,000",
      P86 == 8  ~ "More than $5,000,000",
      TRUE     ~ as.character(P86)
    )
  )
line2 <- line2 %>%
  mutate(
    P86 = case_when(
      P86 == 1  ~ "Less than or equal to $500,000",
      P86 == 2  ~ "More than $500,000 and up to $1,000,000",
      P86 == 3  ~ "More than $1,000,000 and up to $1,500,000",
      P86 == 4  ~ "More than $1,500,000 and up to $2,000,000",
      P86 == 5  ~ "More than $2,000,000 and up to $3,000,000",
      P86 == 6  ~ "More than $3,000,000 and up to $4,000,000",
      P86 == 7  ~ "More than $4,000,000 and up to $5,000,000",
      P86 == 8  ~ "More than $5,000,000",
      TRUE     ~ as.character(P86)
    )
  )

line1 <- line1 %>%
  mutate(
    P83 = case_when(
      P83 == 1 ~ "Less than or equal to 1 year",
      P83 == 2 ~ "More than 1 and up to 5 years",
      P83 == 3 ~ "More than 5 and up to 10 years",
      P83 == 4 ~ "More than 10 and up to 15 years",
      P83 == 5 ~ "More than 15 and up to 20 years",
      P83 == 6 ~ "More than 20 years"
    )
  )
line2 <- line2 %>%
  mutate(
    P83 = case_when(
      P83 == 1 ~ "Less than or equal to 1 year",
      P83 == 2 ~ "More than 1 and up to 5 years",
      P83 == 3 ~ "More than 5 and up to 10 years",
      P83 == 4 ~ "More than 10 and up to 15 years",
      P83 == 5 ~ "More than 15 and up to 20 years",
      P83 == 6 ~ "More than 20 years"
    )
  )

line1_select<- line1 %>%
  select(P82, P83, P86, P67)
line2_select<- line2 %>%
  select(P82, P83, P86, P67)

####### 
# Relationship 1
## Line 1
library(dplyr)
library(janitor)

P67_P86_line1<-line1_select %>%
  tabyl(P86, P67) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()

P67_P82_line1<-line1_select %>%
  tabyl(P82, P67) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()

P67_P83_line1<-line1_select %>%
  tabyl(P83, P67) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()

## Line 2
P67_P86_line2<-line2_select %>%
  tabyl(P86, P67) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()
P67_P82_line2<-line2_select %>%
  tabyl(P82, P67) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()
P67_P83_line2<-line2_select %>%
  tabyl(P83, P67) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()


#######
# Relationship 3

# variable
line1_3<- line1%>%
  select(P50, P81)
line2_3<- line2%>%
  select(P50, P81)

P50_P81_line1 <- line1_3 %>%
  tabyl(P50, P81) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()

P50_P81_line2 <- line2_3 %>%
  tabyl(P50, P81) %>%                    # cross‐tab counts
  adorn_totals(c("row", "col")) %>%      # add margins
  adorn_percentages("col") %>%           # convert to row‐% 
  adorn_pct_formatting(digits = 1) %>%   # format as “xx.x%”
  adorn_ns()
