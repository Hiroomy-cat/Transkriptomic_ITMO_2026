# part 1 the Basics of the "Boring part"
# Basic operations
# Attention - all comments must be in English - since all non-latin comments turns to mojibake.
# +  -  *  ^  /  %/%  %%

#basic usage - press Ctrl+Enter to run the line with the cursor.

#Basic variables

x <- 8
y <- 25
z <- x^2*y

plot(x,y)
plot(x,z)

q <- "A"
wh <- T
x > y
x < y
x != y
x == y

#functions
#don't forget about case-sensitiveness!
sqrt(16)
log(8) # Natural logarithm!
log(8, base = 2)
log(8,2)
log(8, sqrt(4))
'+'(3,5)


#vectors
chv <- c("Mitochondria", "Vacuole", "Nucleus") # c - is a shortcut to "combine"
chv[2] <- "Centriole" # indexing, also could be a vector
chv[-2]
chv[-c(1,3)] # indexing with minus removes elements.
chv[c(T,F,T)] # indexing by logical vector
named_vector <- c(first = 1, second = 2, third = 3) #indexing by another elements
named_vector
names(named_vector)
names(named_vector)[2] <- "fifth" #names is also a vector and could be edited!
named_vector

nv2 <- setNames(c("firebrick1", "dodgerblue", "springgreen"), c("mitochondria", "nucleus", "chloroplast"))#another way to set named vector
#very usable! since it is the way to assign colors to factor values in graphics.

sevv <- c(1, T, "sometext") # all vector elements are same type!!!
numv <- c(4,8,15)
numv <- c(4:28)
numv>13 # we will get logical vector!
numv[numv>13] # we can index by this logical vector.
rep(1:3, 3) # recycling rule!! (see below)
rep(1:4, 1:4)

numv <- as.character(numv)
numv <- as.numeric(numv)
numv[20] <- NA # NA stands for Not Available - the missing value
is.na(numv) # NA will interrupt your attempts to calculate smth
numv[is.na(numv)==F] # so here is how we remove it.
mean(numv)
mean(numv, na.rm = T)
summary(numv)
table(chv)
x <- seq(-10,  10, by =  0.1)
y <- x^2
plot(x, y, type = "l"
     # , ylim = c(0,10)
)

seq(1,29, length.out = 8)

n <- 1:4
m <- 4:1
n + m # operations between vectors of same length are made element-wise 
n + m[1:2] # recycling rule - if a vector is shorter - it is replicated several times (integer!) for element-wise operations
n + m[1:3] # ERROR.
n %*% m # scalar vectors multiplication - if needed.
n ^ m + m * (n - m)
#help call - just type ?function - and you'll find out. 

#t1.: calculate log of 89046 by base 7
#t2.: Create a vector from 1 to 20 and back to 1.
#t3.: Create a vector of 1 ,1, 2,2,2, 3,3,3,3 ....9,9,9,9,9,9,9,9,9,9 (ten nines)
#t4.: Plot y = x^3-28




#basic character functions


chv <- paste("All", "you", "need", "is", "love", sep = "^")
chv
chv <- gsub("\\^", " ", chv) #\\ - this is the "NOT EXECUTE" sign - to make R not understand the sign as regular expression
strsplit(chv, " ")
strsplit(chv, " ")[[1]] #because the result is a list
chv <- strsplit(chv, " ")[[1]][c(5,4,1,2,3)]

grep("o",chv) # index of vector element by partial search
grepl("o",chv) # -//- but output is logical

chv[chv=="ove"]

grep("ove",chv)

chv[grep("ove",chv)]


#regular expressions

big.vector <- unlist(strsplit(("Eukaryotic genomes often contain endogenous viral elements (EVEs) and mobile genetic elements (MGEs) which can together account for a substantial proportion of total genome length [163]. Such genomic parasites can move (“jump”) in or out of the host genome, with the distinctive feature that MGEs do not encode for structural proteins such as capsids which would allow them to propagate independently of their host [73, 128]. 
Polinton-like viruses (PLVs) are a prominent group of EVEs commonly identified in eukaryotic genomes, with the notable exception of mammals and land plants [6]. These 14–40 kb double-stranded DNA elements encode capsid proteins and are evolutionarily related to the Maverick–Polinton class of self-synthesizing transposons, defined by the presence of a protein-primed family B DNA polymerase (PolB), a retroviral-type integrase (rve-INT), and terminal inverted repeats (TIRs) [13, 67, 119]. PLVs often retain these hallmark features, including TIRs several hundred base pairs long, and are sometimes flanked by short 5–6 bp target site duplications (TSDs) which arise upon integration into the host genome [14, 42, 159]. 
Phylogenetic and structural analyses indicate that PLVs evolved from bacterial tectiviruses [77] and they are related to both virophages and eukaryote-infecting giant viruses of the nucleocytoplasmic large DNA virus (NCLDV) group, which virophages are known to parasitize [6, 7, 129]. Despite their divergence, PLVs and NCLDV both retain a conserved morphogenetic gene module, including single- and double-jelly-roll capsids, a capsid maturation protease, and a DNA packaging ATPase [7, 78]. These shared genes support their common origin and inclusion within the viral kingdom Bamfordvirae, [7, 74, 129]. Recent taxonomic proposals place most, if not all, PLVs within the class Polintoviricetes [129]. In this study, we use “PLVs” to refer to both accepted and prospective members of this class, including MCP-encoding polintons, while reserving the term “virophage” for members of Maveriviricetes, which encode distinct capsid proteins and depend upon co-infection with giant viruses for replication [129]. 
Recent experimental evidence suggests that PLVs, like virophages, may suppress giant virus proliferation thus acting as antiviral agents in protists [76, 128]. While the virophage lifestyle is reasonably well-characterized, thanks to several established protist—giant virus—virophage co-culture systems [44, 47, 56, 81, 136], only two PLVs have been experimentally characterized in culture to date: PgVV Gezel-14 T (19 kb) which parasitizes the nucleocytovirus PgV-14 T of haptophyte Phaeocystis globosa [128], and Tetraselmis virus N1 (TsV-N1; 31 kb) capable of inducing autonomous lytic infections in the marine chlorophyte Tetraselmis striata [111]. Additional PLVs have been isolated from protists, and some have even been reported active in animals. For instance, three PLVs—Curly, Larry, and Moe—were co-isolated with the giant mimivirus CpV-BQ2 during infection of freshwater haptophyte Chrysochromulina parva [149]. PLV-like elements have also been found in association with entomopoxviruses infecting lepidopteran insects, establishing the first known link between PLVs and poxviruses [9]. Recent studies identified endogenous PLVs in the genomes of stony corals (Cnidaria) [147] and in T. striata, providing direct evidence that TsV-N1 persists as both a free virus and integrated EVE [27]."), " "))


big.vector[grep("\\d", big.vector)] #elements containing numbers

big.vector[grep("\\D", big.vector)] #elements containing non-numbers (but not excluding numbers!)

big.vector[grep("[[:upper:]]", big.vector)] ##elements containing upper-case letters

big.vector[grep("[a-d]", big.vector)] #elements containing characters a,b,c or d.

big.vector[grep("s{2}", big.vector)] #elements containing "dd"


big.vector[grep("[IR]", big.vector)] #elements containing "I" or "R"

big.vector[grep("^[A]", big.vector)] #elements starts with A

big.vector[grep("s$", big.vector)] #elements ends with s


library(tidyverse)

big.vector[str_count(big.vector, "a")==2] #elements containing exactly two "a" in any form


# t1 find all elements with exactly 3 digits 

#matrices
A <- matrix(1:50, nrow=5) # A matrix is a 2D-vector

A
A <- matrix(1:50, ncol=5)
A
#matrix is created column-wise, until:
A <- matrix(1:50, byrow = T, ncol = 5)
A
#diagonal matrix
diag(1:20, nrow = 20)

length(A)
A[2,3] # indexing is [ROW,COLUMN]!
A[2] # it can be interpreted as 1D vector though
A[2,]
A[,2] # look at the difference. VERY COMMON MISTAKE - forget about ',' or put it wrong way!
A[2:4, 1:3] #submatrix
A[2:4, 2:4] <- 100
A

dim(A)
dim(A) <- c(50,1)
A
dim(A) <- c(1,50)
A
dim(A) <- 50
A
dim(A) <- c(5,10)
A
dim(A) <- c(10,5)
A

dimnames(A) <- list(c(paste0(rep("Row"), c(1:10))), paste0(rep("Column"), c(1:5)))

A
rbind(A, c(60,70,80,90,100))

cbind(A,c(60,70,80,90,100))

rbind(A,A)
cbind(A,A)
A>5
which(A>5)

#array is a multidimensional vector
array(c(1:24), dim = c(4, 3, 2))
array(c(1:48), dim = c(4,3,2,2))

#t1: Create a matrix M 100x100 of "1"s
#t2: Change all "1" that are "not edge" to 2s
#t3: Create matrix N - a multiplication table by: matrix(rep(1:9, rep(9,9))*(1:9), nrow = 9)
# and change all values that are less than 21 to 0.
B <- A^2+24
plot(A,B)
plot(density(cbind(A,B)))
#lists



l <- list(42, "Parrabola", T) # lists can contain any data
l
lbig <- list(c("Wow", "this", "list", "is", "so", "big"), "16", l) #even another lists
lbig
str(lbig) # structure of list(or other object)

namedl <- list(age = 24, PhDstudent = T, language = "Russian") #elements of list can be named
namedl
namedl$age #indexing by name
namedl[1] # returns LIST!
namedl[[1]] # indexing by number, returns vector!
lbig[[3]][[2]] # indexing of list-in-list


paste(namedl) #gives just a vector

test <- mapply(namedl, FUN = paste)
test # named list became named vector

#how to put vector or list elemnts in one element?
paste0(test, collapse = " ")

#make vector from list
unlist(lbig)

#dataframe

name <- c("Ivan", "Eugeny", "Lena", "Misha", "Sasha") 
age <- c(26, 34, 23, 27, 26) 
student <- c(F, F, T, T, T) 
df <- data.frame(name, age, student)  
df

str(df)

df$age[2:3]
df$alive <- T # adding new column
df

df[3:5, 2:3] # subdataframe

df[df$age < mean(df$age),4] # are alive ones younger than the middle age of the sample?
sum(df[df$age < mean(df$age), 4]) # in R TRUE can be interpreted as 1. So "sum" outputs a number of TRUEs.
df[df$age < mean(df$age), 'alive'] # works too.
df$alive[df$age < mean(df$age)] # another variant (and the better one! You won't forget about ',') and no need 
# to remember numbers of names of columns - just type df$ , press 'Tab' and select what you need.

#the tidyverse package makes dataframe operations more convenient

library(tidyverse)
df2 <- tibble(name, age, student)
df2



df %>% filter(age < mean(age)) %>% pull(alive)

df <- df[order(df$age),]
df[order(df$name, decreasing = T),]

nrow(df)
ncol(df)

dim(df)

df$age <- df$age*3

ifelse(df$age <100, "YEAH", "NOPE")

df %>% mutate(age = 3*age) %>%  mutate(alive = ifelse(age > 230, F, T )) 
#remember - pipes do not write the operations!!!

df2 <- df %>% mutate(age = 3*age) %>%  mutate(alive = ifelse(age > 80, F, T )) 
df2

#t1 some Transcription Factor expression data from my PhD thesis. execute:

tf <- readRDS("TF.rds")
summary(tf)
str(tf)

# remove all rows where expression values in both Sample1 and Sample2 are 0 (operator &)
# Calculate:
# - Number of significant genes (significant is when adj.P.val < 0.05)
# - Plot density of NON-ZERO genes expression levels of Sample1 and Sample2 (the function is plot(density(x)))
