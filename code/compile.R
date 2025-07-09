library(tidyverse)
library(haven)
library(tidyr)
library(purrr)
library(openxlsx)
library(scales)

######
## Load the datasets and preprocessing
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
per <- readRDS("data/008-24 BBDD Procesamiento Personas.rds")

line1<- hog%>%
  filter(linea_M == 1)

line2<- hog%>%
  filter(linea_M == 2)


########
# metro attitute
count_pct <- function(data, var) {
  data %>%
    count({{ var }}) %>%
    mutate(
      Percentage = n / sum(n) * 100
    ) %>%
    mutate(
      {{ var }} := case_when(
        {{ var }} == 1 ~ "Yes",
        {{ var }} == 2 ~ "No",
        TRUE         ~ as.character({{ var }})
      )
    )
}

# P58: Rapid and efficient
P58_line1<- count_pct(line1, P58)
P58_line2<- count_pct(line2, P58)

#P59 benfit to condition of your physical and mental health
P59_line1<- count_pct(line1, P59)
P59_line2<- count_pct(line2, P59)

#P60: enough information about the metro route
P60_line1<- count_pct(line1, P60)
P60_line2<- count_pct(line2, P60)

# P61: travel time: on time and reliable
p61_line1<- count_pct(line1, P61)
p61_line2<- count_pct(line2, P61)

# P62: environmental friendly
p62_line1<- count_pct(line1, P62)
p62_line2<- count_pct(line2, P62)

#P63: safe travel choice
p63_line1<- count_pct(line1, P63)
p63_line2<- count_pct(line2, P63)

#P64: prefer other transportation modes
p64_line1<- count_pct(line1, P64)
p64_line2<- count_pct(line2, P64)

# P68:  agree or disagree with the metro project
p68_line1<- count_pct(line1, P68)
p68_line2<- count_pct(line2, P68)

#P78: prefer metro over other transportation modes
p78_line1 <- count_pct(line1, P78)
p78_line2 <- count_pct(line2, P78)

########
# evaluate metro impacts

three_opt <- function(data, var) {
  data %>%
    count({{ var }}) %>%
    mutate(
      Percentage = n / sum(n) * 100
    ) %>%
    mutate(
      {{ var }} := case_when(
        {{ var }} == 1 ~ "increase",
        {{ var }} == 2 ~ "not change",
        {{ var }} == 3 ~ "decrease",
        TRUE         ~ as.character({{ var }})
      )
    )
}

#P87: property value or rent
p87_line1 <- three_opt(line1, P87)
p87_line2 <- three_opt(line2, P87)

#P90: community safety
p90_line1 <- three_opt(line1, P90)
p90_line2 <- three_opt(line2, P90)

#p91: living expense
p91_line1 <- three_opt(line1, P91)
p91_line2 <- three_opt(line2, P91)

#P92: local commerical
p92_line1 <- three_opt(line1, P92)
p92_line2 <- three_opt(line2, P92)

#P95: satisfied with public transit
p95_line1 <- three_opt(line1, P95)
p95_line2 <- three_opt(line2, P95)

#P96: travel time
p96_line1 <- three_opt(line1, P96)
p96_line2 <- three_opt(line2, P96)

# P98: hearing noise
p98_line1 <- three_opt(line1, P98)
p98_line2 <- three_opt(line2, P98)

# P100: public space
p100_line1 <- three_opt(line1, P100)
p100_line2 <- three_opt(line2, P100)

# P101: New housing projects
p101_line1 <- three_opt(line1, P101)
p101_line2 <- three_opt(line2, P101)

########
# Information availability

five_opt <- function(data, var) {
  data %>%
    count({{ var }}) %>%
    mutate(
      Percentage = n / sum(n) * 100
    ) %>%
    mutate(
      {{ var }} := case_when(
        {{ var }} == 1 ~ "No Information at all",
        {{ var }} == 2 ~ "Little Information",
        {{ var }} == 3 ~ "Some Information",
        {{ var }} == 4 ~ "A lot of Information",
        {{ var }} == 5 ~ "All Information",
        TRUE         ~ as.character({{ var }})
      )
    )
}

# P70: type of metro information
p70_line1 <- five_opt(line1, P70)
p70_line2 <- five_opt(line2, P70)

# P71: metro route
p71_line1 <- five_opt(line1, P71)
p71_line2 <- five_opt(line2, P71)

# P72: station location
p72_line1 <- five_opt(line1, P72)
p72_line2 <- five_opt(line2, P72)

# P73: construction timeline
p73_line1 <- five_opt(line1, P73)
p73_line2 <- five_opt(line2, P73)


##### other
# P83: living time
p83_line1 <- line1 %>%
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
  )

P83_line2 <- line2 %>%
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
  )


# P82: rent and own
p82_line1<- line1 %>%
  count(P82) %>%
  mutate(
    P82 = case_when(
      P82 == 1 ~ "Own",
      P82 == 2 ~ "Rent",
      TRUE     ~ as.character(P82)
    ),
    Percentage = (n / sum(n)) * 100
  )

p82_line2<- line2 %>%
  count(P82) %>%
  mutate(
    P82 = case_when(
      P82 == 1 ~ "Own",
      P82 == 2 ~ "Rent",
      TRUE     ~ as.character(P82)
    ),
    Percentage = (n / sum(n)) * 100
  )

# P86: renting cost

p86_line1 <- line1%>%
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
      P86 == 8  ~ "More than $5,000,000"
    )
  )

p86_line2 <- line2 %>%
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
      P86 == 8  ~ "More than $5,000,000"
    )
  )

# P65_1: most important factor in travel

p65_line1 <- line1 %>%
  count(P65_1) %>%
  mutate(
    P65_1 = case_when(
      P65_1 == 1 ~ "Time of trip",
      P65_1 == 2 ~ "Closeness of station",
      P65_1 == 3 ~ "Comfort during trip",
      P65_1 == 4 ~ "Security on the system",
      P65_1 == 5 ~ "Cost of travel",
      P65_1 == 6 ~ "Environmental impact of transport mode",
      P65_1 == 7 ~ "Punctuality of buses",
      TRUE      ~ NA_character_   # catch any unexpected codes
    ),
    Percentage = n / sum(n) * 100
  )

p65_line2 <- line2 %>%
  count(P65_1) %>%
  mutate(
    P65_1 = case_when(
      P65_1 == 1 ~ "Time of trip",
      P65_1 == 2 ~ "Closeness of station",
      P65_1 == 3 ~ "Comfort during trip",
      P65_1 == 4 ~ "Security on the system",
      P65_1 == 5 ~ "Cost of travel",
      P65_1 == 6 ~ "Environmental impact of transport mode",
      P65_1 == 7 ~ "Punctuality of buses",
      TRUE      ~ NA_character_   # catch any unexpected codes
    ),
    Percentage = n / sum(n) * 100
  )
