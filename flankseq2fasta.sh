#!/bin/bash
#Write by Rakakpo/Ifremer 2025-11-20 - La Tremblade - France
#This script allow converting flaking sequence from axiom annotation file
#into a fasta file for mapping to get SNP acconding to a reference genome


INPUT="myfile.csv"
OUTPUT="Myfile.fa"

rm -f "$OUTPUT"

# Skip first 19 lines (metadata + header)
tail -n +20 "$INPUT" | while IFS=';' read -r -a cols
do
    ProbeSetID="${cols[0]}"
    Flank="${cols[5]}"      # column 6 in the CSV

    # Replace [A/G] with A (first allele)
    SEQ=$(echo "$Flank" | sed -E 's/\[([A-Z])\/[A-Z]\]/\1/')

    echo ">${ProbeSetID// /_}" >> "$OUTPUT"
    echo "$SEQ" >> "$OUTPUT"
done

echo "FASTA file created: $OUTPUT"

