library(haven)
library(cluster)
library(tidyverse)

data <- read.csv("data/cluster_data_prep.csv")

hc_data <- data %>%
  select(-P14,-P1,-Estacion, -P9)

# --- convert to factors (if not already) and keep a copy for summary ---
hc_data <- hc_data %>%
  mutate(across(-ID_Hogar, as_factor))

diss <- daisy(hc_data %>% select(-ID_Hogar), metric = "gower")


# --- Build hierarchical clustering tree ---
hc <- hclust(diss, method = "ward.D2")

# Visualize dendrogram
plot(hc, labels = FALSE, hang = -1, main = "Dendrogram (Ward D2)")
# Cut and highlight at k=3
rect.hclust(hc, k = 3, border = 2:4)


# --- Evaluate average silhouette coefficient for different cluster numbers ---
sil_results <- data.frame(Clusters = 2:5, Avg_Silhouette = NA_real_)

for(k in sil_results$Clusters) {
  cl <- cutree(hc, k = k)
  sil <- silhouette(cl, diss)
  sil_results$Avg_Silhouette[sil_results$Clusters == k] <- mean(sil[, "sil_width"])
}

print(sil_results)
# Use Avg_Silhouette to help select the optimal k


# --- k = 5 时的簇标记 & 摘要 ---
hc_data$cluster2 <- cutree(hc, k = 5)
cat("Cluster sizes (k=5):\n")
print(table(hc_data$cluster2))

summary_table2 <- hc_data %>%
  group_by(cluster2) %>%
  summarise(across(-ID_Hogar,
                   ~ paste0(round(prop.table(table(.)) * 100, 1), collapse = ", ")
  ))
summary_table2$count <- table(hc_data$cluster2)
cat("\nCluster summaries (k=5):\n")
print(summary_table2)

write.csv(summary_table2, "output/final/cluster_summary_hierarchical.csv", row.names = FALSE)

df <- read.csv("output/final/hierarchical_full/cluster_summary_hierarchical.csv", 
               stringsAsFactors = FALSE, 
               check.names = FALSE)%>%
  select(-count)

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

