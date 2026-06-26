# Helicobacter pylori Comparative Genomics

 ## Overview
This project performs comparative genomics analysis of 63 *Helicobacter pylori* strains — 7 strains per country across 9 countries representing 3 geographic regions (Africa, East Asia, and Europe) — with *H. acinonychis* as an outgroup.

**Regions and countries:**
- Africa: Algeria, Congo, South Africa
- East Asia: China, Japan, South Korea
- Europe: Germany, Italy, Spain

**Pipeline summary:**
- Genome annotation: Prokka
- Pangenome analysis: Panaroo
- Phylogenetic reconstruction: IQ-TREE
- AMR detection: AMRFinderPlus + RGI/CARD
- Virulence factor detection: ABRicate/VFDB
- Visualization: R (ggtree, gheatmap)

## 1. Genome Download & Quality Control

Genomes were downloaded from NCBI GenBank using the accession list: [accession.txt](Genome/accession.txt)

```bash
datasets download genome accession --inputfile accession.txt --include genome --filename accession.txt
```

Strains were renamed according to [rename.txt](Genome/rename.txt):


Quality check was performed using SeqKit:

```bash
seqkit stat -a -T *.fna > seq_qc_genomes.txt
```

## 2. Genome Annotation

All genomes were annotated using Prokka:

```bash
for fna in Genome/*.fna; do
    sample=$(basename "$fna" .fna)
    prokka \
        --outdir Annotation/"$sample" \
        --prefix "$sample" \
        --locustag "$sample" \
        --genus Helicobacter \
        --species pylori \
        --kingdom Bacteria \
        --gcode 11 \
        --cpus 4 \
        "$fna"
done
```

Results: [Annotation/](Annotation/)

## 3. Pangenome Analysis

Pangenome was constructed using Panaroo in strict mode:

```bash
panaroo -i Annotation/*/*.gff \
    -o Pangenome/ \
    --clean-mode strict \
    -a core \
    --aligner mafft \
    --core_threshold 0.95 \
    -t 6
```

Results: [Pangenome/](Pangenome/)

## 4. Phylogenetic Analysis

Maximum likelihood phylogenetic tree was constructed using IQ-TREE2:

```bash
iqtree -s Pangenome/core_gene_alignment_filtered.aln \
    -m MFP \
    -B 1000 \
    -bnni \
    -alrt 1000 \
    -T AUTO
```

Tree was rooted using *H. acinonychis* as outgroup. Results: [Phylogeny/](Phylogeny/)

## 5. AMR Analysis

### AMRFinderPlus
Point mutations and AMR genes detected using AMRFinderPlus:

```bash
for f in faa/*.faa; do
  strain=$(basename "$f" .faa)
  amrfinder \
    -n fna/${strain}.fna \
    -p faa/${strain}.faa \
    -g gff/${strain}.gff \
    -O Helicobacter_pylori \
    --plus \
    --threads 4 \
    -o ${strain}_amr.tsv
done
```

### RGI/CARD
Resistant gene mutation identified using RGI with CARD database:

```bash
for f in *.fna; do
    name=$(basename $f .fna)
    rgi main \
        --input_sequence $f \
        --output_file result/${name}_rgi \
        --local \
        --clean \
        -a DIAMOND
done
```

Results: [Amr/](Amr/)

## 6. Virulence Factor Analysis

Virulence factors detected using ABRicate with VFDB:

```bash
for f in *.fna; do
    sample=$(basename "$f" .fna)
    abricate --db vfdb "$f" > vfdb/${sample}_vfdb.tsv
done
```

Results: [Virulence/](Virulence/)

## 7. Visualization

Phylogenetic tree and heatmaps were generated in R using ggtree and gheatmap.

R scripts: [Visualization/scripts/](Visualization/scripts/)

### Figures

![Phylogenetic Tree](Visualization/figures/iqtree.png)
*Maximum likelihood phylogenetic tree of H. pylori strains rooted with H. acinonychis, tip labels colored by country.*

![AMR Heatmap](Visualization/figures/AMR.png)
*Distribution of AMR genes and point mutations across strains mapped onto phylogeny.*

![Virulence Heatmap](Visualization/figures/Virulence.png)
*Distribution of virulence factors across strains mapped onto phylogeny.*

## Tools & Versions
| Tool | Version |
|------|---------|
| NCBI Datasets CLI | 18.30.1 |
| SeqKit | 2.3.0 |
| Prokka | 1.12 |
| Panaroo | 1.7.0 |
| IQ-TREE | 3.1.2 |
| AMRFinderPlus | 4.2.7 |
| RGI | 6.0.8 |
| CARD database | 4.0.1 |
| ABRicate | 1.4.0 |
| R | 4.5.2 |
| ggtree | 4.0.5 |
| ggplot2 | 4.0.3 |
| ape | 5.8.1 |



