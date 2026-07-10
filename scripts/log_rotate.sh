#!/bin/bash
set -euo pipefail

source_dir=${1:-}
destination_dir=${2:-}

if [[ -z "$source_dir" || -z "$destination_dir" ]]; then
    echo "Usage: $0 <source_dir> <destination_dir>"
    exit 1
fi

if [[ ! -d "$source_dir" ]]; then
    echo "Error: Source directory does not exist"
    exit 1
fi

mkdir -p "$destination_dir"

# Compress logs older than 7 days
compressed_count=0
for file in $(find "$source_dir" -type f -name "*.log" -mtime +7); do
    gzip "$file"
    mv "${file}.gz" "$destination_dir/"
    ((compressed_count++))
done

echo "Compressed and moved files: $compressed_count"


# Delete gz files older than 30 days
deleted_count=$(find "$destination_dir" -type f -name "*.gz" -mtime +30 -print -delete | wc -l)
echo "Deleted files: $deleted_count"
