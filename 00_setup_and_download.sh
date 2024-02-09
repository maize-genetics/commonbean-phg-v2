#!/usr/bin/env bash

source src/util_config.sh
source src/util_functions.sh

for directory in "${DIRS[@]}"; do
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
        echo "Created '$directory' directory."
    else
        echo "'$directory' directory already exists."
    fi
done

echo "Working directory setup completed."


# Declare an associative array to store file type and filename pairs
declare -A FA_DATA
read_csv $FA_KEY FA_DATA


# Download files
for file in "${!FA_DATA[@]}"; do
    type="${FA_DATA[${file}]}"
    if [ "$type" == "ref" ]; then
        download_file "$file" "$type" "$DEST_REF_DIR"
    elif [ "$type" == "asm" ]; then
        download_file "$file" "$type" "$DEST_ASM_DIR"
    elif [ "$type" == "ref_gff" ]; then
        download_file "$file" "$type" "$DEST_REF_GFF_DIR"
    else
        echo "Unknown file type: $type"
    fi
done