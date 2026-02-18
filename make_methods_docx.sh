#!/usr/bin/env bash
set -euo pipefail

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is not installed or not in PATH." >&2
  exit 1
fi

found_any=false

while IFS= read -r -d '' md_file; do
  found_any=true
  docx_file="${md_file%.md}.docx"
  echo "Converting: $md_file -> $docx_file"
  pandoc "$md_file" -o "$docx_file"
done < <(find . -mindepth 2 -maxdepth 2 -type f -name '*methods*.md' -print0)

if [ "$found_any" = false ]; then
  echo "No matching files found at ./<child-folder>/*methods*.md"
fi
