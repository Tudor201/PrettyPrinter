#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <file.html>" >&2
  exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
  echo "Error: file not found: $file" >&2
  exit 2
fi

cat "$file"
