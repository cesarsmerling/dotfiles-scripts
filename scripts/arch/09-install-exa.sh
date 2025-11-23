#!/bin/bash

###############################################################################
# Arch Linux Exa Installation Script
###############################################################################
# Description: Installs exa (modern replacement for ls) via cargo
# Reference: linux-install-notion.md - Line 212-224
# Dependencies: cargo (script 08-install-cargo.sh)
# Usage: ./09-install-exa.sh
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
EXA_BIN="$HOME/.cargo/bin/exa"

# Source cargo environment if it exists
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Exa Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check if cargo is installed
echo -e "${YELLOW}[1/3] Checking for cargo installation...${NC}"
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}✗ Cargo is not installed${NC}"
    echo -e "${YELLOW}Please run script 08-install-cargo.sh first${NC}"
    exit 1
fi

CARGO_VERSION=$(cargo --version)
echo -e "${GREEN}✓ Cargo found: $CARGO_VERSION${NC}"
echo ""

# Step 2: Check if exa is already installed
if command -v exa &> /dev/null; then
    EXA_VERSION=$(exa --version | head -n 1)
    echo -e "${YELLOW}Exa is already installed: $EXA_VERSION${NC}"
    echo -e "${YELLOW}Skipping installation${NC}"
    echo ""
    exit 0
fi

# Step 3: Install exa via cargo
echo -e "${YELLOW}[2/3] Installing exa via cargo...${NC}"
echo -e "${BLUE}Note: On Arch Linux, you can also install via 'sudo pacman -S exa'${NC}"
echo -e "${BLUE}Using cargo to get the latest version and match the documentation${NC}"
echo -e "${BLUE}This may take a few minutes as cargo compiles exa from source${NC}"
echo ""

if cargo install exa; then
    echo -e "${GREEN}✓ Exa installed successfully${NC}"
else
    echo -e "${RED}✗ Failed to install exa${NC}"
    exit 1
fi
echo ""

# Step 4: Verify exa installation
echo -e "${YELLOW}[3/3] Verifying exa installation...${NC}"
if command -v exa &> /dev/null; then
    EXA_VERSION=$(exa --version | head -n 1)
    echo -e "${GREEN}✓ Exa verified: $EXA_VERSION${NC}"
else
    echo -e "${RED}✗ Exa command not found after installation${NC}"
    exit 1
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Exa installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Exa binary location: $EXA_BIN${NC}"
echo -e "${BLUE}Version: $EXA_VERSION${NC}"
echo ""
echo -e "${YELLOW}Note: The alias for exa is already configured in your ~/.zshrc:${NC}"
echo -e "${BLUE}  alias ls='exa -a -l --color=always --icons --group-directories-first'${NC}"
echo ""
echo -e "${YELLOW}After sourcing your ~/.zshrc, 'ls' will use exa instead${NC}"
echo -e "${BLUE}  source ~/.zshrc${NC}"
