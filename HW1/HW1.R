# Generating data
set.seed(42)

sun <- sample(10:30, 1000, replace = T)
height <- 10 + 2*sun + rnorm(1000, sd = 10)

# 1. Average growth of plants that received more than 25 days of sunshine
mean_high_sun <- mean(height[sun > 25])
print(paste("Mean height (>25 sun):", mean_high_sun))

# 2. Average plant growth (15 to 25 sunny days)
mean_mid_sun <- mean(height[sun > 15 & sun < 25])
print(paste("Mean height (15 < sun < 25):", mean_mid_sun))


consensuses <- c("TGGCTATTTTCA", "CATTTACCAGTCGCTGCT", "GGCCCCGTCGAACTTAAA", 
                 "TGGCGCACCGGACAGTCCGGTGCACACCGGACAGTCCGGTG", "GTGTTTGGTT", "TCTCTTCAATGCCAT", 
                 "CGTCGCGCGACGAAGCGC", "CTCGGCCCGCTCC", "CACCGGACAGTCC", "CCGGACGGTCCGCG", 
                 "CGTTCGCGAGTGTCGC", "TCATCGTTACTATTCATCAT", "TGTGGGTACCTAA", 
                 "CGTGCTGTGTCGC", "TTATCTCATTAT", "GAGCCAACGGTCGG", "GGTCACTTAGACC", 
                 "CGGTCTATGTGACC", "CGTCGCGCGACGAAGCGC", "GTTATGCTATT", "GGTACAGGTTTGGG", 
                 "ACAAAAATCCAG", "ACAAAAATCCAG", "CGCGAACAACG", "ACCGGACAGTCCG", 
                 "TACACAGGGCTC", "GCGGAGGTCGT", "TACTCTGATTTT", "GGTCTAAGTGACC", 
                 "ATGGGTTTGGGCAA", "CTCAAGATGAGGA", "GGGGTCGGGCGAGG", "ATTTGCTTGCTAAG", 
                 "CTCGGGCGAGGCG", "GGTCTAAGTGACC", "CAAAGCAGCTAGCC", "GCCGAGGCCTCGGG", 
                 "GGCTCGTTAAGCT", "TTTTAAATACTA", "GGCTCGTTAAGCT", "TGCGAAGGCTGCC", 
                 "TTTTTAGCTCTT", "TTTTGTAAAACA", "CCATAACCGTACCC", "GAGGGTGCCTCGGGC", 
                 "CGCCTCGCCCGACCCC", "ATAATACTGCATA", "CGAGTCCGAGCCC", "CGGACCGTCCG", 
                 "CGGACCGTCCG", "CTCGCTCGAGGCC", "CGGACCGTCCG", "GATCAAGAGAAAGA", 
                 "AGATATAGAGGAT", "AGATAAGGGAGAAACCA", "ACCCGTATCCGA", "AAGGTCCAGTTCC", 
                 "TGGCGCACCGGACA", "CGGACAGTCCG", "CAACAAAGATGTC", "CCTTAGCAATTAA", 
                 "TTGGGGTCGAG", "GAGTCCGAGCCC", "GGTCTAAGTGACC", "TGTCGTGGCTGTCG", 
                 "CGGACCGTCCG", "ATATCCGAAATCTG", "GACTATTTGGAG", "GCACTCGGCAAAG", 
                 "GCACTCGGCAAAG", "GGGCGGCCGAGC", "GGGCGGCCGAGC", "GGGCGGCCGAGC", 
                 "TTGCTAAGGTT", "GGGCCTCGGGCGAG", "TCTCGTCTCGCCCGAG", "GGGCGGCCGAGC", 
                 "GGCCGGACGGTCC", "GGCCGGACGGTCC", "AACATTAAGTTATT", "GGCCGGACGGTCC", 
                 "AACATTAAGTTATT", "GCCGGACCGTCCG", "CTTTGCCGAGTGCC", "GCGGACCGTCCGG", 
                 "GGTGGCGGCGA", "GGGCTCGGACTC", "CAAGAAGATGA", "ATCTAGGGTTT", 
                 "GCTGAAGCCGAA", "ATCTAGGGTTT", "CGAGTCCGAGCCC", "CGAGTCCGAGCCC", 
                 "ATAGCTAATAGTTA", "GTTGGTTGCTAAA", "ATTTGCTTGCTAAG", "CAAATAAATCTT", 
                 "ATAAGACAAGAAC", "ACGACAAGAAG", "ATTTGCTTGCTAAG", "ATGCCAAATCTGG", 
                 "AGCTCGGCGCCAAG", "ACAGGGCTCAAGC", "GCACCCTCGGC", "CCGCGTCCTTC", 
                 "GCGGACCGTCCGG", "ACGACAAGAAG", "ACGACAAGAAG", "AATGATGAAGG", 
                 "CGCCTCGCCCGAG", "TTTGCCGAGTG", "TTTGTCGAGTGTC", "TTTGTCGAGTGTC", 
                 "GATTAAATAATC", "TCAATTGGTATCT", "TGCTCTCTATT", "GGTCTTAGTGACC", 
                 "CGGACGGTCCGGCC", "ACCAAACTGAA", "CTCAAGATGAGGA", "GGTCTTAGTGACC", 
                 "CGGACGGTCCGGCC", "CGTCGCGCGACGAAGCGC", "TTTAATTGCTAAG", "GCGGCATGCAACC", 
                 "CTTCTTGTAGT", "GGTCTAAGTGACC", "ACTGTCCGGTG", "GGTCACTTAGACC", 
                 "ACTGTCCGGTG", "CGGACTGTCCGC", "ATGAAACTAATGG", "ACTGTCCGGTG", 
                 "CTCAAGATGAGGA", "CGCGGACCGTCCG", "TCGGCCGCCCC", "CTTTGCCGAGTGCC", 
                 "CGGACCGTCCGC", "CTTTGCCGAGTGCC", "GCTCGGCCGCC", "ACATTAAAATTT", 
                 "GCTCAAAAGACT", "CTTCAGGAAAACT", "GCTCAAAAGACT", "CGGACCGTTCG", 
                 "CGGACCGTTCG", "GGGAGCTGCGAA", "GCGGACGGTCCG", "CCAACAGTCGCC", 
                 "GCTGATGCTGCCT", "AAATTCTCTCC", "CCGGACGGTCCGC", "AGTATGTTTTAG", 
                 "GTTGTGGCAATA", "CGGACGGTCCGCA", "ATGATGAATTTATA", "CTCCGCTTCGCCCGACCC", 
                 "CGGACCGTCCGCC", "CGGACCGTCCG", "TTTAATTGCTAAG", "TACCCGTATCCG", 
                 "AAAATGTCTAATAT", "CTCCGACGGCCACG", "CGGACGGTCCGC", "CTCCGACGGCCACGAC", 
                 "CGGACCATCCG", "GCCTCGGGCGAG", "GAGGTCGAGTCC", "GCAGGGGCGGC", 
                 "GCAGGGGCGGC", "GCGTGGGGCGGAGG", "CGGACAGTCCGCA", "TCCTCCTCTTGAG", 
                 "TGAGCAGCCAAT", "GCCCAGCCCGA", "CCCGGACGGTCC", "CCCAGCCGCCGGC", 
                 "CTCCGCTTCGCCCGACCC", "TCTCTATTATACAAGTAGCA", "GAAATTCGGTGT", 
                 "TTGCTAGCTAAGA", "GGTGAAGATGTTG", "TGGCGCACCGGACA", "TCGGGGCCGCGC", 
                 "TCGGGGCCGCGC", "GGACGGGCAGCCT", "CTCGGGCGAGGCG", "GAGCCGCCGGGG", 
                 "CCGGCCCGTTTAGCCCGCT", "TCTTATCTAA", "CGGACCGTCCGG", "TAGGAACGTCTTTTGA", 
                 "CTTCTTGTAGT", "GAGGCCGAGCCC", "GGCTCTTGTGGGT", "GAGGCCGAGCCC", 
                 "TTTGAAAATTT", "TGCCTAGGCGA", "CGAATACGGATA", "GGTCACTTAGACC")

# Search for elements with motifs:
grep("CATA", consensuses, value = T)
grep("TATA", consensuses, value = T)
grep("GATA", consensuses, value = T)
grep("ATATA", consensuses, value = T)







# Generating data
set.seed(42)
expr_matrix <- matrix(rpois(500, lambda = 10), nrow = 100, ncol = 5)
rownames(expr_matrix) <- paste0("Gene_", 1:100)
colnames(expr_matrix) <- c("Control_1", "Control_2", "Disease_1", "Disease_2", "Disease_3")

# 1. Calculating the mean for the control group 
control_mean <- rowMeans(expr_matrix[, 1:2])

# 2. Create normalized matrix 
normalized <- expr_matrix[, 3:5] / control_mean

# 3. Replace values less than 2 with 1 (filtration threshold)
normalized[normalized < 2] <- 1

# 4. Logarithm to base 2
normalized_log <- log2(normalized)

# 5. heatmap
my_colors <- colorRampPalette(c("dodgerblue", "white", "firebrick1"))(100)

heatmap(normalized_log, 
        scale = "none", 
        col = my_colors,
        main = "Normalized Expression (Log2)")

