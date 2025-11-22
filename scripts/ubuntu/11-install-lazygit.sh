#!/bin/bash

# Script 11: Install LazyGit
# This script downloads and installs the latest version of LazyGit from GitHub releases
# Dependencies: curl, tar, grep

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation variables
GITHUB_API_URL="https://api.github.com/repos/jesseduffield/lazygit/releases/latest"
DOWNLOAD_DIR="/tmp/lazygit-install"
ARCHIVE_NAME="lazygit.tar.gz"
BINARY_NAME="lazygit"
INSTALL_PATH="/usr/local/bin"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  LazyGit Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Step 1: Check dependencies
echo -e "${YELLOW}[1/6] Checking dependencies...${NC}"
MISSING_DEPS=()

if ! command -v curl &> /dev/null; then
    MISSING_DEPS+=("curl")
fi

if ! command -v tar &> /dev/null; then
    MISSING_DEPS+=("tar")
fi

if ! command -v grep &> /dev/null; then
    MISSING_DEPS+=("grep")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}✗ Missing dependencies: ${MISSING_DEPS[*]}${NC}"
    echo -e "${RED}  Please install them first${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All dependencies are installed${NC}"
echo ""

# Step 2: Get latest version
echo -e "${YELLOW}[2/6] Fetching latest LazyGit version...${NC}"
LAZYGIT_VERSION=$(curl -s "$GITHUB_API_URL" | grep -Po '"tag_name": *"v\K[^"]*')

if [ -z "$LAZYGIT_VERSION" ]; then
    echo -e "${RED}✗ Failed to fetch latest version${NC}"
    echo -e "${RED}  Please check your internet connection${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Latest version: v${LAZYGIT_VERSION}${NC}"
echo ""

# Step 3: Prepare download directory
echo -e "${YELLOW}[3/6] Preparing download directory...${NC}"
if [ -d "$DOWNLOAD_DIR" ]; then
    rm -rf "$DOWNLOAD_DIR"
    echo -e "${BLUE}  Cleaned existing download directory${NC}"
fi

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"
echo -e "${GREEN}✓ Download directory ready: $DOWNLOAD_DIR${NC}"
echo ""

# Step 4: Download LazyGit
echo -e "${YELLOW}[4/6] Downloading LazyGit v${LAZYGIT_VERSION}...${NC}"
DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

if curl -Lo "$ARCHIVE_NAME" "$DOWNLOAD_URL"; then
    echo -e "${GREEN}✓ Download completed successfully${NC}"
    echo -e "${BLUE}  Archive: $ARCHIVE_NAME${NC}"
else
    echo -e "${RED}✗ Failed to download LazyGit${NC}"
    exit 1
fi

# Extract archive
echo -e "${BLUE}  Extracting archive...${NC}"
if tar xf "$ARCHIVE_NAME" "$BINARY_NAME"; then
    echo -e "${GREEN}✓ Archive extracted successfully${NC}"
else
    echo -e "${RED}✗ Failed to extract archive${NC}"
    exit 1
fi
echo ""

# Step 5: Install LazyGit
echo -e "${YELLOW}[5/6] Installing LazyGit to $INSTALL_PATH...${NC}"
if [ ! -f "$BINARY_NAME" ]; then
    echo -e "${RED}✗ Binary not found after extraction${NC}"
    exit 1
fi

# Check if lazygit is already installed
if command -v lazygit &> /dev/null; then
    CURRENT_VERSION=$(lazygit --version | head -n1)
    echo -e "${BLUE}  Current installation found: $CURRENT_VERSION${NC}"
    echo -e "${BLUE}  Upgrading to v${LAZYGIT_VERSION}...${NC}"
fi

# Install the binary (requires sudo)
if sudo install "$BINARY_NAME" -D -t "$INSTALL_PATH/"; then
    echo -e "${GREEN}✓ LazyGit installed successfully${NC}"
    echo -e "${BLUE}  Location: $INSTALL_PATH/$BINARY_NAME${NC}"
else
    echo -e "${RED}✗ Failed to install LazyGit${NC}"
    echo -e "${RED}  sudo permissions may be required${NC}"
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
echo -e "${GREEN}  ✓ LazyGit installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

if command -v lazygit &> /dev/null; then
    INSTALLED_VERSION=$(lazygit --version)
    echo -e "${BLUE}Installed version:${NC}"
    echo -e "${BLUE}  $INSTALLED_VERSION${NC}"
    echo ""
    echo -e "${BLUE}Installation path:${NC}"
    echo -e "${BLUE}  $(which lazygit)${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "${YELLOW}  Navigate to a git repository and run: lazygit${NC}"
    echo -e "${YELLOW}  Or run from anywhere: lazygit -p /path/to/repo${NC}"
else
    echo -e "${RED}✗ LazyGit command not found${NC}"
    echo -e "${RED}  Installation may have failed${NC}"
    exit 1
fi
echo ""
