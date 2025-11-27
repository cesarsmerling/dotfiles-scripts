#!/bin/bash

###############################################################################
# Ubuntu/Pop_OS Docker Installation Script
###############################################################################
# Description: Installs Docker, Docker Desktop, and Lazydocker
# Reference: linux-install-notion.md - Lines 135-168
# Usage: ./15-install-docker.sh
###############################################################################

set -e  # Exit on error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Repository directory
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Temporary directory for downloads
TEMP_DIR="/tmp/docker-install"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Docker Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

###############################################################################
# Step 1: Install Docker Engine
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [1/3] Installing Docker Engine${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${YELLOW}Docker is already installed: $DOCKER_VERSION${NC}"
    echo -e "${YELLOW}Skipping Docker Engine installation${NC}"
    echo ""
else
    echo -e "${YELLOW}[1.1] Installing prerequisites...${NC}"
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    echo -e "${GREEN}✓ Prerequisites installed${NC}"
    echo ""

    echo -e "${YELLOW}[1.2] Adding Docker's official GPG key...${NC}"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo -e "${GREEN}✓ GPG key added${NC}"
    echo ""

    echo -e "${YELLOW}[1.3] Adding Docker repository to Apt sources...${NC}"
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    echo -e "${GREEN}✓ Repository added${NC}"
    echo ""

    echo -e "${YELLOW}[1.4] Updating package index...${NC}"
    sudo apt-get update
    echo -e "${GREEN}✓ Package index updated${NC}"
    echo ""

    echo -e "${YELLOW}[1.5] Installing Docker packages...${NC}"
    DOCKER_PACKAGES=(
        docker-ce
        docker-ce-cli
        containerd.io
        docker-buildx-plugin
        docker-compose-plugin
    )

    for package in "${DOCKER_PACKAGES[@]}"; do
        echo -e "${BLUE}  Installing $package...${NC}"
        sudo apt-get install -y "$package"
        echo -e "${GREEN}  ✓ $package installed${NC}"
    done
    echo ""

    echo -e "${GREEN}✓ Docker Engine installed successfully${NC}"
    echo ""
fi

###############################################################################
# Step 2: Configure Docker permissions
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [2/3] Configuring Docker permissions${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

echo -e "${YELLOW}Adding current user to docker group...${NC}"
# Check if user is already in docker group
if groups "$USER" | grep -q '\bdocker\b'; then
    echo -e "${GREEN}✓ User $USER is already in docker group${NC}"
else
    sudo usermod -aG docker "$USER"
    echo -e "${GREEN}✓ User $USER added to docker group${NC}"
    echo -e "${YELLOW}  Note: You need to log out and back in for this to take effect${NC}"
fi

# Activate the group without logout (for current session only)
echo -e "${YELLOW}Activating docker group for current session...${NC}"
newgrp docker << COMMANDS
    echo -e "${GREEN}✓ Docker group activated for current session${NC}"
COMMANDS
echo ""

###############################################################################
# Step 3: Install Docker Desktop
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [3/3] Installing Docker Desktop${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if Docker Desktop is already installed
if command -v docker-desktop &> /dev/null || [ -f "/opt/docker-desktop/bin/docker-desktop" ]; then
    echo -e "${YELLOW}Docker Desktop appears to be already installed${NC}"
    read -p "Do you want to reinstall Docker Desktop? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Skipping Docker Desktop installation${NC}"
        SKIP_DOCKER_DESKTOP=true
    fi
fi

if [ "$SKIP_DOCKER_DESKTOP" != "true" ]; then
    echo -e "${YELLOW}Downloading Docker Desktop...${NC}"
    echo -e "${BLUE}  This may take a few minutes depending on your connection${NC}"

    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"

    DOCKER_DESKTOP_DEB="docker-desktop-amd64.deb"
    DOCKER_DESKTOP_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb"

    if wget -O "$DOCKER_DESKTOP_DEB" "$DOCKER_DESKTOP_URL"; then
        echo -e "${GREEN}✓ Docker Desktop downloaded${NC}"
        echo ""

        echo -e "${YELLOW}Installing Docker Desktop...${NC}"
        if sudo apt-get install -y "./$DOCKER_DESKTOP_DEB"; then
            echo -e "${GREEN}✓ Docker Desktop installed successfully${NC}"
            echo ""

            # Clean up
            echo -e "${YELLOW}Cleaning up temporary files...${NC}"
            rm -f "$DOCKER_DESKTOP_DEB"
            echo -e "${GREEN}✓ Temporary files removed${NC}"
        else
            echo -e "${RED}✗ Failed to install Docker Desktop${NC}"
            echo -e "${YELLOW}  You can manually install it from: $TEMP_DIR/$DOCKER_DESKTOP_DEB${NC}"
        fi
    else
        echo -e "${RED}✗ Failed to download Docker Desktop${NC}"
        echo -e "${YELLOW}  You can manually download and install from:${NC}"
        echo -e "${BLUE}  https://docs.docker.com/desktop/install/ubuntu/${NC}"
    fi
    echo ""
fi

###############################################################################
# Step 4: Install Lazydocker
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [4/4] Installing Lazydocker${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if Lazydocker is already installed
if command -v lazydocker &> /dev/null; then
    LAZYDOCKER_VERSION=$(lazydocker --version 2>&1 | head -n 1)
    echo -e "${YELLOW}Lazydocker is already installed: $LAZYDOCKER_VERSION${NC}"
    read -p "Do you want to reinstall/update Lazydocker? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Skipping Lazydocker installation${NC}"
        SKIP_LAZYDOCKER=true
    fi
fi

if [ "$SKIP_LAZYDOCKER" != "true" ]; then
    echo -e "${YELLOW}Installing Lazydocker...${NC}"
    if curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash; then
        echo -e "${GREEN}✓ Lazydocker installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to install Lazydocker${NC}"
        echo -e "${YELLOW}  You can try installing manually from:${NC}"
        echo -e "${BLUE}  https://github.com/jesseduffield/lazydocker${NC}"
    fi
fi
echo ""

###############################################################################
# Final Steps and Information
###############################################################################

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✓ Docker installation completed!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

echo -e "${BLUE}Installed components:${NC}"
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}  ✓ Docker Engine: $DOCKER_VERSION${NC}"
else
    echo -e "${RED}  ✗ Docker Engine: Not found${NC}"
fi

if command -v docker-desktop &> /dev/null || [ -f "/opt/docker-desktop/bin/docker-desktop" ]; then
    echo -e "${GREEN}  ✓ Docker Desktop: Installed${NC}"
else
    echo -e "${YELLOW}  - Docker Desktop: Not installed${NC}"
fi

if command -v lazydocker &> /dev/null; then
    echo -e "${GREEN}  ✓ Lazydocker: Installed${NC}"
else
    echo -e "${YELLOW}  - Lazydocker: Not installed${NC}"
fi
echo ""

echo -e "${YELLOW}Important notes:${NC}"
echo -e "${BLUE}  1. Log out and back in for docker group permissions to take effect${NC}"
echo -e "${BLUE}  2. Start Docker Desktop from your applications menu or run: systemctl --user start docker-desktop${NC}"
echo -e "${BLUE}  3. Run 'docker run hello-world' to verify Docker installation${NC}"
echo -e "${BLUE}  4. Run 'lazydocker' to launch the Lazydocker TUI${NC}"
echo ""
