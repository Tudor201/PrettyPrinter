#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

input_file="$1"

while IFS= read -r line || [ -n "$line" ]; do
    trimmed_line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')

    if [[ "$trimmed_line" =~ ^\<\!DOCTYPE ]]; then
        echo "$trimmed_line"
        continue
    fi

    if [[ "$trimmed_line" =~ ^\<\!-- ]]; then
        echo "$trimmed_line"
        continue
    fi

    echo "$trimmed_line"
done < "$input_file"
