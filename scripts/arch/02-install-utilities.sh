#!/bin/bash

###############################################################################
# Arch Linux Utilities Installation Script
###############################################################################
# Description: Installs essential utilities and command-line tools
# Reference: linux-install-notion.md - Line 17-21 (adapted for Arch Linux)
# Usage: ./02-install-utilities.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Installing essential utilities...${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Array of packages to install (one per line for readability)
# Package name differences from Ubuntu:
#   - 7zip -> p7zip
#   - poppler-utils -> poppler
#   - fd-find -> fd
PACKAGES=(
    ffmpeg
    p7zip
    jq
    poppler
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
)

# Display packages to be installed
echo -e "${YELLOW}The following packages will be installed:${NC}"
for package in "${PACKAGES[@]}"; do
    echo -e "  ${BLUE}- $package${NC}"
done
echo ""

# Install each package
echo -e "${YELLOW}Installing packages...${NC}"
for package in "${PACKAGES[@]}"; do
    echo -e "${BLUE}  Installing $package...${NC}"
    sudo pacman -S --noconfirm "$package"
    echo -e "${GREEN}  ✓ $package installed${NC}"
done

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ All utilities installed successfully!${NC}"
echo -e "${GREEN}============================================${NC}"
