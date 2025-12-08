#!/bin/bash

# Script 18: Install Claude Code
# This script installs Claude Code CLI using the official installation script
# Claude Code is Anthropic's official CLI tool for interacting with Claude AI
# Dependencies: curl, bash

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation URL
INSTALL_URL="https://claude.ai/install.sh"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Claude Code Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check prerequisites
echo -e "${YELLOW}[1/3] Checking prerequisites...${NC}"
if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not installed${NC}"
    echo -e "${YELLOW}  Installing curl...${NC}"
    sudo apt update && sudo apt install -y curl
    echo -e "${GREEN}✓ curl installed${NC}"
else
    echo -e "${GREEN}✓ curl is already installed${NC}"
fi
echo ""

# Step 2: Download and run installation script
echo -e "${YELLOW}[2/3] Installing Claude Code...${NC}"
echo -e "${BLUE}  Downloading from: $INSTALL_URL${NC}"
echo ""

if curl -fsSL "$INSTALL_URL" | bash; then
    echo ""
    echo -e "${GREEN}✓ Claude Code installed successfully${NC}"
else
    echo ""
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi
echo ""

# Step 3: Verify installation
echo -e "${YELLOW}[3/3] Verifying installation...${NC}"
if command -v claude-code &> /dev/null; then
    CLAUDE_VERSION=$(claude-code --version 2>&1 || echo "version check unavailable")
    echo -e "${GREEN}✓ Claude Code is installed${NC}"
    echo -e "${BLUE}  Version: $CLAUDE_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ Claude Code command not found in PATH${NC}"
    echo -e "${YELLOW}  You may need to restart your terminal or source your shell configuration${NC}"
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "${BLUE}  1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)${NC}"
echo -e "${BLUE}  2. Run 'claude-code --help' to see available commands${NC}"
echo -e "${BLUE}  3. Run 'claude-code' to start using Claude Code${NC}"
echo ""
