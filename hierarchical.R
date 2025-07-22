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
cat("Cluster sizes (k=2):\n")
print(table(hc_data$cluster2))

summary_table2 <- hc_data %>%
  group_by(cluster2) %>%
  summarise(across(-ID_Hogar,
                   ~ paste0(round(prop.table(table(.)) * 100, 1), collapse = ", ")
  ))
summary_table2$count<- table(hc_data$cluster2)
cat("\nCluster summaries (k=2):\n")
print(summary_table2)
