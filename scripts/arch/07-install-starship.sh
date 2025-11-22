#!/bin/bash

# Script 07: Install and Configure Starship Prompt
# This script installs Starship, configures it in .zshrc, and symlinks the config file
# Dependencies: zsh, curl

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration variables
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTFILES_STARSHIP="$REPO_DIR/dotfiles/starship/starship.toml"
TARGET_CONFIG_DIR="$HOME/.config"
TARGET_STARSHIP="$TARGET_CONFIG_DIR/starship.toml"
BACKUP_STARSHIP="$TARGET_CONFIG_DIR/starship.toml.backup"
TARGET_ZSHRC="$HOME/.zshrc"
STARSHIP_INIT_LINE='eval "$(starship init zsh)"'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Starship Prompt Installation${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check dependencies
echo -e "${YELLOW}[1/6] Checking dependencies...${NC}"
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}✗ Zsh is not installed${NC}"
    echo -e "${RED}  Please run script 05-install-zsh.sh first${NC}"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All dependencies are installed${NC}"
echo ""

# Step 2: Install Starship
echo -e "${YELLOW}[2/6] Installing Starship...${NC}"
if command -v starship &> /dev/null; then
    STARSHIP_VERSION=$(starship --version | head -n1)
    echo -e "${GREEN}✓ Starship is already installed${NC}"
    echo -e "${BLUE}  Version: $STARSHIP_VERSION${NC}"
else
    echo -e "${BLUE}  Downloading and installing Starship...${NC}"
    if curl -sS https://starship.rs/install.sh | sh -s -- --yes > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Starship installed successfully${NC}"
        STARSHIP_VERSION=$(starship --version | head -n1)
        echo -e "${BLUE}  Version: $STARSHIP_VERSION${NC}"
    else
        echo -e "${RED}✗ Failed to install Starship${NC}"
        exit 1
    fi
fi
echo ""

# Step 3: Add Starship init to .zshrc
echo -e "${YELLOW}[3/6] Configuring Starship in .zshrc...${NC}"

# Determine the actual file to modify (follow symlink if needed)
if [ -L "$TARGET_ZSHRC" ]; then
    ACTUAL_ZSHRC=$(readlink -f "$TARGET_ZSHRC")
    echo -e "${BLUE}  Detected symlink, modifying: $ACTUAL_ZSHRC${NC}"
else
    ACTUAL_ZSHRC="$TARGET_ZSHRC"
    echo -e "${BLUE}  Modifying: $ACTUAL_ZSHRC${NC}"
fi

if [ ! -f "$ACTUAL_ZSHRC" ]; then
    echo -e "${RED}✗ .zshrc file not found${NC}"
    exit 1
fi

# Check if Starship init line already exists
if grep -Fq "$STARSHIP_INIT_LINE" "$ACTUAL_ZSHRC"; then
    echo -e "${GREEN}✓ Starship is already configured in .zshrc${NC}"
else
    echo -e "${BLUE}  Adding Starship init line to .zshrc...${NC}"
    # Add init line at the end of the file
    echo "" >> "$ACTUAL_ZSHRC"
    echo "# Starship prompt" >> "$ACTUAL_ZSHRC"
    echo "$STARSHIP_INIT_LINE" >> "$ACTUAL_ZSHRC"
    echo -e "${GREEN}✓ Starship init line added successfully${NC}"
fi
echo ""

# Step 4: Create .config directory if it doesn't exist
echo -e "${YELLOW}[4/6] Ensuring config directory exists...${NC}"
if [ ! -d "$TARGET_CONFIG_DIR" ]; then
    mkdir -p "$TARGET_CONFIG_DIR"
    echo -e "${GREEN}✓ Created directory: $TARGET_CONFIG_DIR${NC}"
else
    echo -e "${GREEN}✓ Directory already exists: $TARGET_CONFIG_DIR${NC}"
fi
echo ""

# Step 5: Backup existing starship.toml if it exists
echo -e "${YELLOW}[5/6] Creating symlink to dotfiles configuration...${NC}"
if [ -f "$TARGET_STARSHIP" ] && [ ! -L "$TARGET_STARSHIP" ]; then
    echo -e "${BLUE}  Found existing starship.toml, creating backup...${NC}"
    mv "$TARGET_STARSHIP" "$BACKUP_STARSHIP"
    echo -e "${GREEN}✓ Backup created: $BACKUP_STARSHIP${NC}"
elif [ -L "$TARGET_STARSHIP" ]; then
    echo -e "${BLUE}  Existing symlink found, removing...${NC}"
    rm "$TARGET_STARSHIP"
    echo -e "${GREEN}✓ Old symlink removed${NC}"
fi

# Create symlink to dotfiles starship.toml
if [ -f "$DOTFILES_STARSHIP" ]; then
    if ln -s "$DOTFILES_STARSHIP" "$TARGET_STARSHIP"; then
        echo -e "${GREEN}✓ Symlink created successfully${NC}"
        echo -e "${BLUE}  Source: $DOTFILES_STARSHIP${NC}"
        echo -e "${BLUE}  Target: $TARGET_STARSHIP${NC}"
    else
        echo -e "${RED}✗ Failed to create symlink${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Dotfiles starship.toml not found at: $DOTFILES_STARSHIP${NC}"
    echo -e "${RED}  Please ensure the dotfiles repository is cloned correctly${NC}"
    exit 1
fi
echo ""

# Step 6: Source .zshrc
echo -e "${YELLOW}[6/6] Applying configuration...${NC}"
if [ -n "$ZSH_VERSION" ]; then
    # We're running in zsh, can source directly
    if source "$ACTUAL_ZSHRC" 2>/dev/null; then
        echo -e "${GREEN}✓ Configuration loaded successfully${NC}"
    else
        echo -e "${YELLOW}⚠ Could not source .zshrc in current shell${NC}"
        echo -e "${YELLOW}  This is normal if running from bash${NC}"
    fi
else
    # We're in bash or another shell
    echo -e "${YELLOW}⚠ Not running in zsh, skipping source${NC}"
    echo -e "${YELLOW}  Configuration will be loaded when you start zsh${NC}"
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Starship installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Configuration:${NC}"
echo -e "${BLUE}  • Starship binary: $(which starship)${NC}"
echo -e "${BLUE}  • Config file: $TARGET_STARSHIP (symlinked)${NC}"
echo -e "${BLUE}  • Source file: $DOTFILES_STARSHIP${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: Reload your shell to see the new prompt:${NC}"
echo -e "${YELLOW}  source ~/.zshrc${NC}"
echo -e "${YELLOW}Or restart your terminal${NC}"
echo ""
echo -e "${BLUE}Troubleshooting: If Starship doesn't start, run:${NC}"
echo -e "${BLUE}  set +x${NC}"
echo -e "${BLUE}  rm ~/.zcompdump*${NC}"
echo -e "${BLUE}  compinit${NC}"
echo ""
