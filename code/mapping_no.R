library(tidyverse)
library(haven)
library(tidyr)
library(purrr)
library(openxlsx)
library(scales)

######
## Load the data sets and pre-processing

hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
per <- readRDS("data/008-24 BBDD Procesamiento Personas.rds")

hog_no<- hog %>%
  filter(P78 == 2)

no_use_reason<- hog_no %>%
  group_by(P79)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

approve<- hog_no %>%
  group_by(P68)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

no_support<- hog%>%
  filter(P68 == 2)

whole<- rbind(hog_no, no_support)%>%
  distinct(ID_Hogar, .keep_all = TRUE)


#####
# Detailed for support or not support

house<- no_support%>%
  group_by(P1)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

household_size<- no_support %>%
  group_by(P2)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

violent<-no_support %>%
  group_by(P48)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )

income<- no_support %>%
  group_by(P50)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

mode<- no_support %>%
  group_by(P42)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

income<- no_support %>%
  group_by(P50)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )
######
# Perception of public transit system
quick_fast<- no_support %>%
  group_by(P58)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

health<- no_support %>%
  group_by(P59)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

on_time<- no_support %>%
  group_by(P61)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

environment<- no_support %>%
  group_by(P62)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

safe_choice<- no_support %>%
  group_by(P63)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

important_factor <- no_support %>%
  group_by(P65_1)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

consturction_impact<- no_support %>%
  group_by(P66)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

mode_to_station<- no_support %>%
  group_by(P80)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

fare<- no_support %>%
  group_by(P81)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

rent_own<- no_support %>%
  group_by(P82)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

live_length<- no_support %>%
  group_by(P83)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

private_vehicle<- no_support %>%
  group_by(P85)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

#### potential not support reason
renting_cost_property <- no_support %>%
  group_by(P87)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

community_safety <- no_support %>%
  group_by(P90)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

living_expenses <- no_support %>%
  group_by(P91)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

local_commercial <- no_support %>%
  group_by(P92)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

public_transit_sats<- no_support %>%
  group_by(P95)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

commuting_time <- no_support %>%
  group_by(P96)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

noise_pollution <- no_support %>%
  group_by(P98)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

public_space<- no_support %>%
  group_by(P100)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

new_housing_project <- no_support %>%
  group_by(P101)%>%
  summarise(
    count = n(),
    .groups = "drop"
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )
