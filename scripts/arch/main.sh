#!/bin/bash

###############################################################################
# Arch Linux Main Installation Script
###############################################################################
# Description: Main script that runs all Arch Linux setup scripts
# Reference: linux-install-notion.md
# Usage: ./main.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}       Arch Linux Setup Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Request sudo privileges upfront
echo -e "${YELLOW}Requesting sudo privileges...${NC}"
sudo -v
echo -e "${GREEN}✓ Sudo privileges granted${NC}"
echo ""

# Keep sudo alive: update existing sudo time stamp until the script finishes
# This runs in the background and updates sudo every 60 seconds
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

echo -e "${BLUE}Starting installation scripts...${NC}"
echo ""

###############################################################################
# Run installation scripts in order
###############################################################################

# 01 - System Update and Upgrade
if [ -f "$SCRIPT_DIR/01-update-upgrade.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 01-update-upgrade.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/01-update-upgrade.sh"
    echo ""
else
    echo -e "${RED}Warning: 01-update-upgrade.sh not found, skipping...${NC}"
    echo ""
fi

# 02 - Install Utilities
if [ -f "$SCRIPT_DIR/02-install-utilities.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 02-install-utilities.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/02-install-utilities.sh"
    echo ""
else
    echo -e "${RED}Warning: 02-install-utilities.sh not found, skipping...${NC}"
    echo ""
fi

# 03 - Install Fonts
if [ -f "$SCRIPT_DIR/03-install-fonts.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 03-install-fonts.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/03-install-fonts.sh"
    echo ""
else
    echo -e "${RED}Warning: 03-install-fonts.sh not found, skipping...${NC}"
    echo ""
fi

# 04 - Install Kitty Terminal
if [ -f "$SCRIPT_DIR/04-install-kitty.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 04-install-kitty.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/04-install-kitty.sh"
    echo ""
else
    echo -e "${RED}Warning: 04-install-kitty.sh not found, skipping...${NC}"
    echo ""
fi

# 05 - Install Zsh
if [ -f "$SCRIPT_DIR/05-install-zsh.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 05-install-zsh.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/05-install-zsh.sh"
    echo ""
else
    echo -e "${RED}Warning: 05-install-zsh.sh not found, skipping...${NC}"
    echo ""
fi

# 06 - Install Oh My Zsh
if [ -f "$SCRIPT_DIR/06-install-oh-my-zsh.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 06-install-oh-my-zsh.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/06-install-oh-my-zsh.sh"
    echo ""
else
    echo -e "${RED}Warning: 06-install-oh-my-zsh.sh not found, skipping...${NC}"
    echo ""
fi

# 07 - Install Starship
if [ -f "$SCRIPT_DIR/07-install-starship.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 07-install-starship.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/07-install-starship.sh"
    echo ""
else
    echo -e "${RED}Warning: 07-install-starship.sh not found, skipping...${NC}"
    echo ""
fi

# 08 - Install Cargo (Rust)
if [ -f "$SCRIPT_DIR/08-install-cargo.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 08-install-cargo.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/08-install-cargo.sh"
    echo ""
else
    echo -e "${RED}Warning: 08-install-cargo.sh not found, skipping...${NC}"
    echo ""
fi

# 09 - Install Exa
if [ -f "$SCRIPT_DIR/09-install-exa.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 09-install-exa.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/09-install-exa.sh"
    echo ""
else
    echo -e "${RED}Warning: 09-install-exa.sh not found, skipping...${NC}"
    echo ""
fi

# 10 - Install Yazi
if [ -f "$SCRIPT_DIR/10-install-yazi.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 10-install-yazi.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/10-install-yazi.sh"
    echo ""
else
    echo -e "${RED}Warning: 10-install-yazi.sh not found, skipping...${NC}"
    echo ""
fi

# 11 - Install LazyGit
if [ -f "$SCRIPT_DIR/11-install-lazygit.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 11-install-lazygit.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/11-install-lazygit.sh"
    echo ""
else
    echo -e "${RED}Warning: 11-install-lazygit.sh not found, skipping...${NC}"
    echo ""
fi

# 12 - Install Neovim
if [ -f "$SCRIPT_DIR/12-install-neovim.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 12-install-neovim.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/12-install-neovim.sh"
    echo ""
else
    echo -e "${RED}Warning: 12-install-neovim.sh not found, skipping...${NC}"
    echo ""
fi

# 13 - Install VSCode
if [ -f "$SCRIPT_DIR/13-install-vscode.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 13-install-vscode.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/13-install-vscode.sh"
    echo ""
else
    echo -e "${RED}Warning: 13-install-vscode.sh not found, skipping...${NC}"
    echo ""
fi

# 14 - Install Brave Browser
if [ -f "$SCRIPT_DIR/14-install-brave.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 14-install-brave.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/14-install-brave.sh"
    echo ""
else
    echo -e "${RED}Warning: 14-install-brave.sh not found, skipping...${NC}"
    echo ""
fi

# 15 - Install Docker
if [ -f "$SCRIPT_DIR/15-install-docker.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 15-install-docker.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/15-install-docker.sh"
    echo ""
else
    echo -e "${RED}Warning: 15-install-docker.sh not found, skipping...${NC}"
    echo ""
fi

# 16 - Install FNM and Node.js
if [ -f "$SCRIPT_DIR/16-install-fnm-node.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 16-install-fnm-node.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/16-install-fnm-node.sh"
    echo ""
else
    echo -e "${RED}Warning: 16-install-fnm-node.sh not found, skipping...${NC}"
    echo ""
fi

# 17 - Install Go
if [ -f "$SCRIPT_DIR/17-install-go.sh" ]; then
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Running: 17-install-go.sh${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    bash "$SCRIPT_DIR/17-install-go.sh"
    echo ""
else
    echo -e "${RED}Warning: 17-install-go.sh not found, skipping...${NC}"
    echo ""
fi

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ All installation scripts completed!${NC}"
echo -e "${GREEN}============================================${NC}"
