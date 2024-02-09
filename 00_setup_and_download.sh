#!/usr/bin/env bash

source src/util_config.sh
source src/util_functions.sh

for directory in "${DIRECTORIES[@]}"; do
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
        echo "Created '$directory' directory."
    else
        echo "'$directory' directory already exists."
    fi
done

echo "Working directory setup completed."


# Declare an associative array to store file type and filename pairs
declare -A FILES
read_csv $FA_KEY FILES


# Download files
for file in "${!FILES[@]}"; do
    type="${FILES[${file}]}"
    if [ "$type" == "ref" ]; then
        download_file "$file" "$type" "$REF_DESTINATION_DIRECTORY"
    elif [ "$type" == "asm" ]; then
        download_file "$file" "$type" "$ASM_DESTINATION_DIRECTORY"
    else
        echo "Unknown file type: $type"
    fi
done