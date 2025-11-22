#!/bin/bash

# Script 06: Install and Configure Oh My Zsh
# This script installs Oh My Zsh and essential plugins (autosuggestions, syntax-highlighting)
# Dependencies: zsh, curl, git

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration variables
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OH_MY_ZSH_DIR/custom}"
TARGET_ZSHRC="$HOME/.zshrc"

# Plugin repositories
PLUGIN_AUTOSUGGESTIONS_REPO="https://github.com/zsh-users/zsh-autosuggestions"
PLUGIN_SYNTAX_REPO="https://github.com/zsh-users/zsh-syntax-highlighting"

# Plugin directories
PLUGIN_AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
PLUGIN_SYNTAX_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Plugins to enable
PLUGINS_TO_ENABLE="git zsh-autosuggestions zsh-syntax-highlighting"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Oh My Zsh Installation and Configuration${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check if Zsh is installed
echo -e "${YELLOW}[1/5] Checking Zsh installation...${NC}"
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}✗ Zsh is not installed${NC}"
    echo -e "${RED}  Please run script 05-install-zsh.sh first${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Zsh is installed${NC}"
echo ""

# Step 2: Install Oh My Zsh
echo -e "${YELLOW}[2/5] Installing Oh My Zsh...${NC}"
if [ -d "$OH_MY_ZSH_DIR" ]; then
    echo -e "${GREEN}✓ Oh My Zsh is already installed${NC}"
    echo -e "${BLUE}  Location: $OH_MY_ZSH_DIR${NC}"
else
    echo -e "${BLUE}  Downloading and installing Oh My Zsh...${NC}"

    # Install Oh My Zsh with KEEP_ZSHRC to preserve existing .zshrc
    # RUNZSH=no prevents automatic zsh launch after installation
    if KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
        echo -e "${GREEN}✓ Oh My Zsh installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to install Oh My Zsh${NC}"
        exit 1
    fi
fi
echo ""

# Step 3: Install zsh-autosuggestions plugin
echo -e "${YELLOW}[3/5] Installing zsh-autosuggestions plugin...${NC}"
if [ -d "$PLUGIN_AUTOSUGGESTIONS_DIR" ]; then
    echo -e "${GREEN}✓ zsh-autosuggestions is already installed${NC}"
    echo -e "${BLUE}  Updating to latest version...${NC}"
    cd "$PLUGIN_AUTOSUGGESTIONS_DIR"
    if git pull > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Plugin updated${NC}"
    else
        echo -e "${YELLOW}⚠ Could not update plugin (may be already up to date)${NC}"
    fi
else
    echo -e "${BLUE}  Cloning zsh-autosuggestions...${NC}"
    if git clone "$PLUGIN_AUTOSUGGESTIONS_REPO" "$PLUGIN_AUTOSUGGESTIONS_DIR"; then
        echo -e "${GREEN}✓ zsh-autosuggestions installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to clone zsh-autosuggestions${NC}"
        exit 1
    fi
fi
echo ""

# Step 4: Install zsh-syntax-highlighting plugin
echo -e "${YELLOW}[4/5] Installing zsh-syntax-highlighting plugin...${NC}"
if [ -d "$PLUGIN_SYNTAX_DIR" ]; then
    echo -e "${GREEN}✓ zsh-syntax-highlighting is already installed${NC}"
    echo -e "${BLUE}  Updating to latest version...${NC}"
    cd "$PLUGIN_SYNTAX_DIR"
    if git pull > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Plugin updated${NC}"
    else
        echo -e "${YELLOW}⚠ Could not update plugin (may be already up to date)${NC}"
    fi
else
    echo -e "${BLUE}  Cloning zsh-syntax-highlighting...${NC}"
    if git clone "$PLUGIN_SYNTAX_REPO" "$PLUGIN_SYNTAX_DIR"; then
        echo -e "${GREEN}✓ zsh-syntax-highlighting installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to clone zsh-syntax-highlighting${NC}"
        exit 1
    fi
fi
echo ""

# Step 5: Update .zshrc to enable plugins
echo -e "${YELLOW}[5/5] Configuring plugins in .zshrc...${NC}"

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

# Check if plugins line already exists and update it
if grep -q "^plugins=(" "$ACTUAL_ZSHRC"; then
    # Check if our plugins are already in the list
    if grep -q "zsh-autosuggestions" "$ACTUAL_ZSHRC" && grep -q "zsh-syntax-highlighting" "$ACTUAL_ZSHRC"; then
        echo -e "${GREEN}✓ Plugins are already configured in .zshrc${NC}"
    else
        echo -e "${BLUE}  Updating plugins line...${NC}"
        # Replace the plugins line with our desired plugins
        sed -i "s/^plugins=(.*/plugins=($PLUGINS_TO_ENABLE)/" "$ACTUAL_ZSHRC"
        echo -e "${GREEN}✓ Plugins configured successfully${NC}"
    fi
else
    echo -e "${BLUE}  Adding plugins line to .zshrc...${NC}"
    # Add plugins line before the Oh My Zsh source line
    if grep -q "source \$ZSH/oh-my-zsh.sh" "$ACTUAL_ZSHRC"; then
        sed -i "/source \$ZSH\/oh-my-zsh.sh/i plugins=($PLUGINS_TO_ENABLE)" "$ACTUAL_ZSHRC"
        echo -e "${GREEN}✓ Plugins line added successfully${NC}"
    else
        # If source line not found, add at the end
        echo "" >> "$ACTUAL_ZSHRC"
        echo "plugins=($PLUGINS_TO_ENABLE)" >> "$ACTUAL_ZSHRC"
        echo -e "${GREEN}✓ Plugins line added to end of file${NC}"
    fi
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Oh My Zsh installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Configuration:${NC}"
echo -e "${BLUE}  • Oh My Zsh: $OH_MY_ZSH_DIR${NC}"
echo -e "${BLUE}  • Custom plugins: $ZSH_CUSTOM/plugins${NC}"
echo -e "${BLUE}  • Enabled plugins: $PLUGINS_TO_ENABLE${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: Reload your shell to apply changes:${NC}"
echo -e "${YELLOW}  source ~/.zshrc${NC}"
echo -e "${YELLOW}Or restart your terminal${NC}"
echo ""
