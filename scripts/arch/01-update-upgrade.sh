#!/bin/bash

###############################################################################
# Arch Linux Update and Upgrade Script
###############################################################################
# Description: Updates package lists and upgrades all installed packages
#              without user prompts
# Reference: linux-install-notion.md - Line 11-15 (adapted for Arch Linux)
# Usage: ./01-update-upgrade.sh
###############################################################################

set -e  # Exit on error

echo "========================================"
echo "Starting system update and upgrade..."
echo "========================================"

# Update and upgrade all packages without prompts
# -Syu: Sync, refresh package databases, upgrade packages
# --noconfirm: Bypass all prompts
echo "Updating and upgrading all packages..."
sudo pacman -Syu --noconfirm

echo "========================================"
echo "System update and upgrade completed!"
echo "========================================"
