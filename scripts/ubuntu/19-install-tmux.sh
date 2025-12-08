#!/bin/bash

# Script 19: Install tmux
# This script installs tmux, copies configuration files, and sets up TPM (Tmux Plugin Manager)
# Dependencies: git
# Reference: https://github.com/tmux-plugins/tpm

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Repository directory
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Configuration paths
TMUX_CONFIG_DIR="$HOME/.config/tmux"
TMUX_PLUGINS_DIR="$HOME/.tmux/plugins"
TPM_REPO="https://github.com/tmux-plugins/tpm"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  tmux Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Install tmux
echo -e "${YELLOW}[1/4] Installing tmux...${NC}"
if command -v tmux &> /dev/null; then
    TMUX_VERSION=$(tmux -V)
    echo -e "${GREEN}✓ tmux is already installed: $TMUX_VERSION${NC}"
else
    echo -e "${BLUE}  Installing tmux via apt...${NC}"
    sudo apt update
    sudo apt install -y tmux
    TMUX_VERSION=$(tmux -V)
    echo -e "${GREEN}✓ tmux installed: $TMUX_VERSION${NC}"
fi
echo ""

# Step 2: Copy configuration files
echo -e "${YELLOW}[2/4] Setting up tmux configuration...${NC}"
if [ ! -d "$REPO_DIR/dotfiles/tmux" ]; then
    echo -e "${RED}✗ Configuration directory not found: $REPO_DIR/dotfiles/tmux${NC}"
    exit 1
fi

# Create tmux config directory
if [ ! -d "$TMUX_CONFIG_DIR" ]; then
    mkdir -p "$TMUX_CONFIG_DIR"
    echo -e "${GREEN}✓ Created directory: $TMUX_CONFIG_DIR${NC}"
else
    echo -e "${GREEN}✓ Directory already exists: $TMUX_CONFIG_DIR${NC}"
fi

# Copy configuration files
echo -e "${BLUE}  Copying configuration files...${NC}"
cp -r "$REPO_DIR/dotfiles/tmux/"* "$TMUX_CONFIG_DIR/"
echo -e "${GREEN}✓ Configuration files copied to $TMUX_CONFIG_DIR${NC}"
echo ""

# Step 3: Clone TPM (Tmux Plugin Manager)
echo -e "${YELLOW}[3/4] Installing TPM (Tmux Plugin Manager)...${NC}"
if [ -d "$TMUX_PLUGINS_DIR/tpm" ]; then
    echo -e "${BLUE}  TPM already exists, updating...${NC}"
    cd "$TMUX_PLUGINS_DIR/tpm"
    git pull
    echo -e "${GREEN}✓ TPM updated${NC}"
else
    echo -e "${BLUE}  Cloning TPM repository...${NC}"
    mkdir -p "$TMUX_PLUGINS_DIR"
    git clone "$TPM_REPO" "$TMUX_PLUGINS_DIR/tpm"
    echo -e "${GREEN}✓ TPM installed at $TMUX_PLUGINS_DIR/tpm${NC}"
fi
echo ""

# Step 4: Display next steps
echo -e "${YELLOW}[4/4] Configuration files:${NC}"
if [ -f "$TMUX_CONFIG_DIR/tmux.conf" ]; then
    echo -e "${GREEN}✓ tmux.conf${NC}"
fi
if [ -f "$TMUX_CONFIG_DIR/tmux.reset.conf" ]; then
    echo -e "${GREEN}✓ tmux.reset.conf${NC}"
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ tmux installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Configuration location: $TMUX_CONFIG_DIR${NC}"
echo -e "${BLUE}TPM location: $TMUX_PLUGINS_DIR/tpm${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "${YELLOW}  1. Start tmux: ${NC}tmux"
echo -e "${YELLOW}  2. Install plugins: Press ${NC}Ctrl+a + Shift+I"
echo -e "${YELLOW}  3. Reload configuration: Press ${NC}Ctrl+a + r"
echo ""
