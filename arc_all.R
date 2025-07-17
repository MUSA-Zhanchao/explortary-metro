library(haven)
library(cluster)
library(tidyverse)

# --- 数据载入 & 清洗 ---
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")
personas<- readRDS("data/008-24 BBDD Procesamiento personas.rds")

check<- personas%>%
  group_by(posicionActual)%>%
  summarise(count= n())

household_head<- personas%>%
  filter(posicionActual == "primer")

hc_data <- hog %>%
  select(ID_Hogar,P68, P87:P101) %>%
  mutate(across(-ID_Hogar, as.factor))


# --- 计算 Gower 距离矩阵 ---
# （适用于有序/分类变量的混合数据）
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


# --- k = 2 时的簇标记 & 摘要 ---
hc_data$cluster2 <- cutree(hc, k = 4)
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
