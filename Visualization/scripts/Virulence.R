
library(pheatmap)
library(ggtree)
library(ape)
library(ggtreeExtra)
library(ggplot2)

setwd("//path/to/your/project") # set your working directoy
tree <- read.tree("Phylogeny/core_gene_alignment_filtered.aln.treefile") 
tree <- drop.tip(tree, "OUT") 

meta <- read.csv("Virulence.csv") 

rownames(meta) <- meta$Strain
all(tree$tip.label %in% rownames(meta)) # should return TRUE



p <- ggtree(tree, branch.length = "none") %<+% meta # attaching metadata to tree

p1 <- p +  geom_tippoint(aes(color = Region),size = 3) +
 scale_color_manual(values = c(
  "East Asia" ="#CDE2FF",
  "Europe" =   "#A6A1BE",
  "Africa" =   "#A7CFA8"
))
p1


# Converting to factors
meta_new <- meta[,c("CagPAI", "CagA", "VacA", "BabA", "SabA", "OipA")]
meta_new[] <- lapply(meta_new, function(x) {
  factor(x,
           levels = c(0,1,2),
           labels = c("Absent", "Present", "Partial"))
})
                                
heat_colours <- c(
  "Absent" =  "#98c6cc",
  "Present" = "#d692b3",
  "Partial" = "#e9bcbc"
)


p2 <- gheatmap(
  p1,
  meta_new,
  offset = 0.5,
  width = 1,
  colnames_angle = 0,
  colnames_position = "top",
  font.size = 3,
  family = "serif")


p3 <- p2 + scale_fill_manual(values = heat_colours, name = "Gene Status") +
geom_tiplab(size=2, offset = 26.5) + 
theme(text = element_text(family = "serif", size = 8))

p3
