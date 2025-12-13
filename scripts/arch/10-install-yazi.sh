#!/bin/bash

###############################################################################
# Arch Linux Yazi Installation Script
###############################################################################
# Description: Installs yazi (terminal file manager) via pacman/yay
# Reference: linux-install-notion.md - Line 252-265
# Dependencies: pacman (yay optional for AUR packages)
# Usage: ./10-install-yazi.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables
CONFIG_DIR="$HOME/.config"
YAZI_CONFIG_DIR="$CONFIG_DIR/yazi"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_YAZI="$REPO_DIR/dotfiles/yazi"
PACKAGE_NAME="yazi"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Yazi Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check system package manager
echo -e "${YELLOW}[1/4] Checking system package manager...${NC}"
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}✗ pacman is not available${NC}"
    echo -e "${RED}  This script is for Arch-based distributions${NC}"
    exit 1
fi

echo -e "${GREEN}✓ System package manager available${NC}"
echo ""

# Step 2: Install yazi via pacman/yay
echo -e "${YELLOW}[2/4] Installing yazi...${NC}"

# Check if yazi is already installed
if command -v yazi &> /dev/null; then
    CURRENT_VERSION=$(yazi --version)
    echo -e "${GREEN}✓ Yazi is already installed${NC}"
    echo -e "${BLUE}  Version: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  Ensuring it's up to date...${NC}"

    # Try to update with yay first, then pacman
    if command -v yay &> /dev/null; then
        echo -e "${BLUE}  Using yay to update yazi...${NC}"
        if yay -S --noconfirm "$PACKAGE_NAME"; then
            echo -e "${GREEN}✓ Yazi updated successfully${NC}"
        else
            echo -e "${YELLOW}⚠ Update may have failed, but Yazi is installed${NC}"
        fi
    else
        if sudo pacman -Syu --noconfirm "$PACKAGE_NAME" 2>/dev/null; then
            echo -e "${GREEN}✓ Yazi updated successfully${NC}"
        else
            echo -e "${YELLOW}⚠ Yazi may not be in official repos, consider installing yay for AUR access${NC}"
        fi
    fi
else
    echo -e "${BLUE}  Installing Yazi...${NC}"

    # Try yay first (for AUR packages), then pacman
    if command -v yay &> /dev/null; then
        echo -e "${BLUE}  Using yay (AUR helper)...${NC}"
        if yay -S --noconfirm "$PACKAGE_NAME"; then
            echo -e "${GREEN}✓ Yazi installed successfully via yay${NC}"
        else
            echo -e "${RED}✗ Failed to install yazi via yay${NC}"
            exit 1
        fi
    else
        echo -e "${BLUE}  Using pacman...${NC}"
        if sudo pacman -S --noconfirm "$PACKAGE_NAME" 2>/dev/null; then
            echo -e "${GREEN}✓ Yazi installed successfully via pacman${NC}"
        else
            echo -e "${RED}✗ Yazi not found in official repositories${NC}"
            echo -e "${YELLOW}  Yazi is available in the AUR. Please install yay first:${NC}"
            echo -e "${YELLOW}  git clone https://aur.archlinux.org/yay.git${NC}"
            echo -e "${YELLOW}  cd yay && makepkg -si${NC}"
            exit 1
        fi
    fi
fi
echo ""

# Step 3: Verify yazi installation
echo -e "${YELLOW}[3/4] Verifying yazi installation...${NC}"
if command -v yazi &> /dev/null; then
    YAZI_VERSION=$(yazi --version)
    YAZI_PATH=$(which yazi)
    echo -e "${GREEN}✓ Yazi verified${NC}"
    echo -e "${BLUE}  Version: $YAZI_VERSION${NC}"
    echo -e "${BLUE}  Location: $YAZI_PATH${NC}"
else
    echo -e "${RED}✗ Yazi command not found after installation${NC}"
    exit 1
fi
echo ""

# Step 4: Link Yazi configuration from dotfiles
echo -e "${YELLOW}[4/4] Linking Yazi configuration from dotfiles...${NC}"

# Check if dotfiles/yazi exists in repository
if [ ! -d "$DOTFILES_YAZI" ]; then
    echo -e "${RED}✗ Dotfiles yazi folder not found at: $DOTFILES_YAZI${NC}"
    echo -e "${YELLOW}  Skipping configuration linking step${NC}"
else
    # Create ~/.config directory if it doesn't exist
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
        echo -e "${GREEN}✓ Created directory: $CONFIG_DIR${NC}"
    fi

    # Handle existing yazi config directory
    if [ -e "$YAZI_CONFIG_DIR" ]; then
        if [ -L "$YAZI_CONFIG_DIR" ]; then
            # It's already a symlink, remove it
            rm "$YAZI_CONFIG_DIR"
            echo -e "${YELLOW}  Removed existing symlink: $YAZI_CONFIG_DIR${NC}"
        else
            # It's a real directory or file, backup it
            BACKUP_DIR="$YAZI_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$YAZI_CONFIG_DIR" "$BACKUP_DIR"
            echo -e "${YELLOW}  Backed up existing config to: $BACKUP_DIR${NC}"
        fi
    fi

    # Create the symlink
    if ln -s "$DOTFILES_YAZI" "$YAZI_CONFIG_DIR"; then
        echo -e "${GREEN}✓ Created symlink: $YAZI_CONFIG_DIR -> $DOTFILES_YAZI${NC}"
    else
        echo -e "${RED}✗ Failed to create symlink${NC}"
        exit 1
    fi
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Yazi installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Yazi location: $(which yazi)${NC}"
echo -e "${BLUE}Version: $YAZI_VERSION${NC}"
echo -e "${BLUE}Configuration: $YAZI_CONFIG_DIR${NC}"
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo -e "${BLUE}  yazi                    # Start yazi in current directory${NC}"
echo -e "${BLUE}  yazi <directory>        # Start yazi in specified directory${NC}"
echo ""
echo -e "${YELLOW}Basic Keybindings:${NC}"
echo -e "${BLUE}  j/k or ↓/↑             # Navigate down/up${NC}"
echo -e "${BLUE}  h/l or ←/→             # Go to parent/enter directory${NC}"
echo -e "${BLUE}  Enter                   # Open file${NC}"
echo -e "${BLUE}  q                       # Quit${NC}"
echo ""
