#!/bin/bash

# Script 05: Install and Configure Zsh
# This script installs Zsh, sets it as default shell, and creates symlink to dotfiles config
# Dependencies: None (will install zsh)

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration variables
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_ZSHRC="$REPO_DIR/dotfiles/zsh/.zshrc"
TARGET_ZSHRC="$HOME/.zshrc"
BACKUP_ZSHRC="$HOME/.zshrc.backup"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Zsh Installation and Configuration${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Update package list
echo -e "${YELLOW}[1/5] Updating package list...${NC}"
if sudo apt update > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Package list updated${NC}"
else
    echo -e "${RED}✗ Failed to update package list${NC}"
    exit 1
fi
echo ""

# Step 2: Install Zsh
echo -e "${YELLOW}[2/5] Installing Zsh...${NC}"
if dpkg -l | grep -q "^ii  zsh "; then
    echo -e "${GREEN}✓ Zsh is already installed${NC}"
else
    if sudo apt install -y zsh; then
        echo -e "${GREEN}✓ Zsh installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to install Zsh${NC}"
        exit 1
    fi
fi

# Get Zsh path
ZSH_PATH=$(which zsh)
echo -e "${BLUE}  Zsh location: $ZSH_PATH${NC}"
echo ""

# Step 3: Backup existing .zshrc if it exists
echo -e "${YELLOW}[3/5] Checking for existing .zshrc...${NC}"
if [ -f "$TARGET_ZSHRC" ] && [ ! -L "$TARGET_ZSHRC" ]; then
    echo -e "${BLUE}  Found existing .zshrc, creating backup...${NC}"
    mv "$TARGET_ZSHRC" "$BACKUP_ZSHRC"
    echo -e "${GREEN}✓ Backup created: $BACKUP_ZSHRC${NC}"
elif [ -L "$TARGET_ZSHRC" ]; then
    echo -e "${BLUE}  Existing symlink found, removing...${NC}"
    rm "$TARGET_ZSHRC"
    echo -e "${GREEN}✓ Old symlink removed${NC}"
else
    echo -e "${GREEN}✓ No existing .zshrc found${NC}"
fi
echo ""

# Step 4: Create symlink to dotfiles .zshrc
echo -e "${YELLOW}[4/5] Creating symlink to dotfiles configuration...${NC}"
if [ -f "$DOTFILES_ZSHRC" ]; then
    if ln -s "$DOTFILES_ZSHRC" "$TARGET_ZSHRC"; then
        echo -e "${GREEN}✓ Symlink created successfully${NC}"
        echo -e "${BLUE}  Source: $DOTFILES_ZSHRC${NC}"
        echo -e "${BLUE}  Target: $TARGET_ZSHRC${NC}"
    else
        echo -e "${RED}✗ Failed to create symlink${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Dotfiles .zshrc not found at: $DOTFILES_ZSHRC${NC}"
    echo -e "${RED}  Please ensure the dotfiles repository is cloned correctly${NC}"
    exit 1
fi
echo ""

# Step 5: Change default shell to Zsh
echo -e "${YELLOW}[5/5] Setting Zsh as default shell...${NC}"
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)

if [ "$CURRENT_SHELL" = "$ZSH_PATH" ]; then
    echo -e "${GREEN}✓ Zsh is already the default shell${NC}"
else
    echo -e "${BLUE}  Current shell: $CURRENT_SHELL${NC}"
    echo -e "${BLUE}  Changing to: $ZSH_PATH${NC}"

    if chsh -s "$ZSH_PATH"; then
        echo -e "${GREEN}✓ Default shell changed to Zsh${NC}"
    else
        echo -e "${RED}✗ Failed to change default shell${NC}"
        echo -e "${YELLOW}  You may need to run: chsh -s $ZSH_PATH${NC}"
        exit 1
    fi
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Zsh installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Configuration:${NC}"
echo -e "${BLUE}  • Default shell: $ZSH_PATH${NC}"
echo -e "${BLUE}  • Config file: $TARGET_ZSHRC (symlinked)${NC}"
echo -e "${BLUE}  • Source file: $DOTFILES_ZSHRC${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: Log out and log back in for shell change to take effect${NC}"
echo -e "${YELLOW}Or start a new Zsh session by running: zsh${NC}"
echo ""
