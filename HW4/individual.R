# ==============================================================================
# INDIVIDUAL PROJECT: Alzheimer's Disease (GSE153873)
# ==============================================================================

# 1. LOADING LIBRARIES
library(DESeq2)
library(tidyverse)
library(pheatmap)
library(org.Hs.eg.db)
library(clusterProfiler)
library(pathview)
library(GEOquery)


# 2. SMART LOADING AND PREPARATION

counts_raw <- read.table("GSE153873_summary_count.star.txt.gz", 
                         header = TRUE, row.names = 1, check.names = FALSE)

#  loading metadata
gse <- getGEO("GSE153873", getGPL = FALSE)
metadata <- pData(gse[[1]])

# LET'S FIND OUT WHAT GROUPS ARE REALLY NAMES
all_statuses <- unique(metadata$`disease state:ch1`)
print("Statuses found in the file:")
print(all_statuses)

# we define the groups we need
ad_label <- all_statuses[grep("AD|Alzheimer", all_statuses, ignore.case = TRUE)][1]
old_label <- all_statuses[grep("Old", all_statuses, ignore.case = TRUE)][1]

print(paste("Use for AD:", ad_label))
print(paste("Use for Old:", old_label))

metadata_clean <- metadata %>%
  dplyr::select(title, geo_accession, status = `disease state:ch1`) %>%
  dplyr::filter(status %in% c(ad_label, old_label)) %>%
  dplyr::mutate(status = ifelse(status == ad_label, "AD", "Old"))

colnames(counts_raw) <- gsub("\\.", "-", colnames(counts_raw))

# comparison and verification of the correctness of names
common_samples <- intersect(colnames(counts_raw), metadata_clean$title)

if(length(common_samples) == 0) {
  stop("ERROR: Samples still don't match! Check head(colnames(counts_raw)) and head(metadata_clean$title)")
}

counts <- counts_raw[, common_samples]
metadata_final <- metadata_clean %>% dplyr::filter(title %in% common_samples)
rownames(metadata_final) <- metadata_final$title

print("Yupii! The groups are connected:")
print(table(metadata_final$status))







# 3. CREATING A DESeq2 OBJECT
coldata <- data.frame(row.names = colnames(counts), 
                      Condition = factor(metadata_final$status, levels = c("Old", "AD")))

dds <- DESeqDataSetFromMatrix(countData = counts, colData = coldata, design = ~ Condition)

# Filtering (minimum 10 readings in 3 samples)
keep <- rowSums(counts(dds) >= 10) >= 3
dds <- dds[keep, ]

# 4. NORMALIZATION AND PCA
vsd <- vst(dds, blind = FALSE)

plotPCA(vsd, intgroup = "Condition") + 
  theme_minimal() + 
  scale_color_manual(values = c("Old" = "dodgerblue", "AD" = "firebrick1")) +
  labs(title = "PCA: Alzheimer's Disease vs Old Control", subtitle = "Hippocampus Samples")

# 5. Differential Expression Analysis
dds <- DESeq(dds)
res <- results(dds, contrast = c("Condition", "AD", "Old"))
res_df <- as.data.frame(res) %>% na.omit()

# 6. GENE ANNOTATION
res_df$symbol <- rownames(res_df)

#  Entrez ID for KEGG 
res_df$entrez <- mapIds(org.Hs.eg.db, 
                        keys = res_df$symbol, 
                        column = "ENTREZID", 
                        keytype = "SYMBOL", 
                        multiVals = "first")

# Classification of genes
res_df$Significance <- "Not Significant"
res_df$Significance[res_df$log2FoldChange > 1 & res_df$padj < 0.05] <- "Upregulated"
res_df$Significance[res_df$log2FoldChange < -1 & res_df$padj < 0.05] <- "Downregulated"

# 7. VISUALIZATION
# Volcano Plot
ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = Significance)) +
  geom_point(alpha = 0.4) +
  scale_color_manual(values = c("Downregulated" = "blue", "Not Significant" = "grey", "Upregulated" = "red")) +
  theme_minimal() + labs(title = "Volcano Plot: AD vs Old Control")

# Heatmap TOP-30
top30_idx <- head(order(res$padj), 30)
pheatmap(assay(vsd)[top30_idx, ], 
         cluster_rows = TRUE, cluster_cols = TRUE,
         scale = "row", annotation_col = coldata,
         labels_row = rownames(res_df)[top30_idx],
         main = "Top 30 DEGs in AD Brain")

# 8.ENRICHMENT
# List of genes (Entrez) for analysis
sig_genes_entrez <- na.omit(res_df$entrez[res_df$Significance != "Not Significant"])

# GO (Biological Process)
ego <- enrichGO(gene          = sig_genes_entrez,
                OrgDb         = org.Hs.eg.db,
                ont           = "BP",
                pAdjustMethod = "BH",
                pvalueCutoff  = 0.05)

dotplot(ego, showCategory = 15) + labs(title = "GO: Biological Processes (AD vs Old)")

# KEGG 
ekegg <- enrichKEGG(gene         = sig_genes_entrez,
                    organism     = 'hsa', 
                    pvalueCutoff = 0.05)

barplot(ekegg, showCategory = 10) + labs(title = "KEGG Pathways: Alzheimer's Disease")

# 9. PATHWAY VISUALIZATION (hsa05010 - Alzheimer disease)
lfc_vector <- res_df$log2FoldChange
names(lfc_vector) <- res_df$entrez

pathview(gene.data = lfc_vector, 
         pathway.id = "hsa05010", 
         species = "hsa", 
         limit = list(gene = 2, cpd = 1))

# 10. SAVE
write.csv(res_df, "AD_Final_Results.csv")
