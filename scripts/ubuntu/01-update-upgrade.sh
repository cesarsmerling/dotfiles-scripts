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

# Update package lists
echo -e "${YELLOW}[1/3] Updating package lists...${NC}"
sudo apt update
echo -e "${GREEN}✓ Package lists updated${NC}"
echo ""

# Enable universe repository (required for many packages)
echo -e "${YELLOW}[2/3] Enabling universe repository...${NC}"
sudo add-apt-repository universe -y
sudo apt update
echo -e "${GREEN}✓ Universe repository enabled${NC}"
echo ""

# Upgrade all packages without prompts
echo -e "${YELLOW}[3/3] Upgrading installed packages...${NC}"
sudo apt upgrade -y
echo -e "${GREEN}✓ Packages upgraded${NC}"
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ System update and upgrade completed!${NC}"
echo -e "${GREEN}============================================${NC}"
