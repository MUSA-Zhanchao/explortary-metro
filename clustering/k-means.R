library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(haven)
# install.packages("factoextra")  # for elbow/silhouette plots if you like
library(factoextra)

# --- load and filter ---
hog <- readRDS("data/008-24 BBDD Procesamiento Hogares.rds")

nonsupporter <- hog %>%
  filter(P68 == 2)

# --- select your survey items and keep ID for later ---
km_data <- nonsupporter %>%
  select(ID_Hogar, P87:P101)

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

# --- run k-means for K = 2:5 and collect total within‐cluster SS ---
results <- tibble(Classes = 2:5, TotWithinSS = NA_real_)
for (k in results$Classes) {
  set.seed(123)
  km <- kmeans(km_matrix, centers = k, nstart = 25)
  results <- results %>%
    mutate(TotWithinSS = replace(TotWithinSS, Classes == k, km$tot.withinss))
}
print(results)

# --- choose a “best” K (e.g. 3) and fit final model ---
set.seed(123)
final_k <- 10
km_final <- kmeans(km_matrix, centers = final_k, nstart = 25)

# --- merge cluster labels back into the factor data frame ---
km_data_f$cluster <- factor(km_final$cluster)

# --- cluster sizes ---
print(table(km_data_f$cluster))

# --- summary of response‐patterns by cluster ---
k_means_summary_table <- km_data_f %>%
  group_by(cluster) %>%
  summarise(across(-ID_Hogar,
                   ~ paste0(round(100 * prop.table(table(.)), 1), collapse = "; ")),
            .groups = "drop")
k_means_summary_table$count<-table(km_data_f$cluster)
print(k_means_summary_table)

# --- optional: view centroids on the original Likert‐scale for interpretation ---
centroids <- km_final$centers %>%
  as.data.frame() %>%
  # if you want to back‐transform to original 1–5 scale roughly:
  sweep(., 2, attr(km_matrix, "scaled:scale"), `*`) %>%
  sweep(., 2, attr(km_matrix, "scaled:center"), `+`)

print(centroids)


#### additional plot
# --- 1. Run PCA on the scaled matrix you already have ---
pca <- prcomp(km_matrix, center = FALSE, scale. = FALSE)

# --- 2. Build a data frame of the first two PCs + cluster labels ---
plot_data <- pca$x[, 1:2] %>%
  as.data.frame() %>%
  setNames(c("PC1", "PC2")) %>%
  mutate(cluster = km_data_f$cluster)

# --- 3. (Optional) Compute centroids in PC space for annotation ---
centroids_pc <- predict(pca,
                        newdata = sweep(centroids, 2,
                                        attr(km_matrix, "scaled:center"),
                                        `-`) %>%
                          sweep(2,
                                attr(km_matrix, "scaled:scale"),
                                `/`)
)[, 1:2] %>%
  as.data.frame() %>%
  setNames(c("PC1", "PC2")) %>%
  mutate(cluster = factor(1:nrow(.)))

# --- 4. Plot ---
ggplot(plot_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 3, alpha = 0.8) +
  stat_ellipse(type = "norm", linetype = 2, level = 0.68) +  # 1-sd contour
  geom_point(data = centroids_pc, aes(x = PC1, y = PC2),
             shape = 17, size = 5, stroke = 1.5, show.legend = FALSE) +
  labs(title = "K-means Clusters (k = 10) in PCA Space",
       x = "Principal Component 1",
       y = "Principal Component 2",
       color = "Cluster") +
  theme_minimal(base_size = 14)
