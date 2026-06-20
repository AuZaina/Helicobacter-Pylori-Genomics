for f in *.fna; do
	sample=$(basename "$f" .fna)

 	abricate --db vfdb "$f" > vfdb/${sample}_vfdb.tsv
done
