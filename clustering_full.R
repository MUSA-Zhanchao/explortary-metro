library(poLCA)
library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(haven)

data <- read.csv("data/cluster_data_prep.csv")

data <- data %>%
  mutate(
    P14 = ifelse(is.na(P14), 99, P14)
  )%>%
  select(-Estacion,-P9)

data <- data %>%
  mutate(across(-ID_Hogar, as_factor))

f <- as.formula(paste("cbind(", paste(names(data)[-1], collapse = ", "), ") ~ 1"))

results <- data.frame(Classes = integer(),
                      LogLikelihood = numeric(),
                      AIC = numeric(),
                      BIC = numeric(),
                      stringsAsFactors = FALSE)

set.seed(123)
for (k in 2:5) {
  cat("Estimating", k, "classes...\n")
  model <- poLCA(f, data = data, nclass = k, maxiter = 1000, graphs = TRUE)

  results <- rbind(results,
                   data.frame(
                     Classes = k,
                     LogLikelihood = model$llik,
                     AIC = model$aic,
                     BIC = model$bic
                   ))
}

set.seed(123)
best_model <- poLCA(f, data = data, nclass = 5,
                    maxiter = 1000, graphs = TRUE)
data$cluster <- best_model$predclass

# 6. Check cluster sizes
print(table(data$cluster))

# 7. Create a profile summary of each cluster
summary_table <- data %>%
  group_by(cluster) %>%
  summarise(
    across(
      where(is.factor),
      ~ paste0(round(prop.table(table(.)) * 100, 1), collapse = ", ")
    )
  )
print(summary_table)
