#!/usr/bin/env bash
# creates an image with a random subset of the images in the folder
# used for generating inglenook puzzle variations
# imagemagick required

set -euo pipefail

# ----------------------
	# Configurable parameters
# ----------------------
INPUT_DIR="${1:-.}"      # First argument, default current folder
COUNT="${2:-5}"           # Number of images to pick
OUTPUT="${3:-output.png}" # Output filename
HEIGHT="${4:-200}"        # Set to 0 to keep original size
# ----------------------

# Check ImageMagick
if ! command -v magick &>/dev/null; then
    echo "Error: ImageMagick (magick) not found."
    exit 1
fi

# Remove existing output
[[ -f "$OUTPUT" ]] && rm -f "$OUTPUT"

# Find PNG files
mapfile -t FILES < <(find "$INPUT_DIR" -maxdepth 1 -type f -iname '*.png')
TOTAL_FILES=${#FILES[@]}

if (( TOTAL_FILES < COUNT )); then
    echo "Error: Not enough PNG files in '$INPUT_DIR' (need $COUNT)"
    exit 1
fi

# Pick $COUNT random files
RANDOM_FILES=($(shuf -e "${FILES[@]}" -n "$COUNT"))

# Build ImageMagick command
CMD=(magick)
for FILE in "${RANDOM_FILES[@]}"; do
    if (( HEIGHT > 0 )); then
        CMD+=("$FILE" -resize x"$HEIGHT")
    else
        CMD+=("$FILE")
    fi
done
CMD+=(+append "$OUTPUT")

# Run the command
"${CMD[@]}"

# Show result
echo "Created $OUTPUT from:"
for f in "${RANDOM_FILES[@]}"; do
    echo "  $(basename "$f")"
done
if (( HEIGHT > 0 )); then
    echo "All images resized to height $HEIGHT pixels."
else
    echo "Images kept at original size."
fi
