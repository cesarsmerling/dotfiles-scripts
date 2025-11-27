#!/bin/bash

# Script 13: Install Visual Studio Code
# This script installs VS Code from the AUR using an AUR helper (yay or paru)
# Dependencies: yay or paru (AUR helper)

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration variables
AUR_PACKAGE="visual-studio-code-bin"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Visual Studio Code Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check for AUR helper
echo -e "${YELLOW}[1/3] Checking for AUR helper...${NC}"

AUR_HELPER=""
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
    echo -e "${GREEN}✓ Found AUR helper: yay${NC}"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
    echo -e "${GREEN}✓ Found AUR helper: paru${NC}"
else
    echo -e "${RED}✗ No AUR helper found (yay or paru)${NC}"
    echo -e "${RED}  Please install an AUR helper first${NC}"
    echo ""
    echo -e "${YELLOW}To install yay:${NC}"
    echo -e "${YELLOW}  sudo pacman -S --needed git base-devel${NC}"
    echo -e "${YELLOW}  git clone https://aur.archlinux.org/yay.git${NC}"
    echo -e "${YELLOW}  cd yay${NC}"
    echo -e "${YELLOW}  makepkg -si${NC}"
    echo ""
    echo -e "${YELLOW}Or to install paru:${NC}"
    echo -e "${YELLOW}  sudo pacman -S --needed git base-devel${NC}"
    echo -e "${YELLOW}  git clone https://aur.archlinux.org/paru.git${NC}"
    echo -e "${YELLOW}  cd paru${NC}"
    echo -e "${YELLOW}  makepkg -si${NC}"
    exit 1
fi
echo ""

# Step 2: Install VS Code from AUR
echo -e "${YELLOW}[2/3] Installing Visual Studio Code from AUR...${NC}"

# Check if VS Code is already installed
if command -v code &> /dev/null; then
    CURRENT_VERSION=$(code --version | head -n1)
    echo -e "${GREEN}✓ VS Code is already installed${NC}"
    echo -e "${BLUE}  Version: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  Ensuring it's up to date...${NC}"
    if $AUR_HELPER -Syu --noconfirm "$AUR_PACKAGE"; then
        echo -e "${GREEN}✓ VS Code updated successfully${NC}"
    else
        echo -e "${YELLOW}⚠ Update may have failed, but VS Code is installed${NC}"
    fi
else
    echo -e "${BLUE}  Installing VS Code package: $AUR_PACKAGE${NC}"
    echo -e "${BLUE}  Using AUR helper: $AUR_HELPER${NC}"
    if $AUR_HELPER -S --noconfirm "$AUR_PACKAGE"; then
        echo -e "${GREEN}✓ VS Code installed successfully${NC}"
        INSTALLED_VERSION=$(code --version | head -n1)
        echo -e "${BLUE}  Version: $INSTALLED_VERSION${NC}"
    else
        echo -e "${RED}✗ Failed to install VS Code${NC}"
        exit 1
    fi
fi
echo ""

# Step 3: Verify installation
echo -e "${YELLOW}[3/3] Verifying installation...${NC}"

if command -v code &> /dev/null; then
    INSTALLED_VERSION=$(code --version | head -n1)
    echo -e "${GREEN}✓ VS Code is properly installed${NC}"
    echo -e "${BLUE}  Version: $INSTALLED_VERSION${NC}"
else
    echo -e "${RED}✗ VS Code command not found after installation${NC}"
    exit 1
fi
echo ""

# Final summary
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ VS Code installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

echo -e "${BLUE}Installation path:${NC}"
echo -e "${BLUE}  $(which code)${NC}"
echo ""
echo -e "${BLUE}Version information:${NC}"
echo -e "${BLUE}  $(code --version | head -n3 | tr '\n' ' ')${NC}"
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo -e "${YELLOW}  Start VS Code: code${NC}"
echo -e "${YELLOW}  Open a file: code filename${NC}"
echo -e "${YELLOW}  Open a folder: code /path/to/folder${NC}"
echo -e "${YELLOW}  Open current directory: code .${NC}"
echo ""
echo -e "${BLUE}Additional notes:${NC}"
echo -e "${BLUE}  • Update VS Code: $AUR_HELPER -Syu visual-studio-code-bin${NC}"
echo -e "${BLUE}  • Extensions can be installed from the Extensions view (Ctrl+Shift+X)${NC}"
echo -e "${BLUE}  • Settings are stored in ~/.config/Code/User/settings.json${NC}"
echo ""
