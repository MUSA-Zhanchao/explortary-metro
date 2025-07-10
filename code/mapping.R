library(tidyverse)
library(dplyr)
library(haven)

no_support_line1<- no_support %>%
  filter(linea_M == 1)

no_support_line1 <- no_support_line1 %>%
  # 1) drop the haven labels so Estacion becomes plain character
  mutate(Estacion = as.character(Estacion)) %>%
  # 2) pull off everything after the underscore and convert to integer
  mutate(station = as.integer(sub(".*_", "", Estacion)))

no_support_line1 <- no_support_line1 %>%
  group_by(station) %>%
  summarise(
    count = n()
  )

no_support_line1 <- no_support_line1 %>%
  rename(no_support= count)

# write.csv(no_support_line1, "data/no_support_line1.csv", row.names = FALSE)

no_support_line2 <- no_support %>%
  filter(linea_M == 2)

no_support_line2 <- no_support_line2 %>%
  mutate(Estacion = as.character(Estacion)) %>%
  mutate(station = as.integer(sub(".*_", "", Estacion)))

no_support_line2 <- no_support_line2 %>%
  group_by(station) %>%
  summarise(
    count = n()
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )

# write.csv(no_support_line2, "data/no_support_line2.csv", row.names = FALSE)

line1<- hog%>%
  filter(linea_M == 1)

line1 <- line1 %>%
  mutate(Estacion = as.character(Estacion)) %>%
  mutate(station = as.integer(sub(".*_", "", Estacion)))

line1 <- line1 %>%
  group_by(station) %>%
  summarise(
    count = n()
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )
line1_com<-line1%>%
  left_join(no_support_line1, by = "station") %>%
  mutate(
    percentage= ifelse(is.na(no_support), 0, no_support / count * 100),
  )

# write.csv(line1_com, "data/line1_no_support.csv", row.names = FALSE)

line2<- hog%>%
  filter(linea_M == 2)

line2 <- line2 %>%
  mutate(Estacion = as.character(Estacion)) %>%
  mutate(station = as.integer(sub(".*_", "", Estacion)))

line2 <- line2 %>%
  group_by(station) %>%
  summarise(
    count = n()
  )%>%
  mutate(
    Percentage = count / sum(count) * 100
  )
no_support_line2 <- no_support_line2 %>%
  rename(no_support = count)
line2_com<-line2%>%
  left_join(no_support_line2, by = "station")%>%
  mutate(
    percentage= ifelse(is.na(no_support), 0, no_support / count * 100),
  )

# write.csv(line2_com, "data/line2_no_support.csv", row.names = FALSE)
