library(poLCA)
library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(haven)

hog<-readRDS("data/008-24 BBDD Procesamiento Hogares.rds")


# --- 模型数据清洗 ---
nonsupporter <- hog %>%
  filter(P68==2)

lca_data <- nonsupporter %>%
  select(ID_Hogar, P1,P82, P50, P87:P101)

lca_data <- lca_data %>%
  mutate(across(-ID_Hogar, ~as_factor(.)))

lca_data <- lca_data %>%
  filter(P50 != "NS/NR")


# --- 建模 ---
f <- as.formula(paste("cbind(", paste(names(lca_data)[-1], collapse = ", "), ") ~ 1"))

results <- data.frame(Classes = integer(),
                      LogLikelihood = numeric(),
                      AIC = numeric(),
                      BIC = numeric(),
                      stringsAsFactors = FALSE)

set.seed(123)
for (k in 2:5) {
  cat("Estimating", k, "classes...\n")
  model <- poLCA(f, data = lca_data, nclass = k, maxiter = 1000, graphs = TRUE)

  results <- rbind(results,
                   data.frame(
                     Classes = k,
                     LogLikelihood = model$llik,
                     AIC = model$aic,
                     BIC = model$bic
                   ))
}


# --- 模型解释 ---
# k=2时，模型最优。此时，LogLikelihood=-499.10， AIC=1140.20, BIC =1261.86

# 当k=2时
set.seed(123)
best_model <- poLCA(f, data = lca_data, nclass = 2, maxiter = 1000, graphs = TRUE)

lca_data$cluster <- best_model$predclass

table(lca_data$cluster)

summary_table <- lca_data %>%
  group_by(cluster) %>%
  summarise(across(-ID_Hogar, ~ paste0(round(prop.table(table(.)) * 100, 1), collapse = ", ")))

print(summary_table)

lca_data%>%group_by(P90,cluster)%>%summarise(
  count = n()
)
