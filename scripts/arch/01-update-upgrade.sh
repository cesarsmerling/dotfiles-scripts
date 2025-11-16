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

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Starting system update and upgrade...${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Update and upgrade all packages without prompts
# -Syu: Sync, refresh package databases, upgrade packages
# --noconfirm: Bypass all prompts
echo -e "${YELLOW}Updating and upgrading all packages...${NC}"
sudo pacman -Syu --noconfirm

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ System update and upgrade completed!${NC}"
echo -e "${GREEN}============================================${NC}"
