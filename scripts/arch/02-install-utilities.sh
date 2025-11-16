#!/bin/bash

###############################################################################
# Arch Linux Utilities Installation Script
###############################################################################
# Description: Installs essential utilities and command-line tools
# Reference: linux-install-notion.md - Line 17-21 (adapted for Arch Linux)
# Usage: ./02-install-utilities.sh
###############################################################################

set -e  # Exit on error

echo "========================================"
echo "Installing essential utilities..."
echo "========================================"

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
echo ""
echo "The following packages will be installed:"
for package in "${PACKAGES[@]}"; do
    echo "  - $package"
done
echo ""

# Install each package
echo "Installing packages..."
for package in "${PACKAGES[@]}"; do
    echo "Installing $package..."
    sudo pacman -S --noconfirm "$package"
done

echo ""
echo "========================================"
echo "All utilities installed successfully!"
echo "========================================"
