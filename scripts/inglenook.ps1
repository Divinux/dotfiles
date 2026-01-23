# creates an image with a random subset of the images in the folder
# used for generating inglenook puzzle variations
# imagemagick required

param (
    [string]$InputDir = ".",
    [int]$Count = 5,
    [string]$Output = "output.png",
	# Set to 0 to keep original image sizes
    [int]$Height = 200   
)

# Validate ImageMagick
if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
    throw "ImageMagick ('magick') not found in PATH"
}

# Remove existing output
if (Test-Path $Output) {
    Remove-Item $Output -Force
}

# Get PNG files
$allFiles = Get-ChildItem $InputDir -Filter *.png
if ($allFiles.Count -lt $Count) {
    throw "Not enough PNG files in '$InputDir' (need $Count)"
}

# Pick random files
$files = $allFiles | Get-Random -Count $Count

# Quote paths
$quoted = $files.FullName | ForEach-Object { "`"$_`"" }

# Build ImageMagick command
if ($Height -gt 0) {
    # Resize to height while preserving aspect ratio
    $resizeCmds = $quoted | ForEach-Object { "$_ -resize x$Height" }
} else {
    # Keep original size
    $resizeCmds = $quoted
}

# Run ImageMagick (+append = horizontal)
$cmd = "magick $($resizeCmds -join ' ') +append `"$Output`""
Invoke-Expression $cmd

Write-Host "Created $Output from:"
$files.Name
if ($Height -gt 0) {
    Write-Host "All images resized to height $Height pixels."
} else {
    Write-Host "Images kept at original size."
}
