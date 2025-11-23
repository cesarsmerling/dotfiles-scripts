#!/bin/bash

# Script 12: Install and Configure Neovim
# This script downloads Neovim AppImage (v0.11.5) for x86_64, extracts it (FUSE-free),
# backs up existing config, and symlinks dotfiles
# Dependencies: curl

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
NVIM_VERSION="v0.11.5"
APPIMAGE_NAME="nvim-linux-x86_64.appimage"
NVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${APPIMAGE_NAME}"
DOWNLOAD_DIR="/tmp/nvim-install"
INSTALL_DIR="/opt/nvim"
INSTALL_PATH="/usr/local/bin/nvim"
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

# Step 1: Check dependencies
echo -e "${YELLOW}[1/6] Checking dependencies...${NC}"
if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not installed${NC}"
    echo -e "${RED}  Please install it first: sudo apt install curl${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All dependencies are installed${NC}"
echo ""

# Step 2: Download Neovim AppImage
echo -e "${YELLOW}[2/6] Downloading Neovim AppImage...${NC}"

# Create download directory
if [ -d "$DOWNLOAD_DIR" ]; then
    rm -rf "$DOWNLOAD_DIR"
    echo -e "${BLUE}  Cleaned existing download directory${NC}"
fi

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Download AppImage
if curl -Lo "$APPIMAGE_NAME" "$NVIM_DOWNLOAD_URL"; then
    echo -e "${GREEN}✓ Download completed successfully${NC}"
    echo -e "${BLUE}  File: $DOWNLOAD_DIR/$APPIMAGE_NAME${NC}"

    # Validate the downloaded file
    FILE_SIZE=$(stat -c%s "$APPIMAGE_NAME" 2>/dev/null || stat -f%z "$APPIMAGE_NAME" 2>/dev/null)
    echo -e "${BLUE}  File size: ${FILE_SIZE} bytes${NC}"

    # Check if file is too small (likely an error page)
    if [ "$FILE_SIZE" -lt 1000000 ]; then
        echo -e "${RED}✗ Downloaded file is too small (< 1MB)${NC}"
        echo -e "${RED}  This is likely an error page, not a valid AppImage${NC}"
        echo -e "${RED}  URL attempted: $NVIM_DOWNLOAD_URL${NC}"
        echo ""
        echo -e "${YELLOW}First few lines of the downloaded file:${NC}"
        head -n 5 "$APPIMAGE_NAME"
        exit 1
    fi

    echo -e "${GREEN}✓ File validation passed${NC}"
else
    echo -e "${RED}✗ Failed to download Neovim${NC}"
    echo -e "${RED}  Please check your internet connection${NC}"
    exit 1
fi
echo ""

# Step 3: Extract and Install Neovim
echo -e "${YELLOW}[3/6] Extracting and installing Neovim...${NC}"

# Make AppImage executable
if chmod u+x "$APPIMAGE_NAME"; then
    echo -e "${GREEN}✓ Made AppImage executable${NC}"
else
    echo -e "${RED}✗ Failed to make AppImage executable${NC}"
    exit 1
fi

# Check if nvim is already installed
if command -v nvim &> /dev/null; then
    CURRENT_VERSION=$(nvim --version | head -n1)
    echo -e "${BLUE}  Current installation found: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  Upgrading to version ${NVIM_VERSION}...${NC}"
fi

# Extract AppImage (FUSE-free method)
echo -e "${BLUE}  Extracting AppImage...${NC}"
if ./"$APPIMAGE_NAME" --appimage-extract > /dev/null 2>&1; then
    echo -e "${GREEN}✓ AppImage extracted successfully${NC}"
else
    echo -e "${RED}✗ Failed to extract AppImage${NC}"
    exit 1
fi

# Remove old installation if exists
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${BLUE}  Removing old installation...${NC}"
    sudo rm -rf "$INSTALL_DIR"
fi

# Move extracted files to /opt/nvim
if sudo mv squashfs-root "$INSTALL_DIR"; then
    echo -e "${GREEN}✓ Moved extracted files to $INSTALL_DIR${NC}"
else
    echo -e "${RED}✗ Failed to move extracted files${NC}"
    exit 1
fi

# Remove old symlink if exists
if [ -L "$INSTALL_PATH" ] || [ -f "$INSTALL_PATH" ]; then
    echo -e "${BLUE}  Removing old nvim symlink/file...${NC}"
    sudo rm -f "$INSTALL_PATH"
fi

# Create symlink in /usr/local/bin
if sudo ln -s "$INSTALL_DIR/usr/bin/nvim" "$INSTALL_PATH"; then
    echo -e "${GREEN}✓ Neovim installed successfully${NC}"
    echo -e "${BLUE}  Location: $INSTALL_PATH -> $INSTALL_DIR/usr/bin/nvim${NC}"
else
    echo -e "${RED}✗ Failed to create symlink${NC}"
    exit 1
fi
echo ""

# Step 4: Backup existing Neovim configurations
echo -e "${YELLOW}[4/6] Backing up existing Neovim configurations...${NC}"
BACKUP_COUNT=0

for DIR in "${BACKUP_DIRS[@]}"; do
    if [ -e "$DIR" ] && [ ! -L "$DIR" ]; then
        BACKUP_TARGET="${DIR}${BACKUP_SUFFIX}"
        echo -e "${BLUE}  Backing up: $DIR${NC}"
        if mv "$DIR" "$BACKUP_TARGET"; then
            echo -e "${GREEN}  ✓ Backup created: $BACKUP_TARGET${NC}"
            ((BACKUP_COUNT++))
        else
            echo -e "${RED}  ✗ Failed to backup: $DIR${NC}"
        fi
    elif [ -L "$DIR" ]; then
        echo -e "${BLUE}  Removing symlink: $DIR${NC}"
        rm "$DIR"
        echo -e "${GREEN}  ✓ Symlink removed${NC}"
        ((BACKUP_COUNT++))
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

# Step 5: Create symlink to dotfiles nvim config
echo -e "${YELLOW}[5/6] Creating symlink to dotfiles configuration...${NC}"

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

# Step 6: Cleanup
echo -e "${YELLOW}[6/6] Cleaning up temporary files...${NC}"
cd ~
if rm -rf "$DOWNLOAD_DIR"; then
    echo -e "${GREEN}✓ Temporary files removed${NC}"
else
    echo -e "${YELLOW}⚠ Failed to remove temporary files${NC}"
    echo -e "${YELLOW}  You may want to manually remove: $DOWNLOAD_DIR${NC}"
fi
echo ""

# Verify installation
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Neovim installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

if command -v nvim &> /dev/null; then
    INSTALLED_VERSION=$(nvim --version | head -n1)
    echo -e "${BLUE}Installed version:${NC}"
    echo -e "${BLUE}  $INSTALLED_VERSION${NC}"
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
else
    echo -e "${RED}✗ Neovim command not found${NC}"
    echo -e "${RED}  Installation may have failed${NC}"
    exit 1
fi
echo ""
