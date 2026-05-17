#!/usr/bin/env python
import re

# Replace with your input and output file paths
input_file = ""
output_file = ""

# Regular expression to match hex color codes (# followed by 3 or 6 hex digits)
hex_color_pattern = re.compile(r'#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})\b')

# Set to store unique colors
unique_colors = set()

# Read the CSS file
with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()
    # Find all hex color codes
    matches = hex_color_pattern.findall(content)
    for match in matches:
        # Convert to uppercase and ensure it has the #
        color = f"#{match.upper()}"
        unique_colors.add(color)

# Write the unique colors to the output file, one per line
with open(output_file, 'w', encoding='utf-8') as f:
    for color in sorted(unique_colors):
        f.write(color + '\n')

print(f"Found {len(unique_colors)} unique color(s). Saved to {output_file}")