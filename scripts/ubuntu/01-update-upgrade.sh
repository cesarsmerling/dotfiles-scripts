#!/bin/bash

###############################################################################
# Ubuntu/Pop_OS Update and Upgrade Script
###############################################################################
# Description: Updates package lists and upgrades all installed packages
#              without user prompts
# Reference: linux-install-notion.md - Line 11-15
# Usage: ./01-update-upgrade.sh
###############################################################################

set -e  # Exit on error

echo "========================================"
echo "Starting system update and upgrade..."
echo "========================================"

# Update package lists
echo "Updating package lists..."
sudo apt update

# Enable universe repository (required for many packages)
echo "Enabling universe repository..."
sudo add-apt-repository universe -y
sudo apt update

# Upgrade all packages without prompts
echo "Upgrading installed packages..."
sudo apt upgrade -y

echo "========================================"
echo "System update and upgrade completed!"
echo "========================================"
