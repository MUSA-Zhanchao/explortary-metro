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

write.csv(summary_table, "output/final/cluster_summary.csv", row.names = FALSE)

# —— 1. Read in your CSV —— 
# adjust the path if needed
df <- read.csv("output/lca_full/cluster_summary.csv", 
               stringsAsFactors = FALSE, 
               check.names = FALSE)

# —— 2. Define your group proportions —— 
# (you'll need to supply the actual shares; here’s a dummy equal-share vector)
R <- nrow(df)
group_probs <- rep(1/R, R)

# —— 3. Parse each column of "x, y, z" into a numeric matrix —— 
# skipping the first column if it’s just a cluster ID
vars <- names(df)[-1]
probs <- lapply(vars, function(var) {
  # split each row’s string into numbers, build a matrix (R × K_j)
  mat <- t(sapply(df[[var]], function(cell) {
    nums <- as.numeric(strsplit(cell, ",\\s*")[[1]])
    nums / 100            # convert percent to [0,1]
  }))
  # give the columns names if you like (optional)
  colnames(mat) <- paste0("cat", seq_len(ncol(mat)))
  mat
})
names(probs) <- vars

# —— 4. (Re-)define your plotting function —— 
plot_custom_group_probs <- function(probs, group_probs, var_labels = names(probs)) {
  R <- length(group_probs)
  J <- length(probs)
  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))
  
  par(mfrow = c(R, J), mar = c(4, 4, 2, 1))
  for (r in seq_len(R)) {
    for (j in seq_len(J)) {
      p <- probs[[j]][r, ]
      cn <- colnames(probs[[j]])
      barplot(p,
              horiz     = TRUE,
              names.arg = cn,
              main      = paste0("Grp ", r, ": ", var_labels[j]),
              xlim      = c(0, 1),
              las       = 1)
    }
  }
}



R <- length(group_probs)

# split your probs list into two chunks
first_idx <- 1:3
second_idex<- 4:6
third_idx <- 7:9
forth_idx <- 10:12
fifth_idx <- 13:15
sixth_idx <- 16:18

plot_custom_group_probs(
  probs[first_idx], 
  group_probs, 
  var_labels = names(probs)[first_idx]
)
plot_custom_group_probs(
  probs[second_idex], 
  group_probs, 
  var_labels = names(probs)[second_idex]
)
plot_custom_group_probs(
  probs[third_idx], 
  group_probs, 
  var_labels = names(probs)[third_idx]
)
plot_custom_group_probs(
  probs[forth_idx], 
  group_probs, 
  var_labels = names(probs)[forth_idx]
)
plot_custom_group_probs(
  probs[fifth_idx], 
  group_probs, 
  var_labels = names(probs)[fifth_idx]
)
plot_custom_group_probs(
  probs[sixth_idx], 
  group_probs, 
  var_labels = names(probs)[sixth_idx]
)
