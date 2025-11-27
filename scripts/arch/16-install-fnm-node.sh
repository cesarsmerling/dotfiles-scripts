#!/bin/bash

###############################################################################
# Arch Linux FNM, Node.js, npm, and pnpm Installation Script
###############################################################################
# Description: Installs fnm (Fast Node Manager), Node.js v24, npm, and pnpm
# Reference: linux-install-notion.md - Lines 279-289
# Usage: ./16-install-fnm-node.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# FNM and Node.js installation variables
FNM_INSTALL_URL="https://fnm.vercel.app/install"
FNM_DIR="$HOME/.local/share/fnm"
NODE_VERSION="24"
PNPM_INSTALL_URL="https://get.pnpm.io/install.sh"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  FNM, Node.js & pnpm Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

###############################################################################
# Step 1: Check if FNM is already installed
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [1/5] Checking existing FNM installation${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

if command -v fnm &> /dev/null; then
    FNM_CURRENT_VERSION=$(fnm --version 2>&1 | head -n 1)
    echo -e "${YELLOW}FNM is already installed: $FNM_CURRENT_VERSION${NC}"
    echo -e "${YELLOW}FNM directory: $FNM_DIR${NC}"
    read -p "Do you want to reinstall/update FNM? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Skipping FNM installation${NC}"
        SKIP_FNM_INSTALL=true
    else
        echo -e "${YELLOW}Proceeding with FNM reinstallation...${NC}"
    fi
else
    echo -e "${GREEN}✓ No existing FNM installation found${NC}"
fi
echo ""

###############################################################################
# Step 2: Download and install FNM
###############################################################################

if [ "$SKIP_FNM_INSTALL" != "true" ]; then
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  [2/5] Installing FNM${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""

    echo -e "${YELLOW}Downloading and installing FNM...${NC}"
    echo -e "${BLUE}  URL: $FNM_INSTALL_URL${NC}"
    echo ""

    if curl -fsSL "$FNM_INSTALL_URL" | bash; then
        echo ""
        echo -e "${GREEN}✓ FNM installed successfully${NC}"
    else
        echo ""
        echo -e "${RED}✗ Failed to install FNM${NC}"
        exit 1
    fi
    echo ""
else
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  [2/5] Using existing FNM installation${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo ""
fi

###############################################################################
# Step 3: Load FNM and install Node.js
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [3/5] Installing Node.js v${NODE_VERSION}${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Load fnm into current session
echo -e "${YELLOW}Loading FNM into current session...${NC}"
export PATH="$HOME/.local/share/fnm:$PATH"
if [ -d "$FNM_DIR" ]; then
    eval "$(fnm env --use-on-cd)"
    echo -e "${GREEN}✓ FNM loaded successfully${NC}"
else
    echo -e "${RED}✗ Failed to load FNM${NC}"
    echo -e "${YELLOW}  FNM directory not found at: $FNM_DIR${NC}"
    exit 1
fi
echo ""

# Check if Node.js version is already installed
if fnm list | grep -q "v${NODE_VERSION}"; then
    echo -e "${YELLOW}Node.js v${NODE_VERSION} is already installed${NC}"
    read -p "Do you want to reinstall Node.js v${NODE_VERSION}? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Using existing Node.js installation${NC}"
        fnm use "$NODE_VERSION"
        SKIP_NODE_INSTALL=true
    fi
fi

if [ "$SKIP_NODE_INSTALL" != "true" ]; then
    echo -e "${YELLOW}Installing Node.js v${NODE_VERSION}...${NC}"
    echo -e "${BLUE}  This may take a few minutes${NC}"
    echo ""

    if fnm install "$NODE_VERSION"; then
        echo ""
        echo -e "${GREEN}✓ Node.js v${NODE_VERSION} installed successfully${NC}"

        # Set as default
        echo -e "${YELLOW}Setting Node.js v${NODE_VERSION} as default...${NC}"
        fnm default "$NODE_VERSION"
        fnm use default
        echo -e "${GREEN}✓ Node.js v${NODE_VERSION} set as default${NC}"
    else
        echo ""
        echo -e "${RED}✗ Failed to install Node.js v${NODE_VERSION}${NC}"
        exit 1
    fi
fi
echo ""

###############################################################################
# Step 4: Install pnpm
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [4/5] Installing pnpm${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if pnpm is already installed
if command -v pnpm &> /dev/null; then
    PNPM_CURRENT_VERSION=$(pnpm --version)
    echo -e "${YELLOW}pnpm is already installed: v$PNPM_CURRENT_VERSION${NC}"
    read -p "Do you want to reinstall/update pnpm? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Skipping pnpm installation${NC}"
        SKIP_PNPM_INSTALL=true
    fi
fi

if [ "$SKIP_PNPM_INSTALL" != "true" ]; then
    echo -e "${YELLOW}Downloading and installing pnpm...${NC}"
    echo -e "${BLUE}  URL: $PNPM_INSTALL_URL${NC}"
    echo ""

    if curl -fsSL "$PNPM_INSTALL_URL" | sh -; then
        echo ""
        echo -e "${GREEN}✓ pnpm installed successfully${NC}"
    else
        echo ""
        echo -e "${RED}✗ Failed to install pnpm${NC}"
        echo -e "${YELLOW}  You can try installing manually with: npm install -g pnpm${NC}"
    fi
fi
echo ""

###############################################################################
# Step 5: Verify installations
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [5/5] Verifying installations${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Reload environment for verification
export PATH="$HOME/.local/share/fnm:$HOME/.local/share/pnpm:$PATH"
eval "$(fnm env --use-on-cd)" 2>/dev/null || true

# Verify FNM
echo -e "${YELLOW}Verifying FNM...${NC}"
if command -v fnm &> /dev/null; then
    FNM_FINAL_VERSION=$(fnm --version 2>&1 | head -n 1)
    echo -e "${GREEN}✓ FNM version: ${FNM_FINAL_VERSION}${NC}"
else
    echo -e "${RED}✗ FNM command not found${NC}"
fi
echo ""

# Verify Node.js
echo -e "${YELLOW}Verifying Node.js...${NC}"
if command -v node &> /dev/null; then
    NODE_FINAL_VERSION=$(node -v)
    echo -e "${GREEN}✓ Node.js version: ${NODE_FINAL_VERSION}${NC}"

    # Check if it matches expected version
    if [[ "$NODE_FINAL_VERSION" == v24.* ]]; then
        echo -e "${GREEN}✓ Node.js v24 installed correctly${NC}"
    else
        echo -e "${YELLOW}  Note: Expected v24.x.x, got ${NODE_FINAL_VERSION}${NC}"
    fi
else
    echo -e "${RED}✗ Node.js not found${NC}"
fi
echo ""

# Verify npm
echo -e "${YELLOW}Verifying npm...${NC}"
if command -v npm &> /dev/null; then
    NPM_FINAL_VERSION=$(npm -v)
    echo -e "${GREEN}✓ npm version: v${NPM_FINAL_VERSION}${NC}"
else
    echo -e "${RED}✗ npm not found${NC}"
fi
echo ""

# Verify pnpm
echo -e "${YELLOW}Verifying pnpm...${NC}"
if command -v pnpm &> /dev/null; then
    PNPM_FINAL_VERSION=$(pnpm --version)
    echo -e "${GREEN}✓ pnpm version: v${PNPM_FINAL_VERSION}${NC}"
else
    echo -e "${RED}✗ pnpm not found${NC}"
fi
echo ""

###############################################################################
# Final Steps and Information
###############################################################################

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

echo -e "${BLUE}Installed components:${NC}"
if command -v fnm &> /dev/null; then
    echo -e "${GREEN}  ✓ FNM: $(fnm --version 2>&1 | head -n 1)${NC}"
else
    echo -e "${RED}  ✗ FNM: Not found${NC}"
fi

if command -v node &> /dev/null; then
    echo -e "${GREEN}  ✓ Node.js: $(node -v)${NC}"
else
    echo -e "${RED}  ✗ Node.js: Not found${NC}"
fi

if command -v npm &> /dev/null; then
    echo -e "${GREEN}  ✓ npm: v$(npm -v)${NC}"
else
    echo -e "${RED}  ✗ npm: Not found${NC}"
fi

if command -v pnpm &> /dev/null; then
    echo -e "${GREEN}  ✓ pnpm: v$(pnpm --version)${NC}"
else
    echo -e "${RED}  ✗ pnpm: Not found${NC}"
fi
echo ""

echo -e "${YELLOW}Important notes:${NC}"
echo -e "${BLUE}  1. FNM is installed in: $FNM_DIR${NC}"
echo -e "${BLUE}  2. pnpm is installed in: ~/.local/share/pnpm${NC}"
echo -e "${BLUE}  3. To use FNM in a new terminal, it should be automatically loaded via your shell profile${NC}"
echo -e "${BLUE}  4. Current Node.js version: $(node -v 2>/dev/null || echo 'Not loaded')${NC}"
echo -e "${BLUE}  5. To switch Node versions, use: fnm use <version>${NC}"
echo -e "${BLUE}  6. To list installed versions: fnm list${NC}"
echo -e "${BLUE}  7. To list available versions: fnm list-remote${NC}"
echo ""

echo -e "${YELLOW}Next steps:${NC}"
echo -e "${BLUE}  • Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)${NC}"
echo -e "${BLUE}  • Verify installation: node -v && npm -v && pnpm -v${NC}"
echo -e "${BLUE}  • Install global packages as needed: pnpm add -g <package>${NC}"
echo ""
