#!/bin/bash

# Script 12: Install and Configure Neovim
# This script installs Neovim via pacman, backs up existing config, and symlinks dotfiles
# Dependencies: pacman

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration variables
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_NVIM="$REPO_DIR/dotfiles/nvim"
CONFIG_DIR="$HOME/.config"
TARGET_NVIM_CONFIG="$CONFIG_DIR/nvim"
BACKUP_SUFFIX=".backup"

# Directories to backup
BACKUP_DIRS=(
    "$HOME/.config/nvim"
    "$HOME/.local/share/nvim"
    "$HOME/.local/state/nvim"
    "$HOME/.cache/nvim"
)

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Neovim Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check if pacman is available
echo -e "${YELLOW}[1/5] Checking system package manager...${NC}"
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}✗ pacman is not available${NC}"
    echo -e "${RED}  This script is for Arch-based distributions${NC}"
    exit 1
fi

echo -e "${GREEN}✓ System package manager available${NC}"
echo ""

# Step 2: Install Neovim
echo -e "${YELLOW}[2/5] Installing Neovim via pacman...${NC}"

# Check if nvim is already installed
if command -v nvim &> /dev/null; then
    CURRENT_VERSION=$(nvim --version | head -n1)
    echo -e "${GREEN}✓ Neovim is already installed${NC}"
    echo -e "${BLUE}  Version: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  Ensuring it's up to date...${NC}"
    if sudo pacman -Syu --noconfirm neovim; then
        echo -e "${GREEN}✓ Neovim updated successfully${NC}"
    else
        echo -e "${YELLOW}⚠ Update may have failed, but Neovim is installed${NC}"
    fi
else
    echo -e "${BLUE}  Installing Neovim...${NC}"
    if sudo pacman -S --noconfirm neovim; then
        echo -e "${GREEN}✓ Neovim installed successfully${NC}"
        INSTALLED_VERSION=$(nvim --version | head -n1)
        echo -e "${BLUE}  Version: $INSTALLED_VERSION${NC}"
    else
        echo -e "${RED}✗ Failed to install Neovim${NC}"
        exit 1
    fi
fi
echo ""

# Step 3: Backup existing Neovim configurations
echo -e "${YELLOW}[3/5] Backing up existing Neovim configurations...${NC}"
BACKUP_COUNT=0

for DIR in "${BACKUP_DIRS[@]}"; do
    if [ -e "$DIR" ] && [ ! -L "$DIR" ]; then
        BACKUP_TARGET="${DIR}${BACKUP_SUFFIX}"
        echo -e "${BLUE}  Backing up: $DIR${NC}"
        if mv "$DIR" "$BACKUP_TARGET"; then
            echo -e "${GREEN}  ✓ Backup created: $BACKUP_TARGET${NC}"
            BACKUP_COUNT=$((BACKUP_COUNT + 1))
        else
            echo -e "${RED}  ✗ Failed to backup: $DIR${NC}"
        fi
    elif [ -L "$DIR" ]; then
        echo -e "${BLUE}  Removing symlink: $DIR${NC}"
        rm "$DIR"
        echo -e "${GREEN}  ✓ Symlink removed${NC}"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
    else
        echo -e "${BLUE}  Skipping (not found): $DIR${NC}"
    fi
done

if [ $BACKUP_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ No existing configurations to backup${NC}"
else
    echo -e "${GREEN}✓ Backed up $BACKUP_COUNT configuration(s)${NC}"
fi
echo ""

# Step 4: Create symlink to dotfiles nvim config
echo -e "${YELLOW}[4/5] Creating symlink to dotfiles configuration...${NC}"

# Ensure .config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
    echo -e "${GREEN}✓ Created directory: $CONFIG_DIR${NC}"
fi

# Verify dotfiles nvim directory exists
if [ ! -d "$DOTFILES_NVIM" ]; then
    echo -e "${RED}✗ Dotfiles nvim directory not found at: $DOTFILES_NVIM${NC}"
    echo -e "${RED}  Please ensure the dotfiles repository contains the nvim folder${NC}"
    exit 1
fi

# Create symlink
if ln -s "$DOTFILES_NVIM" "$TARGET_NVIM_CONFIG"; then
    echo -e "${GREEN}✓ Symlink created successfully${NC}"
    echo -e "${BLUE}  Source: $DOTFILES_NVIM${NC}"
    echo -e "${BLUE}  Target: $TARGET_NVIM_CONFIG${NC}"
else
    echo -e "${RED}✗ Failed to create symlink${NC}"
    exit 1
fi
echo ""

# Step 5: Verify installation
echo -e "${YELLOW}[5/5] Verifying installation...${NC}"

if command -v nvim &> /dev/null; then
    INSTALLED_VERSION=$(nvim --version | head -n1)
    echo -e "${GREEN}✓ Neovim is properly installed${NC}"
    echo -e "${BLUE}  Version: $INSTALLED_VERSION${NC}"
else
    echo -e "${RED}✗ Neovim command not found after installation${NC}"
    exit 1
fi
echo ""

# Final summary
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Neovim installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

echo -e "${BLUE}Installation path:${NC}"
echo -e "${BLUE}  $(which nvim)${NC}"
echo ""
echo -e "${BLUE}Configuration:${NC}"
echo -e "${BLUE}  • Config directory: $TARGET_NVIM_CONFIG (symlinked)${NC}"
echo -e "${BLUE}  • Source directory: $DOTFILES_NVIM${NC}"
echo ""
if [ $BACKUP_COUNT -gt 0 ]; then
    echo -e "${YELLOW}Backups created:${NC}"
    for DIR in "${BACKUP_DIRS[@]}"; do
        BACKUP_TARGET="${DIR}${BACKUP_SUFFIX}"
        if [ -e "$BACKUP_TARGET" ]; then
            echo -e "${YELLOW}  • $BACKUP_TARGET${NC}"
        fi
    done
    echo ""
fi
echo -e "${YELLOW}Usage:${NC}"
echo -e "${YELLOW}  Start Neovim: nvim${NC}"
echo -e "${YELLOW}  Open a file: nvim filename${NC}"
echo ""
