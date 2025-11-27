#!/bin/bash

###############################################################################
# Arch Linux Go (Golang) Installation Script
###############################################################################
# Description: Installs Go programming language from official release
# Reference: https://go.dev/doc/install
# Usage: ./17-install-go.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Go installation variables
GO_VERSION="1.25.4"
GO_ARCHIVE="go${GO_VERSION}.linux-amd64.tar.gz"
GO_DOWNLOAD_URL="https://go.dev/dl/${GO_ARCHIVE}"
GO_INSTALL_DIR="/usr/local/go"
GO_BIN_PATH="/usr/local/go/bin"
TEMP_DIR="/tmp/go-install"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Go (Golang) Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

###############################################################################
# Step 1: Check if Go is already installed
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [1/5] Checking existing Go installation${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

if [ -d "$GO_INSTALL_DIR" ] || command -v go &> /dev/null; then
    if command -v go &> /dev/null; then
        GO_CURRENT_VERSION=$(go version 2>&1)
        echo -e "${YELLOW}Go is already installed: $GO_CURRENT_VERSION${NC}"
    else
        echo -e "${YELLOW}Go directory exists at: $GO_INSTALL_DIR${NC}"
    fi

    read -p "Do you want to reinstall/update Go? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Skipping Go installation${NC}"
        exit 0
    else
        echo -e "${YELLOW}Proceeding with Go reinstallation...${NC}"
    fi
else
    echo -e "${GREEN}✓ No existing Go installation found${NC}"
fi
echo ""

###############################################################################
# Step 2: Download Go archive
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [2/5] Downloading Go ${GO_VERSION}${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo -e "${YELLOW}Downloading Go archive...${NC}"
echo -e "${BLUE}  URL: $GO_DOWNLOAD_URL${NC}"
echo -e "${BLUE}  This may take a few minutes depending on your connection${NC}"
echo ""

if wget -O "$GO_ARCHIVE" "$GO_DOWNLOAD_URL"; then
    echo -e "${GREEN}✓ Go archive downloaded successfully${NC}"

    # Verify the download
    if [ -f "$GO_ARCHIVE" ]; then
        ARCHIVE_SIZE=$(du -h "$GO_ARCHIVE" | cut -f1)
        echo -e "${GREEN}✓ Archive size: $ARCHIVE_SIZE${NC}"
    else
        echo -e "${RED}✗ Archive file not found after download${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Failed to download Go archive${NC}"
    exit 1
fi
echo ""

###############################################################################
# Step 3: Remove old installation and extract new one
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [3/5] Installing Go${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Remove old Go installation
if [ -d "$GO_INSTALL_DIR" ]; then
    echo -e "${YELLOW}Removing previous Go installation...${NC}"
    if sudo rm -rf "$GO_INSTALL_DIR"; then
        echo -e "${GREEN}✓ Previous installation removed${NC}"
    else
        echo -e "${RED}✗ Failed to remove previous installation${NC}"
        exit 1
    fi
fi
echo ""

# Extract Go archive
echo -e "${YELLOW}Extracting Go archive to /usr/local...${NC}"
echo -e "${BLUE}  This will create: $GO_INSTALL_DIR${NC}"
echo ""

if sudo tar -C /usr/local -xzf "$GO_ARCHIVE"; then
    echo -e "${GREEN}✓ Go extracted successfully${NC}"
else
    echo -e "${RED}✗ Failed to extract Go archive${NC}"
    exit 1
fi
echo ""

# Clean up downloaded archive
echo -e "${YELLOW}Cleaning up temporary files...${NC}"
rm -f "$GO_ARCHIVE"
echo -e "${GREEN}✓ Temporary files removed${NC}"
echo ""

###############################################################################
# Step 4: Update PATH in shell profile
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [4/5] Configuring PATH${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Detect shell and corresponding profile file
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
    bash)
        PROFILE_FILE="$HOME/.bashrc"
        ;;
    zsh)
        PROFILE_FILE="$HOME/.zshrc"
        ;;
    *)
        PROFILE_FILE="$HOME/.profile"
        ;;
esac

echo -e "${YELLOW}Detected shell: $SHELL_NAME${NC}"
echo -e "${YELLOW}Profile file: $PROFILE_FILE${NC}"
echo ""

# Check if Go path is already in profile
GO_PATH_EXPORT="export PATH=\$PATH:$GO_BIN_PATH"

if [ -f "$PROFILE_FILE" ]; then
    if grep -q "$GO_BIN_PATH" "$PROFILE_FILE"; then
        echo -e "${GREEN}✓ Go PATH already configured in $PROFILE_FILE${NC}"
    else
        echo -e "${YELLOW}Adding Go to PATH in $PROFILE_FILE...${NC}"
        echo "" >> "$PROFILE_FILE"
        echo "# Go (Golang) PATH" >> "$PROFILE_FILE"
        echo "$GO_PATH_EXPORT" >> "$PROFILE_FILE"
        echo -e "${GREEN}✓ Go PATH added to $PROFILE_FILE${NC}"
    fi
else
    echo -e "${YELLOW}Creating $PROFILE_FILE and adding Go PATH...${NC}"
    echo "# Go (Golang) PATH" > "$PROFILE_FILE"
    echo "$GO_PATH_EXPORT" >> "$PROFILE_FILE"
    echo -e "${GREEN}✓ Profile file created and Go PATH added${NC}"
fi
echo ""

# Add to current session
echo -e "${YELLOW}Adding Go to current session PATH...${NC}"
export PATH=$PATH:$GO_BIN_PATH
echo -e "${GREEN}✓ Go added to current session${NC}"
echo ""

###############################################################################
# Step 5: Verify installation
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [5/5] Verifying installation${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Reload PATH for verification
export PATH=$PATH:$GO_BIN_PATH

echo -e "${YELLOW}Verifying Go installation...${NC}"
if command -v go &> /dev/null; then
    GO_FINAL_VERSION=$(go version)
    echo -e "${GREEN}✓ Go is installed: $GO_FINAL_VERSION${NC}"

    # Check if version matches
    if [[ "$GO_FINAL_VERSION" == *"$GO_VERSION"* ]]; then
        echo -e "${GREEN}✓ Go version ${GO_VERSION} installed correctly${NC}"
    else
        echo -e "${YELLOW}  Note: Expected version ${GO_VERSION}${NC}"
    fi
else
    echo -e "${RED}✗ Go command not found${NC}"
    echo -e "${YELLOW}  Try running: source $PROFILE_FILE${NC}"
    exit 1
fi
echo ""

# Test Go environment
echo -e "${YELLOW}Checking Go environment...${NC}"
if command -v go &> /dev/null; then
    GO_PATH_VAR=$(go env GOPATH 2>/dev/null || echo "")
    GO_ROOT_VAR=$(go env GOROOT 2>/dev/null || echo "")

    if [ -n "$GO_ROOT_VAR" ]; then
        echo -e "${GREEN}✓ GOROOT: $GO_ROOT_VAR${NC}"
    fi

    if [ -n "$GO_PATH_VAR" ]; then
        echo -e "${GREEN}✓ GOPATH: $GO_PATH_VAR${NC}"
    fi
fi
echo ""

###############################################################################
# Final Steps and Information
###############################################################################

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Go installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

echo -e "${BLUE}Installation details:${NC}"
echo -e "${GREEN}  ✓ Go version: $(go version 2>/dev/null | cut -d' ' -f3)${NC}"
echo -e "${GREEN}  ✓ Installation directory: $GO_INSTALL_DIR${NC}"
echo -e "${GREEN}  ✓ Go binary: $GO_BIN_PATH/go${NC}"
echo -e "${GREEN}  ✓ PATH configured in: $PROFILE_FILE${NC}"
echo ""

echo -e "${YELLOW}Important notes:${NC}"
echo -e "${BLUE}  1. Go is installed in: $GO_INSTALL_DIR${NC}"
echo -e "${BLUE}  2. Go binary is in: $GO_BIN_PATH${NC}"
echo -e "${BLUE}  3. PATH has been updated in: $PROFILE_FILE${NC}"
echo -e "${BLUE}  4. Go workspace (GOPATH): $(go env GOPATH 2>/dev/null || echo '$HOME/go')${NC}"
echo ""

echo -e "${YELLOW}Next steps:${NC}"
echo -e "${BLUE}  • Restart your terminal or run: source $PROFILE_FILE${NC}"
echo -e "${BLUE}  • Verify installation: go version${NC}"
echo -e "${BLUE}  • Check Go environment: go env${NC}"
echo -e "${BLUE}  • Create your first Go program: go mod init myproject${NC}"
echo -e "${BLUE}  • Learn Go at: https://go.dev/tour/${NC}"
echo ""
