#!/bin/bash

###############################################################################
# Ubuntu/Pop_OS Utilities Installation Script
###############################################################################
# Description: Installs build-essential and essential utilities/command-line tools
# Reference: linux-install-notion.md - Line 17-21
# Usage: ./02-install-utilities.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Repository directory
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Installing essential utilities...${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Array of packages to install (one per line for readability)
PACKAGES=(
    curl
    wget
    build-essential
    ffmpeg
    p7zip-full
    jq
    poppler-utils
    fd-find
    ripgrep
    fzf
    zoxide
    imagemagick
    bat
    x11-xserver-utils
)

# Display packages to be installed
echo -e "${YELLOW}The following packages will be installed:${NC}"
for package in "${PACKAGES[@]}"; do
    echo -e "  ${BLUE}- $package${NC}"
done
echo ""

# Install each package
echo -e "${YELLOW}Installing packages...${NC}"
for package in "${PACKAGES[@]}"; do
    echo -e "${BLUE}  Installing $package...${NC}"
    sudo apt install -y "$package"
    echo -e "${GREEN}  ✓ $package installed${NC}"
done

echo ""

# Post-installation configuration
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Post-installation configuration${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Create ~/.local/bin directory if it doesn't exist
LOCAL_BIN="$HOME/.local/bin"
if [ ! -d "$LOCAL_BIN" ]; then
    echo -e "${YELLOW}Creating $LOCAL_BIN directory...${NC}"
    mkdir -p "$LOCAL_BIN"
    echo -e "${GREEN}✓ Directory created${NC}"
else
    echo -e "${GREEN}✓ $LOCAL_BIN directory already exists${NC}"
fi
echo ""

# Create symlink for fd-find
echo -e "${YELLOW}Creating symlink for fd-find...${NC}"
echo -e "${BLUE}  fd-find is installed as 'fdfind', creating 'fd' symlink${NC}"

FDFIND_PATH=$(which fdfind)
FD_SYMLINK="$LOCAL_BIN/fd"

if [ -L "$FD_SYMLINK" ]; then
    echo -e "${BLUE}  Removing existing symlink${NC}"
    rm "$FD_SYMLINK"
fi

if ln -s "$FDFIND_PATH" "$FD_SYMLINK"; then
    echo -e "${GREEN}✓ Symlink created: $FD_SYMLINK -> $FDFIND_PATH${NC}"
    echo -e "${BLUE}  You can now use 'fd' command${NC}"
else
    echo -e "${RED}✗ Failed to create symlink${NC}"
fi
echo ""

# Create symlink for fzf-git
echo -e "${YELLOW}Creating symlink for fzf-git...${NC}"
CONFIG_DIR="$HOME/.config"
FZF_GIT_CONFIG_DIR="$CONFIG_DIR/fzf-git"
DOTFILES_FZF_GIT="$REPO_DIR/dotfiles/fzf-git"

# Check if dotfiles/fzf-git exists in repository
if [ ! -d "$DOTFILES_FZF_GIT" ]; then
    echo -e "${RED}✗ Dotfiles fzf-git folder not found at: $DOTFILES_FZF_GIT${NC}"
    echo -e "${YELLOW}  Skipping fzf-git configuration linking step${NC}"
else
    # Create ~/.config directory if it doesn't exist
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
        echo -e "${GREEN}✓ Created directory: $CONFIG_DIR${NC}"
    fi

    # Handle existing fzf-git config directory
    if [ -e "$FZF_GIT_CONFIG_DIR" ]; then
        if [ -L "$FZF_GIT_CONFIG_DIR" ]; then
            # It's already a symlink, remove it
            rm "$FZF_GIT_CONFIG_DIR"
            echo -e "${YELLOW}  Removed existing symlink: $FZF_GIT_CONFIG_DIR${NC}"
        else
            # It's a real directory or file, backup it
            BACKUP_DIR="$FZF_GIT_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$FZF_GIT_CONFIG_DIR" "$BACKUP_DIR"
            echo -e "${YELLOW}  Backed up existing config to: $BACKUP_DIR${NC}"
        fi
    fi

    # Create the symlink
    if ln -s "$DOTFILES_FZF_GIT" "$FZF_GIT_CONFIG_DIR"; then
        echo -e "${GREEN}✓ Created symlink: $FZF_GIT_CONFIG_DIR -> $DOTFILES_FZF_GIT${NC}"
        echo -e "${BLUE}  fzf-git script location: $FZF_GIT_CONFIG_DIR/fzf-git.sh${NC}"
    else
        echo -e "${RED}✗ Failed to create symlink${NC}"
    fi
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ All utilities installed successfully!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}Note: Aliases for bat and fzf are configured in your dotfiles${NC}"
