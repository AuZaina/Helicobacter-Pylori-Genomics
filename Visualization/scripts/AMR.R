library(pheatmap)
library(ggtree)
library(ggplot2)
library(ape)

meta <- read.csv("amr_final.csv")
colnames(meta)
colnames(meta)[colnames(meta) == "X23SrRNA"] <- "23S_rRNA"
rownames(meta) <- meta$Sample_id

tree <- read.tree("Phylogeny/core_gene_alignment_filtered.aln.treefile")
tree <- drop.tip(tree, "OUT")

p <- ggtree(tree, branch.length = "none") %<+% meta

p1 <- p + geom_tippoint(aes(color = Regions), size = 3) +
  scale_color_manual(values = c(
    "East Asia" = "#CDE2FF",
    "Europe" = "#A6A1BE",
    "Africa" = "#A7CFA8"
  ))

p1

# converting to factors
amr_meta <- meta[,c("gyrA", "rdxA", "frxA","pbp1a", "pbp3", "23S_rRNA")]
amr_meta[] <- lapply(amr_meta, function(x) {
  factor(x,
         levels=c(0,1),
         labels = c("Absent", "Present"))})

heat_colors <- c(
  "Absent" =  "#98c6cc",
  "Present" = "#d692b3")

p2 <- gheatmap(
  p1,
  amr_meta,
  offset = 0.5,
  width = 1,
  colnames_angle = 0,
  colnames_position = "top",
  font.size = 4,
  family = "serif")

p3 <- p2 + scale_fill_manual(values = heat_colors, name = "Mutation") + 
  geom_tiplab(size=2, offset = 26.5) +
theme(text = element_text(family = "serif", size = 8))

p3


