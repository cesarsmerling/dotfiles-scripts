#!/bin/bash

###############################################################################
# Ubuntu/Pop_OS Utilities Installation Script
###############################################################################
# Description: Installs essential utilities and command-line tools
# Reference: linux-install-notion.md - Line 17-21
# Usage: ./02-install-utilities.sh
###############################################################################

set -e  # Exit on error

echo "========================================"
echo "Installing essential utilities..."
echo "========================================"

# Array of packages to install (one per line for readability)
PACKAGES=(
    ffmpeg
    7zip
    jq
    poppler-utils
    fd-find
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
    sudo apt install -y "$package"
done

echo ""
echo "========================================"
echo "All utilities installed successfully!"
echo "========================================"
