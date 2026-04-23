
library(tidyverse)
library(rstatix)
library(pheatmap)
library(venn)

# 1. LOAD
alz_data <- readRDS("alzheimer_sample.rds")

# 1. METADATA CLEANING 
s_clean <- alz_data$sample_data %>%
  dplyr::select(sample = sample, 
                Status_raw = `subject status:ch1`, 
                Source_raw = `source_name_ch1`) %>%
  mutate(
    Status = ifelse(str_detect(Status_raw, "Alzheimer"), "AD", "NC"),
    Source = ifelse(str_detect(Source_raw, "Plasma"), "Plasma", "CSF")
  )

# 2. PREPARING THE EXPRESSION
e_long <- alz_data$expression_data %>%
  pivot_longer(cols = starts_with("JSAUG"), names_to = "sample", values_to = "Ct")

print(paste("Samples with metadata:", sum(unique(e_long$sample) %in% s_clean$sample)))

# 3. ddCt NORMALIZATION (miR-16-5p)
norm_mir <- "hsa-miR-16-5p"

final_df <- e_long %>%
  group_by(sample) %>%

  mutate(norm_val = if(any(Assay.Name == norm_mir)) Ct[Assay.Name == norm_mir][1] else NA) %>%
  filter(!Assay.Name %in% c("Control Probe", "Negative", norm_mir)) %>%
  mutate(dCt = Ct - norm_val) %>%

  inner_join(s_clean, by = "sample") %>%

  group_by(Assay.Name, Source) %>%
  mutate(ref_val = mean(dCt[Status == "NC"], na.rm = TRUE)) %>%
  mutate(LFC = -(dCt - ref_val)) %>%
  ungroup()

# 4. STATISTICS 
stats <- final_df %>%
  filter(!is.na(LFC)) %>%
  group_by(Source, Assay.Name) %>%

  filter(n_distinct(Status) == 2) %>%
  wilcox_test(LFC ~ Status) %>%

  adjust_pvalue(method = "BH")

# 5. COLLECTING DATA FOR GRAPHS

final_sig <- final_df %>%
  left_join(stats %>% dplyr::select(Source, Assay.Name, p, p.adj), by = c("Source", "Assay.Name")) %>%
  group_by(Source, Assay.Name) %>%
  mutate(med_LFC = median(LFC[Status == "AD"], na.rm = TRUE)) %>%

  mutate(LFC_final = ifelse(!is.na(p) & p < 0.05, med_LFC, 0)) %>%
  ungroup()

# 6. HEATMAP
heat_mat <- final_sig %>%
  filter(Status == "AD") %>%
  group_by(Source, Assay.Name) %>%
  summarise(val = median(LFC_final), .groups = "drop") %>%
  pivot_wider(names_from = Source, values_from = val) %>%

  filter(Plasma != 0 | CSF != 0) %>%
  column_to_rownames("Assay.Name")

if(nrow(heat_mat) > 0) {
  pheatmap(heat_mat, display_numbers = TRUE, 
           color = colorRampPalette(c("dodgerblue", "white", "firebrick1"))(100),
           main = "Significant miRNAs (AD vs NC, p < 0.05)")
} else {
  print("No significant genes were found..")
}

# 7. VENN
p_genes <- final_sig %>% filter(Source == "Plasma", p < 0.05) %>% pull(Assay.Name) %>% unique()
c_genes <- final_sig %>% filter(Source == "CSF", p < 0.05) %>% pull(Assay.Name) %>% unique()

if(length(p_genes) > 0 | length(c_genes) > 0) {
  venn(list(Plasma = p_genes, CSF = c_genes), zcolor = "style", snames = "Plasma, CSF", ilabels = "counts")
}

