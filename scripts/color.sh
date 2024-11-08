#!/bin/bash
#this script is used to recolor all .svg files in a folder (and subfolders) to white
#intended to be used on lineart icon packs like Candy Icons to make them more minimalistic

# Find all .svg files recursively in the current directory and its subdirectories
find . -type f -name "*.svg" | while read file; do
    if [[ -f "$file" ]]; then
        # Replace fill and stroke attributes with "white"
        xmlstarlet ed -u "//@fill" -v "white" -u "//@stroke" -v "white" "$file"

        # Replace :rgb(...) with :rgb(255,255,255)
        sed -i 's/:rgb([^)]*)/:rgb(255,255,255)/g' "$file"

        # Replace hex color codes (e.g., #25ff21) with #ffffff
        sed -i 's/#[0-9a-fA-F]\{3,6\}/#ffffff/g' "$file"
    fi
done

echo "Processing completed."
