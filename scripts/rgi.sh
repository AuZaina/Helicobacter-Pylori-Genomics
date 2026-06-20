
for f in *.fna; do
    name=$(basename $f .fna)
    rgi main \
        --input_sequence $f \
        --output_file result/${name}_rgi \
        --local \
        --clean \
        -a DIAMOND
done
