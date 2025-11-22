#!/bin/bash

###############################################################################
# Ubuntu/Pop_OS Yazi Installation Script
###############################################################################
# Description: Installs yazi (terminal file manager) via cargo
# Reference: linux-install-notion.md - Line 252-265
# Dependencies: cargo (script 08-install-cargo.sh)
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
CARGO_BIN="$HOME/.cargo/bin/cargo"
YAZI_BIN="$HOME/.cargo/bin/yazi"
YAZI_REPO="https://github.com/sxyazi/yazi.git"
CONFIG_DIR="$HOME/.config"
YAZI_CONFIG_DIR="$CONFIG_DIR/yazi"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_YAZI="$REPO_DIR/dotfiles/yazi"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Yazi Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check if cargo is installed
echo -e "${YELLOW}[1/4] Checking for cargo installation...${NC}"
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}✗ Cargo is not installed${NC}"
    echo -e "${YELLOW}Please run script 08-install-cargo.sh first${NC}"
    exit 1
fi

CARGO_VERSION=$(cargo --version)
echo -e "${GREEN}✓ Cargo found: $CARGO_VERSION${NC}"
echo ""

# Step 2: Check if yazi is already installed
if command -v yazi &> /dev/null; then
    YAZI_VERSION=$(yazi --version)
    echo -e "${YELLOW}Yazi is already installed: $YAZI_VERSION${NC}"
    echo -e "${YELLOW}Skipping installation step${NC}"
    echo ""
    SKIP_INSTALL=true
else
    SKIP_INSTALL=false
fi

# Step 2: Install yazi via cargo
if [ "$SKIP_INSTALL" = false ]; then
    echo -e "${YELLOW}[2/4] Installing yazi via cargo...${NC}"
    echo -e "${BLUE}This may take several minutes as cargo compiles yazi from source${NC}"
    echo -e "${BLUE}Installing: yazi-fm and yazi-cli${NC}"
    echo ""

    if cargo install --force yazi-build; then
        echo -e "${GREEN}✓ Yazi installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to install yazi${NC}"
        exit 1
    fi
    echo ""
else
    echo -e "${YELLOW}[2/4] Skipping yazi installation (already installed)${NC}"
    echo ""
fi

# Step 3: Verify yazi installation
if [ "$SKIP_INSTALL" = false ]; then
    echo -e "${YELLOW}[3/4] Verifying yazi installation...${NC}"
    if command -v yazi &> /dev/null; then
        YAZI_VERSION=$(yazi --version)
        echo -e "${GREEN}✓ Yazi verified: $YAZI_VERSION${NC}"
    else
        echo -e "${RED}✗ Yazi command not found after installation${NC}"
        exit 1
    fi
    echo ""
else
    echo -e "${YELLOW}[3/4] Skipping verification (already verified)${NC}"
    echo ""
fi

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
echo -e "${BLUE}Yazi binary location: $YAZI_BIN${NC}"
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
