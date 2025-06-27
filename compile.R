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
# general information availability
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

