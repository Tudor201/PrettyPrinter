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

is_void_tag() {
  case "$1" in
    area|base|br|col|embed|hr|img|input|link|meta|param|source|track|wbr) return 0 ;;
    *) return 1 ;;
  esac
}

is_decl_or_comment() {
  case "$1" in
    '<!'*| '<?'* ) return 0 ;;  
    *) return 1 ;;
  esac
}

extract_tag_name() {
  local t="$1"
  TAG_NAME=""

  t="${t#<}"
  t="${t#/}"
  t="${t%% *}"
  t="${t%%>*}"
  t="$(echo "$t" | tr '[:upper:]' '[:lower:]')"

  if [[ "$t" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    TAG_NAME="$t"
  fi
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

    if is_decl_or_comment "$tag_trimmed"; then
      continue
    fi

    if [[ "$tag_trimmed" == */\> ]]; then
      continue
    fi

    extract_tag_name "$tag_trimmed"
    if [[ -n "${TAG_NAME:-}" ]] && is_void_tag "$TAG_NAME"; then
      continue
    fi

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
