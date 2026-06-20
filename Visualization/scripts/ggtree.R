BiocManager::install("ggtree")
BiocManager::install("tidyverse")
BiocManager::install("ape")
library(ggtree)
library(tidyverse)
library(ape)
library(ggplot2)

setwd("//path/to/your/project") # set your working directoy
tree <- read.tree("Phylogeny/core_gene_alignment_filtered.aln.treefile")
tree <- root(tree, outgroup = "OUT", resolve.root = TRUE)
tree <- drop.tip(tree, "OUT")

meta <- read.csv("basic.csv")   # path to metadata file
setdiff(tree$tip.label, meta$Strain) # should return 0
rownames(meta) <- meta$Strain


tree$node.label <- ifelse(as.numeric(gsub(".*/", "", tree$node.label)) >= 90, 
                          gsub(".*/", "", tree$node.label), 
                          "") # to show boostrap support values

p <- ggtree(tree, layout = "rectangular") %<+% meta +
  geom_tiplab(aes(label = label, fill = Country),
              geom = "label",
              size = 1.25,
              color = "black",
              label.size = 0,
              align = TRUE,
              show.legend = TRUE) +
  geom_nodelab(aes(label = label),
               size = 1.8,
               hjust = 1.5,
               vjust = -0.3,
               color = "gray30") +
  scale_fill_manual(values = c(
    "Algeria" = "#ffb3ba",
    "China" = "#ffdfba",
    "Congo" = "#ffffba",
    "Germany" = "#baffc9",
    "Italy" = "#bae1ff",
    "Japan" = "#c9c9ff",
    "South Africa" = "#f1cbff",
    "South Korea" = "#b8d8be",
    "Spain" = "#caffef"
  )) + 
  guides(fill = guide_legend(override.aes = list(shape = 10, size = 4))) +
  theme(legend.position = "right",
        legend.key.size = unit(0.5, "cm"),
        legend.text = element_text(size = 8))

p

p1 <-  + theme(text = element_text(family = "serif"),
          legend.text = element_text(family = "serif"),
          axis.text = element_text(family = "serif"))

p1