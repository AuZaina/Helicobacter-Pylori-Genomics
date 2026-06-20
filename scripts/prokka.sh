#!/bin/bash
# Genome annotation using Prokka


for fna in ~/Hpylori-genomics/Genomes/*.fna; do
    sample=$(basename "$fna" .fna)
    prokka \
        --outdir  ~/Hpylori-genomics/Annotation/"$sample" \
        --prefix "$sample" \
        --locustag "$sample" \
        --genus Helicobacter \
        --species pylori \
        --kingdom Bacteria \
        --gcode 11 \
        --cpus 4 \
        "$fna"
done
