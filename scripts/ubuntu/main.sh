#!/bin/bash

###############################################################################
# Ubuntu/Pop_OS Main Installation Script
###############################################################################
# Description: Main script that runs all Ubuntu/Pop_OS setup scripts
# Reference: linux-install-notion.md
# Usage: ./main.sh
###############################################################################

set -e  # Exit on error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "Ubuntu/Pop_OS Setup Script"
echo "========================================"
echo ""

# Request sudo privileges upfront
echo "Requesting sudo privileges..."
sudo -v

# Keep sudo alive: update existing sudo time stamp until the script finishes
# This runs in the background and updates sudo every 60 seconds
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

echo "Starting installation scripts..."
echo ""

###############################################################################
# Run installation scripts in order
###############################################################################

# 01 - System Update and Upgrade
if [ -f "$SCRIPT_DIR/01-update-upgrade.sh" ]; then
    echo "Running: 01-update-upgrade.sh"
    bash "$SCRIPT_DIR/01-update-upgrade.sh"
    echo ""
else
    echo "Warning: 01-update-upgrade.sh not found, skipping..."
    echo ""
fi

# Add more scripts here as they are created
# Example:
# if [ -f "$SCRIPT_DIR/02-utilities.sh" ]; then
#     echo "Running: 02-utilities.sh"
#     bash "$SCRIPT_DIR/02-utilities.sh"
#     echo ""
# fi

echo "========================================"
echo "All installation scripts completed!"
echo "========================================"
