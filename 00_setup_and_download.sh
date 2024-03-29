#!/usr/bin/env bash

module load java/21.0.1

source src/util_config.sh
source src/util_functions.sh


# Set up directory structure
log "Initializing directories"
for directory in "${DIRS[@]}"; do
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
        log "  Created '$directory' directory."
    else
        log "  '$directory' directory already exists."
    fi
done

log "Working directory setup completed"


# Declare an associative array to store file type and filename pairs
declare -A FA_DATA
read_csv $FA_KEY FA_DATA


# Download FASTA data
log "Downloading FASTA data"
for file in "${!FA_DATA[@]}"; do
    type="${FA_DATA[${file}]}"
    if [ "$type" == "ref" ]; then
        download_file "$file" "$type" "$DEST_REF_DIR"
    elif [ "$type" == "asm" ]; then
        download_file "$file" "$type" "$DEST_ASM_DIR"
    elif [ "$type" == "ref_gff" ]; then
        download_file "$file" "$type" "$DEST_REF_GFF_DIR"
    else
        echo "  Unknown file type: $type"
    fi
done

log "FASTA data downloaded"


# Convert .fna to .fa (if they exist - needed for current version of BioKotlin)
log "Checking for .fna extensions"
convert_fna_to_fa $DEST_REF_DIR
convert_fna_to_fa $DEST_ASM_DIR


# Download PHGv2
log "Begin PHGv2 download"
curl -s https://api.github.com/repos/maize-genetics/phg_v2/releases/latest \
    | awk -F': ' '/browser_download_url/ && /\.tar/ {
        gsub(/"/, "", $(NF));
        system("curl -LO " $(NF));
        system("tar -xvf *.tar -C src/");
        system("rm *.tar");
    }'

log "PHGv2 downloaded and decompressed"


# Setup PHGv2 environment
log "START  - Setting up PHGv2 environment"
"$PHG_SRC" setup-environment --env-file data/phg_environment.yml
mv *.log output/logging/
log "FINISH - Setting up PHGv2 environment"


# Initialize TileDB instances
log "START  - Initializing TileDB instances"
"$PHG_SRC" initdb \
    --db-path $PHG_DB_DIR \
    --gvcf-anchor-gap 1000000 \
    --hvcf-anchor-gap 1000
log "FINISH - Initializing TileDB instances"