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
  select(ID_Hogar, P87:P101)

lca_data <- lca_data %>%
  mutate(across(-ID_Hogar, ~as_factor(.)))




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
  model <- poLCA(f, data = lca_data, nclass = k, maxiter = 1000)

  results <- rbind(results,
                   data.frame(
                     Classes = k,
                     LogLikelihood = model$llik,
                     AIC = model$aic,
                     BIC = model$bic
                   ))
}


# --- 模型解释 ---
# k=3时

# 当k=3时
set.seed(123)
best_model <- poLCA(f, data = lca_data, nclass = 3, maxiter = 1000, graphs = TRUE)

lca_data$cluster <- best_model$predclass

table(lca_data$cluster)

summary_table <- lca_data %>%
  group_by(cluster) %>%
  summarise(across(-ID_Hogar, ~ paste0(round(prop.table(table(.)) * 100, 1), collapse = ", ")))
summary_table$count <- table(lca_data$cluster)
print(summary_table)


# k=2
set.seed(123)
best_model_k2 <- poLCA(f, data = lca_data, nclass = 2, maxiter = 1000, graphs = TRUE)
lca_data$cluster_k2 <- best_model_k2$predclass
table(lca_data$cluster_k2)
summary_table_k2 <- lca_data %>%
  group_by(cluster_k2) %>%
  summarise(across(-ID_Hogar, ~ paste0(round(prop.table(table(.)) * 100, 1), collapse = ", ")))

summary_table_k2$count <- table(lca_data$cluster_k2)
print(summary_table_k2)
