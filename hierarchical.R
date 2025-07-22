library(haven)
library(cluster)
library(tidyverse)

data<- read.csv("data/cluster_data_prep.csv")

hc_data <- data %>%
  select(-P14,-P1,-Estacion, -P9)

# --- convert to factors (if not already) and keep a copy for summary ---
hc_data <- hc_data %>%
  mutate(across(-ID_Hogar, as_factor))

diss <- daisy(hc_data %>% select(-ID_Hogar), metric = "gower")


# --- 构建层次聚类树 ---
hc <- hclust(diss, method = "ward.D2")

# 可视化树状图
plot(hc, labels = FALSE, hang = -1, main = "Dendrogram (Ward D2)")
# 在 k=3 处切分并标出
rect.hclust(hc, k = 3, border = 2:4)


# --- 评估不同簇数的平均轮廓系数 ---
sil_results <- data.frame(Clusters = 2:5, Avg_Silhouette = NA_real_)

for(k in sil_results$Clusters) {
  cl <- cutree(hc, k = k)
  sil <- silhouette(cl, diss)
  sil_results$Avg_Silhouette[sil_results$Clusters == k] <- mean(sil[, "sil_width"])
}

print(sil_results)
# 通过 Avg_Silhouette 辅助选择最优 k


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