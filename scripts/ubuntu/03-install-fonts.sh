#!/bin/bash

# Script 03: Install Nerd Fonts
# This script downloads and installs Nerd Fonts from specified URLs
# Dependencies: wget, p7zip-full (7z command)

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Font URLs array - Add or modify URLs as needed
# Each URL should point to a .zip file from Nerd Fonts releases
FONT_URLS=(
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hermit.zip"
    # Add more font URLs here, one per line
    # "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
    # "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
)

# Font installation directory
FONTS_DIR="$HOME/.local/share/fonts"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Nerd Fonts Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Create fonts directory if it doesn't exist
echo -e "${YELLOW}[1/5] Creating fonts directory...${NC}"
if [ ! -d "$FONTS_DIR" ]; then
    mkdir -p "$FONTS_DIR"
    echo -e "${GREEN}✓ Created directory: $FONTS_DIR${NC}"
else
    echo -e "${GREEN}✓ Directory already exists: $FONTS_DIR${NC}"
fi
echo ""

# Step 2: Download fonts
echo -e "${YELLOW}[2/5] Downloading fonts...${NC}"
cd "$FONTS_DIR"

for i in "${!FONT_URLS[@]}"; do
    url="${FONT_URLS[$i]}"
    output_file="fonts_${i}.zip"

    echo -e "${BLUE}  Downloading font $((i+1))/${#FONT_URLS[@]}: $(basename "$url")${NC}"

    if wget -O "$output_file" "$url"; then
        echo -e "${GREEN}  ✓ Downloaded: $output_file${NC}"
    else
        echo -e "${RED}  ✗ Failed to download: $url${NC}"
        exit 1
    fi
done
echo ""

# Step 3: Unzip all downloaded fonts
echo -e "${YELLOW}[3/5] Extracting fonts...${NC}"
for zip_file in fonts_*.zip; do
    if [ -f "$zip_file" ]; then
        echo -e "${BLUE}  Extracting: $zip_file${NC}"

        if 7z x "$zip_file" -y > /dev/null 2>&1; then
            echo -e "${GREEN}  ✓ Extracted: $zip_file${NC}"
        else
            echo -e "${RED}  ✗ Failed to extract: $zip_file${NC}"
            exit 1
        fi
    fi
done
echo ""

# Step 4: Update font cache
echo -e "${YELLOW}[4/5] Updating font cache...${NC}"
if fc-cache -fv > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Font cache updated successfully${NC}"
else
    echo -e "${RED}✗ Failed to update font cache${NC}"
    exit 1
fi
echo ""

# Step 5: Clean up zip files
echo -e "${YELLOW}[5/5] Cleaning up zip files...${NC}"
rm -f fonts_*.zip
echo -e "${GREEN}✓ Removed all temporary zip files${NC}"
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Font installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Installed fonts location: $FONTS_DIR${NC}"
echo -e "${BLUE}You may need to restart your terminal/applications to see the new fonts.${NC}"
