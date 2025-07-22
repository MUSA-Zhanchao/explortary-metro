library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(haven)
library(factoextra)

data <- read.csv("data/cluster_data_prep.csv")

# --- select your survey items and keep ID for later ---
km_data <- data %>%
  select(-P14,-P1,-Estacion, -P9)

# --- convert to factors (if not already) and keep a copy for summary ---
km_data_f <- km_data %>%
  mutate(across(-ID_Hogar, as_factor))

# --- prepare numeric matrix for k-means: factor → integer → scale ---
km_matrix <- km_data_f %>%
  select(-ID_Hogar) %>%
  mutate(across(everything(), as.integer)) %>%
  scale()

# --- choose number of clusters (optional diagnostics) ---
set.seed(123)
fviz_nbclust(km_matrix, kmeans, method = "wss")         # Elbow plot
fviz_nbclust(km_matrix, kmeans, method = "silhouette")  # Silhouette widths

# --- choose a “best” K (e.g. 6, based on diagnostics) and fit final model ---
set.seed(123)
final_k <- 6  # Chosen based on earlier diagnostics (e.g., elbow plot or silhouette widths)
km_final <- kmeans(km_matrix, centers = final_k, nstart = 25)

# --- merge cluster labels back into the factor data frame ---
km_data_f$cluster <- factor(km_final$cluster)

# --- cluster sizes ---
print(table(km_data_f$cluster))

# --- summary of response‐patterns by cluster ---
k_means_summary_table <- km_data_f %>%
  group_by(cluster) %>%
  summarise(across(-ID_Hogar,
                   ~ paste0(round(100 * prop.table(table(.)), 1), collapse = ", ")),
            .groups = "drop")
k_means_summary_table$count<-table(km_data_f$cluster)
print(k_means_summary_table)

write.csv(k_means_summary_table, "output/k_means_summary.csv", row.names = FALSE)

df <- read.csv("output/k_means_summary.csv", 
               stringsAsFactors = FALSE, 
               check.names = FALSE)%>%
  filter(cluster== 6) %>%  # Exclude cluster 6 if needed
  select(-count)
R <- nrow(df)
group_probs <- rep(1/R, R)

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
first_idx <- 1:3
second_idex<- 4:6
third_idx <- 7:9
forth_idx <- 10:12
fifth_idx <- 13:15
sixth_idx <- 16

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
