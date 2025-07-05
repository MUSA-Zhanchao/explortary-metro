library(dplyr)
library(haven)
library(tidyr)

hog<-readRDS("data/008-24 BBDD Procesamiento Hogares.rds")

hog <- hog %>%
  mutate(
    P42_group = case_when(
      P42 %in% c(1, 2)                        ~ "BRT",            # Transmilenio + Alimentador
      P42 %in% c(3, 5)                        ~ "SITP",           # SITP + Bus Dual
      P42 == 4                                ~ "Cable Car",      # TransMiCable
      P42 == 6                                ~ "Intermunicipal", # Intermunicipal
      P42 %in% c(7, 10, 14, 15, 16, 17, 18, 
                 19, 20, 21)                  ~ "Other Public",   # informal + school + empresa
      P42 %in% c(8, 9, 11, 12, 13)            ~ "Taxi",           # Taxis, Mototaxi, Bicitaxi
      P42 %in% c(22, 23)                      ~ "Car",            # Vehículo privado
      P42 %in% c(24, 25)                      ~ "Motorcycle",     # Moto
      P42 %in% c(26, 27, 28, 29)              ~ "Bicycle",        # Bicicleta convencional/motor
      P42 %in% c(30, 31, 32, 33)              ~ "Other Private",  # eléctrico, scooter, camión etc.
      P42 == 34                               ~ "Walk",           # A pie
      P42 == 89                               ~ "Other",          # Otro
      TRUE                                    ~ NA_character_     # NA or No aplica
    ),
    linea_M_factor = as_factor(linea_M)
  )

P42 <- hog %>%
  filter(!is.na(P42_group)) %>%
  count(P42_group, linea_M_factor) %>%
  group_by(P42_group) %>%
  mutate(
    percent = n / sum(n),
    label = paste0(n, " (", round(percent * 100, 1), "%)")
  ) %>%
  ungroup() %>%
  select(P42 = P42_group, linea_M = linea_M_factor, label) %>%
  pivot_wider(names_from = linea_M, values_from = label, values_fill = "0 (0%)") %>%
  rowwise() %>%
  mutate(
    Total = {
      nums <- c_across(-P42) %>% gsub(" .*", "", .) %>% as.numeric()
      paste0(sum(nums), " (100%)")
    }
  ) %>%
  ungroup()

P42_1 <- hog %>%
  filter(!is.na(P42_group)) %>%
  count(linea_M_factor, P42_group) %>%
  group_by(linea_M_factor) %>%
  mutate(
    percent = n / sum(n),
    label = paste0(n, " (", round(percent * 100, 1), "%)")
  ) %>%
  ungroup() %>%
  select(linea_M = linea_M_factor, P42 = P42_group, label) %>%
  pivot_wider(names_from = P42, values_from = label, values_fill = "0 (0%)")

