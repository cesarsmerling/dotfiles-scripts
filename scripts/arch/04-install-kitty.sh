#!/bin/bash

# Script 04: Install Kitty Terminal
# This script downloads and installs Kitty terminal and creates desktop shortcuts
# Dependencies: curl

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation directories
LOCAL_BIN="$HOME/.local/bin"
KITTY_APP="$HOME/.local/kitty.app"
APPLICATIONS_DIR="$HOME/.local/share/applications"
XDG_TERMINALS="$HOME/.config/xdg-terminals.list"
CONFIG_DIR="$HOME/.config"
KITTY_CONFIG_DIR="$CONFIG_DIR/kitty"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_KITTY="$REPO_DIR/dotfiles/kitty"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Kitty Terminal Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Download and install Kitty
echo -e "${YELLOW}[1/5] Downloading and installing Kitty terminal...${NC}"
if curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin; then
    echo -e "${GREEN}✓ Kitty terminal installed successfully${NC}"
else
    echo -e "${RED}✗ Failed to install Kitty terminal${NC}"
    exit 1
fi
echo ""

# Step 2: Create ~/.local/bin directory and symlinks
echo -e "${YELLOW}[2/5] Creating symlinks...${NC}"
if [ ! -d "$LOCAL_BIN" ]; then
    mkdir -p "$LOCAL_BIN"
    echo -e "${GREEN}✓ Created directory: $LOCAL_BIN${NC}"
else
    echo -e "${GREEN}✓ Directory already exists: $LOCAL_BIN${NC}"
fi

if ln -sf "$KITTY_APP/bin/kitty" "$KITTY_APP/bin/kitten" "$LOCAL_BIN/"; then
    echo -e "${GREEN}✓ Created symlinks for kitty and kitten${NC}"
else
    echo -e "${RED}✗ Failed to create symlinks${NC}"
    exit 1
fi
echo ""

# Step 3: Create desktop shortcuts
echo -e "${YELLOW}[3/5] Creating desktop shortcuts...${NC}"
if [ ! -d "$APPLICATIONS_DIR" ]; then
    mkdir -p "$APPLICATIONS_DIR"
    echo -e "${GREEN}✓ Created directory: $APPLICATIONS_DIR${NC}"
else
    echo -e "${GREEN}✓ Directory already exists: $APPLICATIONS_DIR${NC}"
fi

# Copy desktop files
if cp "$KITTY_APP/share/applications/kitty.desktop" "$APPLICATIONS_DIR/" && \
   cp "$KITTY_APP/share/applications/kitty-open.desktop" "$APPLICATIONS_DIR/"; then
    echo -e "${GREEN}✓ Copied desktop files${NC}"
else
    echo -e "${RED}✗ Failed to copy desktop files${NC}"
    exit 1
fi

# Update icon paths in desktop files
ICON_PATH=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
if sed -i "s|Icon=kitty|Icon=$ICON_PATH|g" "$APPLICATIONS_DIR/kitty"*.desktop; then
    echo -e "${GREEN}✓ Updated icon paths in desktop files${NC}"
else
    echo -e "${RED}✗ Failed to update icon paths${NC}"
    exit 1
fi

# Update executable paths in desktop files
EXEC_PATH=$(readlink -f ~)/.local/kitty.app/bin/kitty
if sed -i "s|Exec=kitty|Exec=$EXEC_PATH|g" "$APPLICATIONS_DIR/kitty"*.desktop; then
    echo -e "${GREEN}✓ Updated executable paths in desktop files${NC}"
else
    echo -e "${RED}✗ Failed to update executable paths${NC}"
    exit 1
fi
echo ""

# Step 4: Set Kitty as default terminal
echo -e "${YELLOW}[4/5] Setting Kitty as default terminal...${NC}"
XDG_CONFIG_DIR=$(dirname "$XDG_TERMINALS")
if [ ! -d "$XDG_CONFIG_DIR" ]; then
    mkdir -p "$XDG_CONFIG_DIR"
    echo -e "${GREEN}✓ Created directory: $XDG_CONFIG_DIR${NC}"
fi

if echo 'kitty.desktop' > "$XDG_TERMINALS"; then
    echo -e "${GREEN}✓ Set Kitty as default terminal${NC}"
else
    echo -e "${RED}✗ Failed to set default terminal${NC}"
    exit 1
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Kitty terminal installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Installation location: $KITTY_APP${NC}"
echo -e "${BLUE}Binaries linked to: $LOCAL_BIN${NC}"
echo -e "${BLUE}Desktop shortcuts: $APPLICATIONS_DIR${NC}"
# Step 5: Link Kitty configuration from dotfiles
echo -e "${YELLOW}[5/5] Linking Kitty configuration from dotfiles...${NC}"

# Check if dotfiles/kitty exists in repository
if [ ! -d "$DOTFILES_KITTY" ]; then
    echo -e "${RED}✗ Dotfiles kitty folder not found at: $DOTFILES_KITTY${NC}"
    echo -e "${YELLOW}  Skipping configuration linking step${NC}"
else
    # Create ~/.config directory if it doesn't exist
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
        echo -e "${GREEN}✓ Created directory: $CONFIG_DIR${NC}"
    fi

    # Handle existing kitty config directory
    if [ -e "$KITTY_CONFIG_DIR" ]; then
        if [ -L "$KITTY_CONFIG_DIR" ]; then
            # It's already a symlink, remove it
            rm "$KITTY_CONFIG_DIR"
            echo -e "${YELLOW}  Removed existing symlink: $KITTY_CONFIG_DIR${NC}"
        else
            # It's a real directory or file, backup it
            BACKUP_DIR="$KITTY_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$KITTY_CONFIG_DIR" "$BACKUP_DIR"
            echo -e "${YELLOW}  Backed up existing config to: $BACKUP_DIR${NC}"
        fi
    fi

    # Create the symlink
    if ln -s "$DOTFILES_KITTY" "$KITTY_CONFIG_DIR"; then
        echo -e "${GREEN}✓ Created symlink: $KITTY_CONFIG_DIR -> $DOTFILES_KITTY${NC}"
    else
        echo -e "${RED}✗ Failed to create symlink${NC}"
        exit 1
    fi
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Kitty terminal installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Installation location: $KITTY_APP${NC}"
echo -e "${BLUE}Binaries linked to: $LOCAL_BIN${NC}"
echo -e "${BLUE}Desktop shortcuts: $APPLICATIONS_DIR${NC}"
echo -e "${BLUE}Configuration: $KITTY_CONFIG_DIR${NC}"
echo ""
echo -e "${YELLOW}Note: You may need to log out and log back in for desktop shortcuts to appear.${NC}"
echo -e "${YELLOW}You can launch Kitty by typing 'kitty' in your terminal or from the application menu.${NC}"
