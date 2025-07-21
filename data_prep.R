library(haven)
library(cluster)
library(tidyverse)

# --- 数据载入 & 清洗 ---
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
personas<- readRDS("data/008-24 BBDD Procesamiento personas.rds")

household_head<- personas%>%
  filter(posicionActual == "primer")

complete<- left_join(household_head,hog, by= "ID_Hogar")

cluster<- complete%>%
  select(ID_Hogar, P9, linea_M.x, P10, P12, P14, P1, P50, P68, P82, P87:P101,Estacion)


cluster<- cluster%>%
  rename(line= linea_M.x)%>%
  mutate(Estacion = as.numeric( gsub("_", "", as.character(cluster$Estacion)) ))

write.csv(cluster, "data/cluster_data_prep.csv", row.names = FALSE)
