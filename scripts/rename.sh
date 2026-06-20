while IFS=$'\t' read -r accession newname; do
    match=$(ls Genomes/ | grep "^${accession}")
    if [ -n "$match" ]; then
        mv "Genomes/$match" "Genomes/${newname}.fna"
        echo "Renamed: $match → ${newname}.fna"
    else
        echo "WARNING: No match found for $accession"
    fi
done < Genomes/rename.txt
