#!/usr/bin/env bash

## ----
# Function to download a file based on its type
# @param $1 file path
# @param $2 file type
# @param $3 destination path
#
# @return null
download_file() {
    local file="$1"
    local type="$2"
    local destination_directory="$3"

    rsync -avzh --progress "$SRC_SRV/$file" "$destination_directory"

    log "  Downloaded '$file' ($type) to '$destination_directory'"
}


## ----
# Function to read CSV file and populate associative array
#
# @param $1 a CSV file containing server file path and file type
# @param $2 an empty associative array object
#
# @return associative array linking file path and type
read_csv() {
    local file="$1"
    local -n files_array="$2"  # Reference to associative array

    while IFS=',' read -r filename type; do
        files_array["$filename"]="$type"
    done < "$file"
}


## ----
# Simple logging mechanism
#
# @return string
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] - $*" >> "$INIT_LOG"
}


## ----
# Function to create the annotation keyfile
#
# @param $1 FASTA directory
# @param $2 output path
#
# @return A two-column tab-delimited keyfile
create_annotation_keyfile() {
    # Check if all required arguments are provided
    if [ $# -ne 2 ]; then
        echo "Usage: create_annotation_keyfile <asm_directory> <ref_directory> <output_path> <output_file>"
        return 1
    fi

    local fa_dir="$1"
    local output_path="$2"

    # Function to extract file name without extension
    extract_filename() {
        local filename=$(basename "$1")
        local filename_no_ext="${filename%.*}"
        echo "$filename_no_ext"
    }

    # Process files in asm directory
    for file in "$fa_dir"/*; do
        if [ -f "$file" ]; then
            echo -e "$file\t$(extract_filename "$file")" >> "$output_path"
        fi
    done
}


## ----
# Function to convert .fna to .fa
#
# @param $1 path to directory containing FASTA data
#
# @return null
convert_fna_to_fa() {
    local dir="$1"

    # Check if the directory exists
    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist."
        return 1
    fi

    # Iterate over files in the directory
    for file in "$dir"/*.fna; do
        if [ -f "$file" ]; then
            # Rename .fna to .fa
            mv "$file" "${file%.fna}.fa"
            log "  Converted $file to ${file%.fna}.fa"
        fi
    done
}


## ----
# Function to record memory usage
#
# @param $1 time interval (in seconds)
# @param $2 output file path
# @param $3 delimiter character (defaults to ',')
#
# @return a delimited file detailing memory usage for n time intervals
record_memory_usage() {
    local interval="$1"
    local output_file="$2"
    local delimiter="${3:-,}"  # Set default delimiter to comma
    
    # Formatting variables
    local bold="\e[1m"
    local green="\e[32m"
    local blue="\e[34m"
    local reset="\e[0m"

    # Add header to CSV file
    echo -e "time_stamp${delimiter}total_mb${delimiter}used_mb${delimiter}free_mb" > "$output_file"
    
    # Print recording messages for user
    echo -e "Recording memory usage every ${bold}${green}${interval}${reset} second(s)..."
    echo -e "(Press ${bold}${blue}Ctrl+C${reset} to stop recording)"  # Prompt to stop recording

    # Main loop
    while true; do
        # Get memory usage using the free command and parse using awk
        memory_info=$(free | awk \
            -v timestamp="$(date +'%Y-%m-%d %H:%M:%S')" \
            -v delimiter="$delimiter" \
            'NR==2 {
                total=$2/1024
                used=$3/1024
                free=$4/1024
                printf "%s%s%d%s%d%s%d\n",
                    timestamp, delimiter,
                    total,     delimiter,
                    used,      delimiter,
                    free
            }')

        # Append memory usage information to the output file
        echo "$memory_info" >> "$output_file"

        # Sleep for the specified interval
        sleep "$interval"
    done
}

