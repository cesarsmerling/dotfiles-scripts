#!/bin/bash

# Script 14: Install Brave Browser
# This script installs Brave Browser via pacman
# Dependencies: pacman

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Package name
BRAVE_PACKAGE="brave-browser"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Brave Browser Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check if pacman is available
echo -e "${YELLOW}[1/3] Checking system package manager...${NC}"
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}✗ pacman is not available${NC}"
    echo -e "${RED}  This script is for Arch-based distributions${NC}"
    exit 1
fi

echo -e "${GREEN}✓ System package manager available${NC}"
echo ""

# Step 2: Check if Brave is already installed
echo -e "${YELLOW}[2/3] Checking for existing installation...${NC}"

if command -v brave &> /dev/null; then
    CURRENT_VERSION=$(brave --version 2>/dev/null || echo "Unknown")
    echo -e "${GREEN}✓ Brave Browser is already installed${NC}"
    echo -e "${BLUE}  Version: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  Ensuring it's up to date...${NC}"
    if sudo pacman -Syu --noconfirm "$BRAVE_PACKAGE"; then
        echo -e "${GREEN}✓ Brave Browser updated successfully${NC}"
    else
        echo -e "${YELLOW}⚠ Update may have failed, but Brave is installed${NC}"
    fi
else
    echo -e "${BLUE}  Brave Browser not found, proceeding with installation${NC}"
fi
echo ""

# Step 3: Install Brave Browser
echo -e "${YELLOW}[3/3] Installing Brave Browser via pacman...${NC}"

# Check if already installed (again, in case it was found in step 2)
if ! command -v brave &> /dev/null; then
    echo -e "${BLUE}  Installing $BRAVE_PACKAGE...${NC}"
    if sudo pacman -S --noconfirm "$BRAVE_PACKAGE"; then
        echo -e "${GREEN}✓ Brave Browser installed successfully${NC}"
        INSTALLED_VERSION=$(brave --version 2>/dev/null || echo "Unknown")
        echo -e "${BLUE}  Version: $INSTALLED_VERSION${NC}"
    else
        echo -e "${RED}✗ Failed to install Brave Browser${NC}"
        echo -e "${YELLOW}  Note: You may need to enable AUR or use an AUR helper like 'yay'${NC}"
        echo -e "${YELLOW}  Alternative: yay -S brave-bin${NC}"
        exit 1
    fi
fi
echo ""

# Verify installation
echo -e "${YELLOW}Verifying installation...${NC}"
if command -v brave &> /dev/null; then
    INSTALLED_VERSION=$(brave --version 2>/dev/null || echo "Unknown")
    echo -e "${GREEN}✓ Brave Browser is properly installed${NC}"
    echo -e "${BLUE}  Version: $INSTALLED_VERSION${NC}"
else
    echo -e "${RED}✗ Brave Browser command not found after installation${NC}"
    exit 1
fi
echo ""

# Final summary
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Brave Browser installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

echo -e "${BLUE}Installation path:${NC}"
echo -e "${BLUE}  $(which brave)${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo -e "${BLUE}  • Launch Brave: brave${NC}"
echo -e "${BLUE}  • Or search for 'Brave' in your applications menu${NC}"
echo ""
