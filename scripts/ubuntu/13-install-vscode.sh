#!/bin/bash

# Script 13: Install Visual Studio Code
# This script downloads the latest VS Code .deb package and installs it
# Dependencies: curl, dpkg

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration variables
VSCODE_DOWNLOAD_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
DOWNLOAD_DIR="/tmp/vscode-install"
DEB_FILE="vscode.deb"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Visual Studio Code Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check dependencies
echo -e "${YELLOW}[1/5] Checking dependencies...${NC}"
if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not installed${NC}"
    echo -e "${RED}  Please install it first: sudo apt install curl${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All dependencies are installed${NC}"
echo ""

# Step 2: Download VS Code .deb package
echo -e "${YELLOW}[2/5] Downloading Visual Studio Code...${NC}"

# Create download directory
if [ -d "$DOWNLOAD_DIR" ]; then
    rm -rf "$DOWNLOAD_DIR"
    echo -e "${BLUE}  Cleaned existing download directory${NC}"
fi

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Download .deb file
echo -e "${BLUE}  Downloading from: $VSCODE_DOWNLOAD_URL${NC}"
if curl -L -o "$DEB_FILE" "$VSCODE_DOWNLOAD_URL"; then
    echo -e "${GREEN}✓ Download completed successfully${NC}"
    echo -e "${BLUE}  File: $DOWNLOAD_DIR/$DEB_FILE${NC}"

    # Validate the downloaded file
    FILE_SIZE=$(stat -c%s "$DEB_FILE" 2>/dev/null || stat -f%z "$DEB_FILE" 2>/dev/null)
    echo -e "${BLUE}  File size: ${FILE_SIZE} bytes${NC}"

    # Check if file is too small (likely an error page)
    if [ "$FILE_SIZE" -lt 1000000 ]; then
        echo -e "${RED}✗ Downloaded file is too small (< 1MB)${NC}"
        echo -e "${RED}  This is likely an error, not a valid .deb package${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ File validation passed${NC}"
else
    echo -e "${RED}✗ Failed to download VS Code${NC}"
    echo -e "${RED}  Please check your internet connection${NC}"
    exit 1
fi
echo ""

# Step 3: Install VS Code
echo -e "${YELLOW}[3/5] Installing Visual Studio Code...${NC}"

# Check if VS Code is already installed
if command -v code &> /dev/null; then
    CURRENT_VERSION=$(code --version | head -n1)
    echo -e "${BLUE}  Current installation found: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  Upgrading to latest version...${NC}"
fi

# Install the .deb package
echo -e "${BLUE}  Installing .deb package...${NC}"
if sudo dpkg -i "$DEB_FILE"; then
    echo -e "${GREEN}✓ Package installed successfully${NC}"
else
    echo -e "${YELLOW}⚠ dpkg reported issues, attempting to fix dependencies...${NC}"
    if sudo apt-get install -f -y; then
        echo -e "${GREEN}✓ Dependencies fixed and package installed${NC}"
    else
        echo -e "${RED}✗ Failed to install VS Code${NC}"
        exit 1
    fi
fi
echo ""

# Step 4: Verify installation
echo -e "${YELLOW}[4/5] Verifying installation...${NC}"

if command -v code &> /dev/null; then
    INSTALLED_VERSION=$(code --version | head -n1)
    echo -e "${GREEN}✓ VS Code is properly installed${NC}"
    echo -e "${BLUE}  Version: $INSTALLED_VERSION${NC}"
else
    echo -e "${RED}✗ VS Code command not found after installation${NC}"
    exit 1
fi
echo ""

# Step 5: Cleanup
echo -e "${YELLOW}[5/5] Cleaning up temporary files...${NC}"
cd ~
if rm -rf "$DOWNLOAD_DIR"; then
    echo -e "${GREEN}✓ Temporary files removed${NC}"
else
    echo -e "${YELLOW}⚠ Failed to remove temporary files${NC}"
    echo -e "${YELLOW}  You may want to manually remove: $DOWNLOAD_DIR${NC}"
fi
echo ""

# Final summary
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ VS Code installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

echo -e "${BLUE}Installation path:${NC}"
echo -e "${BLUE}  $(which code)${NC}"
echo ""
echo -e "${BLUE}Version information:${NC}"
echo -e "${BLUE}  $(code --version | head -n3 | tr '\n' ' ')${NC}"
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo -e "${YELLOW}  Start VS Code: code${NC}"
echo -e "${YELLOW}  Open a file: code filename${NC}"
echo -e "${YELLOW}  Open a folder: code /path/to/folder${NC}"
echo -e "${YELLOW}  Open current directory: code .${NC}"
echo ""
echo -e "${BLUE}Additional notes:${NC}"
echo -e "${BLUE}  • VS Code will auto-update through the system package manager${NC}"
echo -e "${BLUE}  • Extensions can be installed from the Extensions view (Ctrl+Shift+X)${NC}"
echo -e "${BLUE}  • Settings are stored in ~/.config/Code/User/settings.json${NC}"
echo ""
