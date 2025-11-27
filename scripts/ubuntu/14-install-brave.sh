#!/bin/bash

# Script 14: Install Brave Browser
# This script downloads and installs Brave Browser using the official installation script
# Dependencies: curl

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation variables
BRAVE_INSTALL_URL="https://dl.brave.com/install.sh"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Brave Browser Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check if curl is available
echo -e "${YELLOW}[1/3] Checking dependencies...${NC}"
if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not available${NC}"
    echo -e "${RED}  Please install curl first: sudo apt install curl${NC}"
    exit 1
fi

echo -e "${GREEN}✓ curl is available${NC}"
echo ""

# Step 2: Check if Brave is already installed
echo -e "${YELLOW}[2/3] Checking for existing installation...${NC}"

if command -v brave-browser &> /dev/null; then
    CURRENT_VERSION=$(brave-browser --version 2>/dev/null || echo "Unknown")
    echo -e "${GREEN}✓ Brave Browser is already installed${NC}"
    echo -e "${BLUE}  Version: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  The installation script will update Brave if needed${NC}"
else
    echo -e "${BLUE}  Brave Browser not found, proceeding with installation${NC}"
fi
echo ""

# Step 3: Download and run the official Brave installation script
echo -e "${YELLOW}[3/3] Installing Brave Browser...${NC}"
echo -e "${BLUE}  Downloading installation script from: $BRAVE_INSTALL_URL${NC}"
echo -e "${BLUE}  This will require sudo privileges${NC}"
echo ""

if curl -fsS "$BRAVE_INSTALL_URL" | sh; then
    echo ""
    echo -e "${GREEN}✓ Brave Browser installation completed successfully${NC}"
else
    echo -e "${RED}✗ Failed to install Brave Browser${NC}"
    exit 1
fi
echo ""

# Verify installation
echo -e "${YELLOW}Verifying installation...${NC}"
if command -v brave-browser &> /dev/null; then
    INSTALLED_VERSION=$(brave-browser --version 2>/dev/null || echo "Unknown")
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
echo -e "${BLUE}  $(which brave-browser)${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo -e "${BLUE}  • Launch Brave: brave-browser${NC}"
echo -e "${BLUE}  • Or search for 'Brave' in your applications menu${NC}"
echo ""
