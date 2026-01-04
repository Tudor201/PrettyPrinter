#!/usr/bin/env bash

set -euo pipefail

INDENT_SPACES=4

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <file.html>" >&2
  exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
  echo "Error: file not found: $file" >&2
  exit 2
fi

content="$(cat "$file")"

content="${content//$'\r'/}"

indent=0

print_indent(){
    printf "%*s" $((indent * INDENT_SPACES)) ""
}

while [[ -n "$content" ]]; do
    if [[ "$content" == \<* ]]; then
      tag="${content%%>*}>"
      content="${content#"$tag"}"

      tag_trimmed="$(echo "$tag" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

      if [[ "$tag_trimmed" == \</* ]]; then
        ((indent--))
        ((indent < 0)) && indent=0
        print_indent
        echo "$tag_trimmed"
        continue
      fi

      print_indent
      echo "$tag_trimmed"
      ((++indent))
      continue
    fi 

    if [[ "$content" == *\<* ]]; then
      text="${content%%<*}"
      content="${content#"$text"}"
    else
      text="$content"
      content=""
    fi

    text="$(echo "$text" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    if [[ -n "$text" ]]; then
      print_indent
      echo "$text"
    fi
done