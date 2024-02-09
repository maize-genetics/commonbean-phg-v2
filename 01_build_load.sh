#!/usr/bin/env bash

module load java/21.0.1

source src/util_config.sh
source src/util_functions.sh


# Annotate FASTA files
for fa_type in "asm" "ref"; do
    curr_key_file="data/annotation_keyfile_$fa_type.txt"

    create_annotation_keyfile "data/$fa_type" $curr_key_file

    "$PHG_SRC" annotate-fastas \
        --keyfile $curr_key_file \
        --threads $N_THREADS \
        --output-dir data/${fa_type}_anno
done


# Create ref range BED file
# NOTE: Currently getting error regarding Illegal characters for 2 bit sequencing
"$PHG_SRC" create-ranges \
    --gff $DEST_REF_GFF_DIR/$REF_GFF_ID \
    --reference-file $DEST_REF_DIR/$REF_FA_ID \
    --boundary gene \
    --pad 500 \
    --output $DEST_REF_GFF_DIR

