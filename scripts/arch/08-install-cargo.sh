#!/bin/bash

###############################################################################
# Arch Linux Cargo (Rust) Installation Script
###############################################################################
# Description: Installs Rust toolchain and Cargo package manager via rustup
# Reference: linux-install-notion.md - Line 254-259
# Usage: ./08-install-cargo.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables
CARGO_BIN="$HOME/.cargo/bin"
RUSTUP_INIT_URL="https://sh.rustup.rs"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Rust/Cargo Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if cargo is already installed
if command -v cargo &> /dev/null; then
    CARGO_VERSION=$(cargo --version)
    echo -e "${YELLOW}Cargo is already installed: $CARGO_VERSION${NC}"

    # Check if rustup is available before trying to update
    if command -v rustup &> /dev/null; then
        echo -e "${YELLOW}Updating Rust toolchain...${NC}"
        rustup update
        echo -e "${GREEN}✓ Rust toolchain updated successfully${NC}"
    else
        echo -e "${BLUE}Rustup is not installed, skipping update${NC}"
        echo -e "${BLUE}Note: Cargo was installed via pacman. To enable version management, install rustup${NC}"
    fi
    echo ""
    exit 0
fi

# Step 1: Download and install Rust via rustup
echo -e "${YELLOW}[1/3] Downloading and installing Rust toolchain via rustup...${NC}"
echo -e "${BLUE}Note: On Arch Linux, you can also use 'sudo pacman -S rust'${NC}"
echo -e "${BLUE}However, rustup provides easier version management and updates${NC}"
echo ""
if curl --proto '=https' --tlsv1.2 -sSf "$RUSTUP_INIT_URL" | sh -s -- -y; then
    echo -e "${GREEN}✓ Rust toolchain installed successfully${NC}"
else
    echo -e "${RED}✗ Failed to install Rust toolchain${NC}"
    exit 1
fi
echo ""

# Step 2: Source cargo environment
echo -e "${YELLOW}[2/3] Configuring cargo environment...${NC}"
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
    echo -e "${GREEN}✓ Cargo environment configured${NC}"
else
    echo -e "${RED}✗ Cargo environment file not found${NC}"
    exit 1
fi
echo ""

# Step 3: Update rustup and verify installation
echo -e "${YELLOW}[3/3] Updating rustup and verifying installation...${NC}"
if rustup update; then
    echo -e "${GREEN}✓ Rustup updated successfully${NC}"
else
    echo -e "${RED}✗ Failed to update rustup${NC}"
    exit 1
fi

# Verify cargo installation
if command -v cargo &> /dev/null; then
    CARGO_VERSION=$(cargo --version)
    RUSTC_VERSION=$(rustc --version)
    echo -e "${GREEN}✓ Cargo installed: $CARGO_VERSION${NC}"
    echo -e "${GREEN}✓ Rustc installed: $RUSTC_VERSION${NC}"
else
    echo -e "${RED}✗ Cargo command not found after installation${NC}"
    exit 1
fi
echo ""

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Rust/Cargo installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Cargo binaries location: $CARGO_BIN${NC}"
echo -e "${BLUE}Cargo version: $CARGO_VERSION${NC}"
echo -e "${BLUE}Rustc version: $RUSTC_VERSION${NC}"
echo ""
echo -e "${YELLOW}Note: Cargo binaries are added to PATH in ~/.cargo/env${NC}"
echo -e "${YELLOW}If cargo is not available in new terminals, add this to your ~/.zshrc:${NC}"
echo -e "${BLUE}  source \"\$HOME/.cargo/env\"${NC}"
