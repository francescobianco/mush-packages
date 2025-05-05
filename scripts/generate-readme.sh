#!/bin/bash

INPUT_FILE=".packages"
OUTPUT_FILE="README.md"

echo "# Mush Package Collection" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This repository contains a curated collection of Mush packages organized by category.  " >> "$OUTPUT_FILE"
echo "Each package is defined with a name and a source repository. Some packages are located in subdirectories and marked with \`*\`." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

current_section=""

while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

    # Skip empty lines
    [[ -z "$line" ]] && continue

    # If line is a comment and looks like a section
    if [[ "$line" =~ ^##[^#] ]]; then
        section="${line#\#\# }"
        echo "## $section" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        continue
    fi

    # If line starts with 'package'
    if [[ "$line" =~ ^package ]]; then
        # Remove 'package ' prefix
        line_body="${line#package }"

        # Extract parts
        pkg_name=$(echo "$line_body" | awk '{print $1}')
        pkg_url=$(echo "$line_body" | awk '{print $2}')
        pkg_path=$(echo "$line_body" | awk '{print $3}')
        pkg_star=$(echo "$line_body" | grep -o '\*')

        # Extract inline comment (if present)
        comment=""
        if [[ "$line" == *"#"* ]]; then
            comment="${line#*# }"
        fi

        # Format description
        echo "- **$pkg_name**" >> "$OUTPUT_FILE"
        if [[ -n "$comment" ]]; then
            echo "  – $comment" >> "$OUTPUT_FILE"
        fi
        echo "  [$pkg_url]($pkg_url)" >> "$OUTPUT_FILE"
        if [[ -n "$pkg_path" ]]; then
            echo "  _(Subdirectory: \`$pkg_path\`)_" >> "$OUTPUT_FILE"
        fi
        echo "" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"
