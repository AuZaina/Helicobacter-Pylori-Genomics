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
