
library(dplyr)
library(haven)
library(ggplot2)
library(tidyr)
library(sf)
library(purrr)
library(openxlsx)
library(scales)

# read data
trips <- readRDS("../Survey Data/Data/Rds/008-24 BBDD Procesamiento Etapas.rds")
hog <- readRDS("../Survey Data/Data/Rds/008-24 BBDD Procesamiento Hogares.rds")
per <- readRDS("../Survey Data/Data/Rds/008-24 BBDD Procesamiento Personas.rds")
dd <- read.xlsx("../Survey Data/Script/TripsAnalysis/TripsAnalysis/08-24_SurveyData_Etapas.xlsx", sheet = "DataDictionary")

###---------------------------------------------------------------###
# Hog
# PART 1 - Basic household and house information
# P1 housing type
hog_housingtype<-hog %>%
  filter(!is.na(P1)) %>%
  group_by(P1) %>%
  summarise(Count=n()) %>%
  mutate(
    Percentage_housingtype = (Count / sum(Count)) * 100) %>%
  mutate(
    label=case_when(
      P1 == 1 ~ "House",
      P1 == 2 ~ "Apartment",
      P1 == 3 ~ "Room(s) in a boarding house",
      P1 == 4 ~ "Room(s) in another type of dwelling",
      P1 == 5 ~ "Indigenous dwelling",
      P1 == 89 ~ "Other type of dwelling"
    )
  ) %>%
  arrange(desc(Count))
print(hog_housingtype)

# P2 how many households live in this dwelling
hog_householdsnumber <- hog %>%
  filter(!is.na(P2)) %>%
  mutate(P2_grouped = ifelse(P2 >= 5, "5+", as.character(P2))) %>%
  group_by(P2_grouped) %>%
  summarise(Count = n()) %>%
  mutate(
    Percentage_householdsnumber = (Count / sum(Count)) * 100
  ) %>%
  mutate(P2_grouped = factor(P2_grouped, levels = c("1", "2", "3", "4", "5+")))
print(hog_householdsnumber)

# P3 total number of household members
hog_householdmembers <- hog %>%
  filter(!is.na(P3)) %>%
  group_by(P3) %>%
  summarise(Count = n()) %>%
  mutate(
    Percentage_householdmember = (Count / sum(Count)) * 100,
    P3 = factor(P3, levels = as.character(1:20))
  )
print(hog_householdmembers)

# P4 how many people are over 5 years old
hog_over5 <- hog %>%
  filter(!is.na(P4)) %>%
  group_by(P4) %>%
  summarise(Count = n()) %>%
  mutate(
    Percentage_over5 = (Count / sum(Count)) * 100) %>%
  mutate(P4 = factor(as.character(P4)))
print(hog_over5)

# monthly income
hog_income <- hog %>%
  filter(!is.na(P50) & P50 != 99) %>%
  group_by(P50) %>%
  summarise(Count = n()) %>%
  mutate(
    Percentage_income = (Count / sum(Count)) * 100,
    P50_label = case_when(
      P50 == 1  ~ "$0 - $400,000",
      P50 == 2  ~ "$400,001 - $800,000",
      P50 == 3  ~ "$800,001 - $1,160,000",
      P50 == 4  ~ "$1,160,000 - $1,500,000",
      P50 == 5  ~ "$1,500,001 - $2,000,000",
      P50 == 6  ~ "$2,000,001 - $2,500,000",
      P50 == 7  ~ "$2,500,001 - $3,500,000",
      P50 == 8  ~ "$3,500,001 - $4,900,000",
      P50 == 9  ~ "$4,900,001 - $6,800,000",
      P50 == 10 ~ "$6,800,001 - $9,000,000",
      P50 == 11 ~ "More than $9,000,000"
    )
  ) %>%
  arrange(desc(Count))
print(hog_income)

# P82 - Are you a homeowner or tenant?
# 1	Propietario(a)
# 2	Arrendatario(a)
homerent<- hog %>%
  count(P82) %>%
  mutate(
    Percentage = (n / sum(n)) * 100
  )
print(homerent)

# P85 - Do you have private parking?
# 1	Sí
# 2	No
privateparking<- hog %>%
  count(P85) %>%
  mutate(
    Percentage = (n / sum(n)) * 100
  )
print(privateparking)


#P83 - How long have you lived here?
hog_age <- hog %>%
  filter(!is.na(P83)) %>%
  group_by(P83) %>%
  summarise(Count = n()) %>%
  mutate(
    Percentage_length = (Count / sum(Count)) * 100,
    Age_group = case_when(
      P83 == 1 ~ "Less than or equal to 1 year",
      P83 == 2 ~ "More than 1 and up to 5 years",
      P83 == 3 ~ "More than 5 and up to 10 years",
      P83 == 4 ~ "More than 10 and up to 15 years",
      P83 == 5 ~ "More than 15 and up to 20 years",
      P83 == 6 ~ "More than 20 years"
    )
  ) %>%
  arrange(desc(Count))
print(hog_age)

#P86 - What is the monthly rent?
hog_rent <- hog %>%
  filter(!is.na(P86) & P86 != 99) %>%
  group_by(P86) %>%
  summarise(Count = n()) %>%
  mutate(
    Percentage_rent = (Count / sum(Count)) * 100,
    Rent_range = case_when(
      P86 == 1  ~ "Less than or equal to $500,000",
      P86 == 2  ~ "More than $500,000 and up to $1,000,000",
      P86 == 3  ~ "More than $1,000,000 and up to $1,500,000",
      P86 == 4  ~ "More than $1,500,000 and up to $2,000,000",
      P86 == 5  ~ "More than $2,000,000 and up to $3,000,000",
      P86 == 6  ~ "More than $3,000,000 and up to $4,000,000",
      P86 == 7  ~ "More than $4,000,000 and up to $5,000,000",
      P86 == 8  ~ "More than $5,000,000",
      P86 == 99 ~ "Does not know / No response"
    ),
    Rent_range = factor(Rent_range, levels = c(
      "Less than or equal to $500,000",
      "More than $500,000 and up to $1,000,000",
      "More than $1,000,000 and up to $1,500,000",
      "More than $1,500,000 and up to $2,000,000",
      "More than $2,000,000 and up to $3,000,000",
      "More than $3,000,000 and up to $4,000,000",
      "More than $4,000,000 and up to $5,000,000",
      "More than $5,000,000",
      "Does not know / No response"
    ))
  ) %>%
  arrange(Rent_range)
print(hog_rent)

# PART 2 - Commute Transportation Mode
purposes <- list(
  shopping = "P51",
  work = "P52",
  businesstrip = "P53",
  recreation = "P57",
  visit = "P54",
  children = "P55",
  medical = "P56"
)

get_label <- function(x) case_when(
  x == 1  ~ "Transmilenio",
  x == 2  ~ "Alimentador",
  x == 3  ~ "SITP – Urbano/Complementario/Especial/Provisional",
  x == 4  ~ "TransMicable",
  x == 5  ~ "Bus Dual",
  x == 6  ~ "Bus/Buseta/Microbús intermunicipal",
  x == 7  ~ "Bus/automóvil/Van informal o pirata",
  x == 8  ~ "Mototaxi",
  x == 9  ~ "Bicitaxi",
  x == 10 ~ "Tren",
  x == 11 ~ "Taxi Convencional",
  x == 12 ~ "Taxi solicitado por app",
  x == 13 ~ "Taxi colectivo",
  x == 14 ~ "Trasporte individual solicitado por app móvil (placa blanca/placa amarilla)",
  x == 15 ~ "Transporte escolar",
  x == 16 ~ "Bus privado/de empresa",
  x == 17 ~ "Sistema de Bicicletas de Bogotá (Bicicleta pública)",
  x == 18 ~ "Motocarro de pasajeros/carga",
  x == 19 ~ "Vehículo de tracción animal",
  x == 20 ~ "Auto/moto compartido (a)",
  x == 21 ~ "Auto/moto alquilado (a)",
  x == 22 ~ "Vehículo privado como conductor",
  x == 23 ~ "Vehículo privado como pasajero",
  x == 24 ~ "Motocicleta como conductor",
  x == 25 ~ "Motocicleta como pasajero",
  x == 26 ~ "Bicicleta convencional como conductor",
  x == 27 ~ "Bicicleta convencional como pasajero",
  x == 28 ~ "Bicicleta con motor como conductor",
  x == 29 ~ "Bicicleta con motor como pasajero",
  x == 30 ~ "Auto/moto eléctrico(a)",
  x == 31 ~ "Patineta/Scooter",
  x == 32 ~ "Vehículo de tracción humana/animal",
  x == 33 ~ "Camión/Volqueta/Tractomula",
  x == 34 ~ "A pie (Viajes totalmente a pie)",
  x == 89 ~ "Otro",
  x == 99 ~ "No Aplica"
)

results <- map(purposes, function(var_name) {
  hog %>%
    filter(!is.na(.data[[var_name]])) %>%
    group_by(.data[[var_name]]) %>%
    summarise(Count = n(), .groups = "drop") %>%
    mutate(
      label = get_label(.data[[var_name]]),
      !!paste0("Percentage_", names(purposes)[which(purposes == var_name)]) := (Count / sum(Count)) * 100
    ) %>%
    select(label, starts_with("Percentage_"))
})

# transport mode by purpose matrix
combined_matrix <- reduce(results, full_join, by = "label")

# What mode of transportation do you use to connect to public transport?
hog_meansconnectpublictran <- hog %>%
  filter(!is.na(P80)) %>%
  group_by(P80) %>%
  summarise(Count = n()) %>%
  mutate(
    Percentage = (Count / sum(Count)) * 100,
    label = case_when(
      P80 == 1  ~ "A pie",
      P80 == 2  ~ "Bicicleta",
      P80 == 3  ~ "Bus zonal / alimentador",
      P80 == 4  ~ "Transmilenio",
      P80 == 5  ~ "Taxi",
      P80 == 6  ~ "Bici Taxi",
      P80 == 7  ~ "Carro particular",
      P80 == 8  ~ "Plataformas digitales",
      P80 == 89 ~ "Otro"
    )
  ) %>%
  arrange(desc(Percentage))

# PART 3 Transportation used before and during COVID and reasons for change
# transportation mode before COVID and after
hog_covid <- hog %>%
  filter(!is.na(P42) & !is.na(P43)) %>%
  gather(key = "Time_Period", value = "Transport_Method", P42, P43) %>%
  group_by(Transport_Method, Time_Period) %>%
  summarise(Count = n(), .groups = "drop") %>%
  mutate(
    Transport_Group = case_when(
      Transport_Method %in% c(1, 2, 3, 5, 6, 16) ~ "Public Bus Systems",
      Transport_Method %in% c(4, 10, 15) ~ "Other Public Transit",
      Transport_Method %in% c(7, 8, 9, 11, 12, 13, 14) ~ "Taxi & Informal Transit",
      Transport_Method %in% c(17, 26, 27, 28, 29) ~ "Bicycle & Micromobility",
      Transport_Method %in% c(18, 19, 20, 21, 30, 31) ~ "Shared/Small Vehicles",
      Transport_Method %in% c(22, 23, 24, 25) ~ "Private Vehicles",
      Transport_Method %in% c(32, 33) ~ "Other Transport Modes",
      Transport_Method %in% c(34, 89) ~ "Walking & Other",
      TRUE ~ "Uncategorized"
    )
  ) %>%
  group_by(Transport_Group, Time_Period) %>%
  summarise(Count = sum(Count), .groups = "drop") %>%
  group_by(Time_Period) %>%
  mutate(
    Percentage = Count / sum(Count) * 100
  ) %>%
  ungroup()

ggplot(hog_covid, aes(x = reorder(Transport_Group, -Percentage), y = Percentage, fill = Time_Period)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")),
            position = position_dodge(width = 0.9), vjust = -0.3, color = "black") +
  labs(
    title = "Transportation Methods Before and During COVID-19 (Percentage)",
    x = "Transportation Category",
    y = "Percentage (%)"
  ) +
  scale_fill_manual(values = c("skyblue", "lightgreen"), labels = c("Before COVID", "During COVID")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# reason changed
reason_change <- hog %>%
  summarise(
    `Restrictive mobility regulations` = sum(P44_1 == 1, na.rm = TRUE),
    `Personal decision, I didn’t want to risk getting infected` = sum(P44_2 == 1, na.rm = TRUE),
    `Switched to remote work` = sum(P44_3 == 1, na.rm = TRUE),
    `Reduction in transportation availability` = sum(P44_4 == 1, na.rm = TRUE),
    `Lost my job` = sum(P44_5 == 1, na.rm = TRUE),
    `Other` = sum(P44_89 == 1, na.rm = TRUE)
  ) %>%
  gather(key = "Reason", value = "Count")

ggplot(reason_change, aes(x = reorder(Reason, -Count), y = Count, fill = Reason)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Count), position = position_stack(vjust = 0.5), color = "black") +
  labs(
    title = "Reasons for Changes in Mobility",
    x = NULL,
    y = "Count"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.position = "right"
  )

# travel frequency before 2019
frequency_of_daily_trip <- hog %>%
  filter(!is.na(P45)) %>%
  group_by(P45) %>%
  summarise(Count = n()) %>%
  mutate(Percentage = (Count / sum(Count)) * 100)

frequency_of_daily_trip <- frequency_of_daily_trip %>%
  mutate(
    Label = case_when(
      P45 == 1 ~ "Make fewer trips",
      P45 == 2 ~ "Make more trips",
      P45 == 3 ~ "No longer make trips",
      P45 == 4 ~ "Continue making the same trips"
    )
  )


# PART 4 Attitudes Towards Public Transit
questions <- c("P58", "P59", "P60", "P61", "P62", "P63")

question_map <- c(
  P58 = "Is fast and efficient",
  P59 = "Is beneficial for your physical & mental health",
  P60 = "Has clear route information",
  P61 = "Is punctual and reliable",
  P62 = "Is good for the environment",
  P63 = "Is a safe travel option"
)

generate_summary_table <- function(data, questions) {
  summary_list <- lapply(questions, function(q) {
    temp <- data %>%
      mutate(!!q := case_when(
        !!sym(q) == "1" ~ "Yes",
        !!sym(q) == "2" ~ "No",
        TRUE ~ NA_character_
      )) %>%
      filter(!is.na(!!sym(q))) %>%
      count(response = !!sym(q)) %>%
      mutate(percent = round(100 * n / sum(n), 1)) %>%
      select(-n) %>%
      pivot_wider(names_from = response, values_from = percent)
    if (!"Yes" %in% colnames(temp)) temp$Yes <- 0
    if (!"No" %in% colnames(temp))  temp$No  <- 0

    temp$Question <- question_map[[q]]
    return(temp)
  })

  result <- bind_rows(summary_list) %>%
    select(Question, Yes, No)

  return(result)
}

hog_transmil <- hog %>%
  select(all_of(questions)) %>%
  mutate(across(everything(), as.character))

attitude_pt_summarytable <- generate_summary_table(hog_transmil, questions)
print(attitude_pt_summarytable)

# Factors for travel
hog_factor <- hog %>% select(P65_1, P65_2)
hog_factor <- hog_factor %>%
  mutate(P65_1 = as.character(P65_1),
         P65_2 = as.character(P65_2)) %>%
  mutate(P65_1 = case_when(
    P65_1 == "1" ~ "Time of trip",
    P65_1 == "2" ~ "Closeness of station",
    P65_1 == "3" ~ "Comfort during trip",
    P65_1 == "4" ~ "Security on the system",
    P65_1 == "5" ~ "Cost of travel",
    P65_1 == "6" ~ "Environmental impact of transport mode",
    P65_1 == "7" ~ "Punctuality of buses",
    TRUE ~ P65_1
  ),
  P65_2 = case_when(
    P65_2 == "1" ~ "Time of trip",
    P65_2 == "2" ~ "Closeness of station",
    P65_2 == "3" ~ "Comfort during trip",
    P65_2 == "4" ~ "Security on the system",
    P65_2 == "5" ~ "Cost of travel",
    P65_2 == "6" ~ "Environmental impact of transport mode",
    P65_2 == "7" ~ "Punctuality of buses",
    TRUE ~ P65_2
  ))

table(hog_factor$P65_2)

ggplot(hog_factor, aes(x = P65_1)) +
  geom_bar(fill = "#9eadc8", color = "black") +
  labs(title = "Most Imporant Factor for a Pleasant Trip",
       x = "Response",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(hog_factor, aes(x = P65_2)) +
  geom_bar(fill = "#d6d84f", color = "black") +
  labs(title = "Second Most Imporant Factor for a Pleasant Trip",
       x = "Response",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

filtered_data <- hog_factor %>% filter(P65_1 == "Security on the system")

ggplot(filtered_data, aes(x = P65_2)) +
  geom_bar(fill = "#b9e28c", color = "black") +
  labs(title = "Second Most Important Factor for a Pleasant Trip\n(Among Those Who Prioritized Security)",
       x = "Response",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# PART 5 LMB Attitudes
hog_lmg <- hog %>% select(P66, P67, P68, P70, P71, P72, P73, P78)
#Travel time changes
hog_lmg <- hog_lmg %>%
  mutate(P66 = as.character(P66)) %>%
  mutate(P66 = case_when(
    P66 == "1" ~ "More Time",
    P66 == "2" ~ "Same Amount of Time",
    P66 == "3" ~ "Less Time",
    TRUE ~ P66
  ))

ggplot(hog_lmg, aes(x = P66)) +
  geom_bar(fill = "#5b507a", color = "black") +
  labs(title = "How do you think travel time will change due to the construction of the Bogotá metro (LMB)?",
       x = "Response",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#How optimistic are you about the LMB project?
hog_lmg <- hog_lmg %>%
  mutate(P67 = as.character(P67)) %>%
  mutate(P67 = case_when(
    P67 == "1" ~ "Very Pessimistic",
    P67 == "2" ~ "Pessimistic",
    P67 == "3" ~ "Moderately Pessimistic",
    P67 == "4" ~ "Moderately Optimistic",
    P67 == "5" ~ "Optimistic",
    P67 == "6" ~ "Very Optimistic",
    TRUE ~ P67
  ))

hog_lmg <- hog_lmg %>%
  mutate(P67 = factor(P67, levels = c(
    "Very Pessimistic", "Pessimistic", "Moderately Pessimistic",
    "Moderately Optimistic", "Optimistic", "Very Optimistic"
  )))

ggplot(hog_lmg, aes(x = P67)) +
  geom_bar(fill = "#5b618a", color = "black") +
  labs(title = "How optimistic are you about the LMB project?",
       x = "Response",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#LMB route information
info_levels <- c(
  "No Information", "Little Information",
  "Moderate Information", "Good Information", "Excellent Information"
)

info_labels <- setNames(info_levels, as.character(1:5))  # "1" = "No Information", etc.

plot_info_question <- function(data, column, title, fill_color) {
  col_sym <- rlang::sym(column)
  data <- data %>%
    mutate(!!col_sym := recode(as.character(!!col_sym), !!!info_labels)) %>%
    mutate(!!col_sym := factor(!!col_sym, levels = info_levels))
  ggplot(data, aes(x = !!col_sym)) +
    geom_bar(fill = fill_color, color = "black") +
    labs(title = title, x = "Response", y = "Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

plot_info_question(hog_lmg, "P71",
                   "How much information about the LMB routes is available?",
                   "#d6d84f")

plot_info_question(hog_lmg, "P72",
                   "How much information about the LMB station locations is available?",
                   "#b9e28c")

plot_info_question(hog_lmg, "P73",
                   "How much information about the LMB opening year is available?",
                   "#9eadc8")

#Will you use the system once it is operational?
hog_lmg <- hog_lmg %>%
  mutate(P78 = as.character(P78)) %>%  # Ensure P58 is character
  mutate(P78 = case_when(
    P78 == "1" ~ "Yes",
    P78 == "2" ~ "No",
    TRUE ~ P78  # Keep other values unchanged
  ))

table(hog_lmg$P78)

ggplot(hog_lmg, aes(x = P78)) +
  geom_bar(fill = "lightgreen", color = "black") +  # Use geom_bar() for categorical data
  labs(title = "Will you use the LMB once it is operational?",
       x = "Response",
       y = "Count") +
  theme_minimal()

#PART 6 Expected future changes after LMB is operational
hog_future <- hog %>% select(P81, P87, P90, P91, P92, P95, P96, P98, P100, P101)

#Willingness to pay
hog_future <- hog_future %>%
  mutate(P81 = as.character(P81)) %>%
  mutate(P81 = case_when(
    P81 == "1" ~ "$3,200 or less",
    P81 == "2" ~ "$3,200-3,500",
    P81 == "3" ~ "$3,500-$3,800",
    P81 == "4" ~ "$3,800-$4,100",
    P81 == "5" ~ "$4,100-$4,500",
    P81 == "6" ~ "$4,500 or more",
    TRUE ~ P81  # Keep other values unchanged
  ))

ggplot(hog_future, aes(x = P81)) +
  geom_bar(fill = "#5b618a", color = "black") +  # Use geom_bar() for categorical data
  labs(title = "How much are you willing to pay to ride the LMB?",
       x = "Response",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

table(hog_future$P87)
table(hog_future$P90)
table(hog_future$P91)
table(hog_future$P92)
table(hog_future$P95)
table(hog_future$P96)
table(hog_future$P98)
table(hog_future$P100)
table(hog_future$P101)

future_labels <- c("1" = "Increase", "2" = "Stay the Same", "3" = "Decrease")
future_question_map <- c(
  P87 = "Housing rents",
  P90 = "Community safety",
  P91 = "Cost of living",
  P92 = "Local businesses",
  P95 = "Public transit satisfaction",
  P96 = "Commuting time",
  P98 = "Noise pollution",
  P100 = "Public spaces",
  P101 = "New residential projects"
)

generate_future_summary_table <- function(data, questions, label_map, question_map) {
  summary_list <- lapply(questions, function(q) {
    temp <- data %>%
      mutate(!!q := recode(as.character(!!sym(q)), !!!label_map)) %>%
      filter(!is.na(!!sym(q))) %>%
      count(response = !!sym(q)) %>%
      mutate(percent = round(100 * n / sum(n), 1)) %>%
      select(-n) %>%
      pivot_wider(names_from = response, values_from = percent)

    for (opt in c("Increase", "Stay the Same", "Decrease")) {
      if (!(opt %in% colnames(temp))) temp[[opt]] <- 0
    }

    temp$Question <- question_map[[q]]
    return(temp)
  })

  result <- bind_rows(summary_list) %>%
    select(Question, Decrease, Increase, `Stay the Same`) %>%
    mutate(across(where(is.numeric), ~ sprintf("%.1f%%", .x)))

  return(result)
}

questions <- names(future_question_map)

future_summary <- generate_future_summary_table(
  data = hog_future,
  questions = questions,
  label_map = future_labels,
  question_map = future_question_map
)

print(future_summary)


###---------------------------------------------------------------###

# Per
# converting all labeled columns to factors to use summary function
per <- per %>%
  mutate(across(where(is.labelled), as_factor))
summary(per)

#1. Age Distribution (Edad): Bar Plot for Age Categories
per$Edad <- recode(per$Edad,
                   "De 5 a 9 años" = "5 to 9 years",
                   "De 10 a 17 años" = "10 to 17 years",
                   "De 25 a 34 años" = "25 to 34 years",
                   "De 35 a 44 años" = "35 to 44 years",
                   "De 45 a 54 años" = "45 to 54 years",
                   "De 55 a 64 años" = "55 to 64 years",
                   "De 18 a 24 años" = "18 to 24 years",
                   "Mas de 65 años" = "Over 65 years",
                   "Other" = "Other")
ggplot(per, aes(x = Edad)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Age Distribution", x = "Age Group", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#2, Job Category Distributions(P14)
per$P14 <- recode(per$P14,
                  "Obrero" = "Worker",
                  "Jornalero/agricultor" = "Day laborer/farmer",
                  "Empleado doméstico" = "Domestic worker",
                  "Conductor/mensajero" = "Driver/messenger",
                  "Trabajador sin remuneración" = "Unpaid worker",
                  "Empleado de empresa particular" = "Private company employee",
                  "Empleado público" = "Public employee",
                  "Profesional independiente" = "Independent professional",
                  "independientes no profesionales" = "Non-professional independents",
                  "Trabajador independiente" = "Independent worker",
                  "Patrón/empleador" = "Employer",
                  "Vendedor informal" = "Informal seller")
ggplot(per, aes(x = P14)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Job Category Distribution", x = "Job Category", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#3. Gender Distribution (P10)
per$P10 <- recode(per$P10,
                  "Hombre" = "Male",
                  "Mujer" = "Female",
                  "Otro" = "Other",
                  "No binario" = "Non-binary",
                  "No sabe/No responde" = "Do not know/No response")
ggplot(per, aes(x = P10)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Gender Distribution", x = "Gender", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#4. Family Role Distribution (P8)
per$P8 <- recode(per$P8,
                 "Jefe de hogar" = "Head of Household",
                 "Pareja (Cónyuge, Compañero(a), esposo(a)" = "Spouse (Husband, Partner, Wife)",
                 "Hijo(a)" = "Child",
                 "hijastro(a)" = "Stepfamily (Stepchild)",
                 "Nieto (a)" = "Grandchild",
                 "Otro pariente del jefe" = "Other Relative of Head",
                 "Otro NO pariente del jefe" = "Other Non-relative of Head")
ggplot(per, aes(x = P8)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Family Role Distribution", x = "Family Role", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


###---------------------------------------------------------------###

# Trips
trips <- trips %>%
  mutate(posicionActualE = as.factor(posicionActualE),
         posicionActualNumE = as.factor(posicionActualNumE),
         linea_M = as.factor(linea_M),
         P10 = as.factor(P10),
         Edad = as.factor(Edad),
         P24 = as.factor(P24),
         P24_A = as.factor(P24_A),
         P25 = as.factor(P25),
         P31 = as.factor(P31))

interestingVars <- c('P10', 'Edad','P24', 'P24_A', 'P25', 'P31')

summarize_HHTS <- function(df, dd, varsOfInterest) {
  d3 <- data.frame()
  for (i in varsOfInterest) {
    d1 <- subset(dd, variable == i)
    d2 <- trips %>%
      group_by(trips[,i]) %>%
      summarize(count = n()) %>%
      mutate(countPct = round(count/sum(count, na.rm = T)*100,1))
    colnames(d2)[1] <- "value"
    d1 <- merge(d2, d1, by = "value", all = T)
    d3 <- rbind(d3, d1)
  }
  return(d3)
}

summary_counts_noTot <- summarize_HHTS(trips, dd, interestingVars)
summary_counts_reclass <- drop_na(summary_counts_noTot) %>%
  group_by(description, recode) %>%
  summarize(total_response = sum(count)) %>%
  group_by(description) %>%
  mutate(total_response_pct = round(total_response/sum(total_response)*100, 1))

ggplot(summary_counts_reclass, aes(x = recode, y = total_response_pct)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(facets = "description", scales = "free", ) +
  labs(x = "", y = "Percentage") +
  theme_minimal() +
  theme(
    strip.text.x = element_text(size = 12),
    axis.text.x = element_text(angle = 70, hjust = 1, size = 8))


# ggplot(summary_counts_long, aes(x = label, y = data, fill = value_type)) +
#  geom_bar(stat = "identity", position = "dodge") +
#  facet_wrap(~ description, scales = "free") +
#  labs(x = "Label", y = "Percentage", fill = "Percentage Type") +
#  theme_minimal() +
#   theme(
#     strip.text.x = element_text(size = 12),
#    axis.text.x = element_text(angle = 70, hjust = 1, size = 8)
#   )
# summary_age <- trips %>%
#   group_by(Edad) %>%
#   summarize(total = sum(Fact_Expa_Per)) %>%
#   mutate(percent = total/sum(total)) %>%
#   left_join(dd %>% subset(variable == "Edad") %>% select(value, label), by = c("Edad" = "value")) %>%
#   left_join(x = dd, by = "label")

# summary_age2 <- trips %>%
#   group_by(P25) %>%
#   summarize(variable = "P25",
#             count = n(),
#             total = sum(Fact_Expa_Per)) %>%
#   mutate(countPct = round(count/sum(count)*100, 1),
#          totalPct = round(total/sum(total)*100, 1))


# summary_modeType <- trips %>%
#   group_by(P24) %>%
#  summarize(total = sum(Fact_Expa_Per)) %>%
#  mutate(percent = total/sum(total)) %>%
#   left_join(dd %>% subset(variable == "P24") %>% select(value, label), by = c("P24" = "value"))

# varsOfInterest <- c('P10', 'Edad', 'linea_M','P24', 'P24_A', 'P25', 'P31')
# summary_counts <- data.frame()
# for (i in varsOfInterest){
#  d1 <- subset(dd, variable == i)
#   d2 <- trips %>%
#     group_by(trips[,i]) %>%
#     summarize(count = n(),
#               total = round(sum(Fact_Expa_Per), 0)) %>%
#     mutate(countPct = round(count/sum(count)*100, 1),
#            totalPct = round(total/sum(total)*100, 1))
#   colnames(d2)[1] <- "value"
#   d1 <- left_join(d1, d2, by = "value")
#   summary_counts <- rbind(summary_counts, d1)
# }
# summary_counts_long <- select(summary_counts_noTot, -total_response) %>%
#   pivot_longer(cols = c(countPct, totalPct), names_to = "value_type", values_to = "data")
# summary_counts_long[is.na(summary_counts_long$data), "data"] <- 0
