#FIRST
library(tidyverse)

# 1. Loading data
df <- read.csv("possum.csv")

# 2. Data reformatting
df_long <- df %>%
  pivot_longer(cols = -c(case, site, Pop, sex, age), 
               names_to = "parameter", 
               values_to = "value") %>%
  group_by(parameter) %>%
  mutate(log_z = log2(value / median(value, na.rm = TRUE))) %>%
  ungroup()

# 3.Heatmap
ggplot(df_long, aes(x = as.factor(case), y = parameter, fill = log_z)) +
  geom_tile() +
  facet_wrap(~Pop, scales = "free_x") +
  scale_fill_gradient2(low = "dodgerblue", mid = "white", high = "firebrick1") +
  theme_minimal() +
  labs(title = "Possum Measurements Heatmap",
       x = "Individual Case ID",
       y = "Parameter",
       fill = "Log2(Z-score)") +
  theme(axis.text.x = element_blank()) 




#SECOND

# 1. Create a new dataframe with the required columns
ddct_refined <- ddct1 %>%
  select(target.y, source, treatment.y, tree, LFC) %>%
  # 2. Grouping for averaging (include LFC)
  group_by(target.y, source, treatment.y, tree) %>%
  mutate(LFC_mean = mean(LFC, na.rm = TRUE)) %>%
  ungroup() %>%
  # 3. Remove extra lines and NA
  distinct(target.y, source, treatment.y, tree, .keep_all = TRUE) %>%
  filter(!is.na(source), !is.na(treatment.y), !is.na(target.y))

ddct_refined <- ddct_refined %>%
  mutate(
    treatment.y = paste0(treatment.y, "% PEG"),
    tree = paste("Tree", tree),
    source = case_when(
      source == "Br" ~ "Branches",
      source == "Bu" ~ "Buds",
      TRUE ~ source
    )
  )


# 4.Heatmap
ggplot(ddct_refined, aes(x = tree, y = target.y, fill = LFC_mean)) +
  geom_tile(color = "white") + 
  facet_grid(source ~ treatment.y) +
  scale_fill_gradient2(low = "firebrick1", mid = "black", high = "dodgerblue") +
  theme_light() +
  labs(x = "", y = "Gene Name", fill = "LFC") +
  theme(
    axis.text.y = element_text(face = "italic", size = 10),
    strip.text = element_text(face = "bold", size = 12),
    panel.spacing = unit(1, "lines")
  )




