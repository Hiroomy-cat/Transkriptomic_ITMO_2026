#lecture 2

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
unlist(namedl)

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
df[4]

df[3,]
df[,3]

df[df$age < mean(df$age),4] # are alive ones younger than the middle age of the sample?
sum(df[df$age < mean(df$age), 4]) # in R TRUE can be interpreted as 1. So "sum" outputs a number of TRUEs.
df[df$age < mean(df$age), 'alive'] # works too.
df$alive[df$age < mean(df$age)] # another variant (and the better one! You won't forget about ',') and no need 
# to remember numbers of names of columns - just type df$ , press 'Tab' and select what you need.

#the tidyverse package makes dataframe operations more convenient

library(tidyverse)
df2 <- tibble(name, age, student)
df2

data(mtcars)
mtcars
as_tibble(mtcars)

df %>% filter(age < mean(age)) %>% pull(alive)
#same as pull(filter(df, age<mean(age)),alive)

df[order(df$age),]
df[order(df$name, decreasing = T),]

nrow(df)
ncol(df)

dim(df)

df %>% mutate(age = 9*age) %>%  mutate(alive = ifelse(age > 230, F, T )) 
#remember - pipes do not write the operations!!!

df2 <- df %>% mutate(age = 9*age) %>%  mutate(alive = ifelse(age > 230, F, T )) 
df2

#t1 some Transcription Factor expression data from my PhD thesis. execute:

tf <- readRDS("TF.rds")
summary(tf)
str(tf)

# remove all rows where expression values in both Sample1 and Sample2 are 0 (operator &)
# Calculate:
# - Number of significant genes (significant is when adj.P.val < 0.05)
# - Plot density of NON-ZERO genes expression levels of Sample1 and Sample2 (the function is plot(density(x)))

#presentation here!

#PCR equation.
#the formula for PCR results is -ddCt (LogFoldChange)

library(tidyverse)
pcrdata <- readRDS("pcrdata.rds")

d1 <- pcrdata[[1]]
d1 <- d1[,-2]

act1 <- d1 %>% filter(target == "ACT-1")

goi1 <- d1 %>% filter(target != "ACT-1")

dc1 <- left_join(act1, goi1, by = c("treesource", "treatment", "tree", "source")) %>% mutate(dCt = ct.y - ct.x)

toplot1 <- dc1
toplot1$Expression <- 2^(-1*toplot1$dCt)

#the GGPLOT

ggplot(toplot1)+
  geom_col(aes(x = target.y, y = Expression, fill = tree), position = "dodge")


ggplot(toplot1)+
  geom_col(aes(x = target.y, y = Expression, fill = tree), position = "dodge")+
  facet_wrap(~treatment)



ggplot(toplot1)+
  geom_col(aes(x = target.y, y = Expression, fill = treatment), position = "dodge")+
  facet_wrap(~tree)

ggplot(toplot1)+
  geom_col(aes(x = target.y, y = Expression, fill = treatment), position = "dodge")+
  facet_wrap(~treatment + tree, scales = "free_y")

#not beautiful enough, right?
#customization:

ggplot(toplot1)+
  geom_col(aes(x = target.y, y = Expression, fill = treatment), position = "dodge")+
  theme_light()+
  facet_wrap(~treatment + tree, scales = "free_y")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, face = "italic", size = 12),
        strip.background = element_rect(color = "grey", fill = "white"),
        strip.text = element_text(family = "sans", face = "bold", colour = "black", size = 12))

toplot1 <- toplot1 %>% mutate(treatment = paste(treatment, "PEG"),
                              tree = paste("tree", tree),
                              treatment = gsub("Con PEG", "Control", treatment))

ggplot(toplot1)+
  geom_col(aes(x = target.y, y = Expression, fill = treatment), position = "dodge")+
  theme_light()+
  facet_wrap(~treatment + tree, scales = "free_y")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, face = "italic", size = 12),
        strip.background = element_rect(color = "grey", fill = "white"),
        strip.text = element_text(family = "sans", face = "bold", colour = "black", size = 12))

ggplot(toplot1)+
  geom_boxplot(aes(x = target.y, y = -dCt, fill = treatment), position = "dodge")+
  theme_light()+
  facet_wrap(~treatment + tree, scales = "free_y")+ylab("LogFoldChange relative to ACT-1")+
  xlab("Gene")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, face = "italic", size = 12),
        strip.background = element_rect(color = "grey", fill = "white"),
        strip.text = element_text(family = "sans", face = "bold", colour = "black", size = 12),
        axis.title = element_text(size = 12, face = "bold"))

#enough for conference)

con1 <- dc1 %>% filter(treatment == "Con")

tr1 <- dc1 %>% filter(treatment != "Con")

ddct1 <- left_join(con1, tr1, by = c("treesource", "tree", "source", "target.y")) %>% mutate(ddCt = dCt.y - dCt.x, LFC = -ddCt, replicate = 1)

toplot <- ddct1 %>% filter(tree ==2, source == "Br")

ggplot(toplot)+
  geom_tile(aes(x = treatment.y, y = target.y, fill = LFC))

ggplot(toplot)+
  geom_tile(aes(x = treatment.y, y = target.y, fill = LFC))+
  scale_fill_gradientn("LogFoldChange", colors = c("firebrick1", "black", "dodgerblue"))

#this was only for tree2!

#task: plot heatmap for all the trees data (use faceting). 
#Find what exact value ruins the graph. Get rid of that value, you already know how)
#redraw the graph

