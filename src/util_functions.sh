#!/usr/bin/env bash

# Function to download a file based on its type
download_file() {
    local file="$1"
    local type="$2"
    local destination_directory="$3"

    rsync -avzh --progress "$SOURCE_SERVER/$file" "$destination_directory"

    echo "Downloaded '$file' ($type) to '$destination_directory'"
}


# Function to read CSV file and populate associative array
read_csv() {
    local file="$1"
    local -n files_array="$2"  # Reference to associative array

    while IFS=',' read -r filename type; do
        files_array["$filename"]="$type"
    done < "$file"
}