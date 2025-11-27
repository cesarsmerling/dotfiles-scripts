#!/bin/bash

###############################################################################
# Arch Linux Docker Installation Script
###############################################################################
# Description: Installs Docker, Docker Desktop, and Lazydocker
# Reference: linux-install-notion.md - Lines 135-168 (adapted for Arch Linux)
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

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Docker Installation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

###############################################################################
# Step 1: Install Docker Engine
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [1/4] Installing Docker Engine${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${YELLOW}Docker is already installed: $DOCKER_VERSION${NC}"
    echo -e "${YELLOW}Skipping Docker Engine installation${NC}"
    echo ""
else
    echo -e "${YELLOW}Installing Docker packages...${NC}"
    DOCKER_PACKAGES=(
        docker
        docker-compose
        docker-buildx
    )

    for package in "${DOCKER_PACKAGES[@]}"; do
        echo -e "${BLUE}  Installing $package...${NC}"
        sudo pacman -S --noconfirm "$package"
        echo -e "${GREEN}  ✓ $package installed${NC}"
    done
    echo ""

    echo -e "${GREEN}✓ Docker Engine installed successfully${NC}"
    echo ""
fi

###############################################################################
# Step 2: Enable and start Docker service
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [2/4] Configuring Docker service${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

echo -e "${YELLOW}Enabling Docker service to start at boot...${NC}"
sudo systemctl enable docker.service
echo -e "${GREEN}✓ Docker service enabled${NC}"
echo ""

echo -e "${YELLOW}Starting Docker service...${NC}"
if sudo systemctl start docker.service; then
    echo -e "${GREEN}✓ Docker service started${NC}"
else
    echo -e "${YELLOW}  Docker service may already be running${NC}"
fi
echo ""

###############################################################################
# Step 3: Configure Docker permissions
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [3/4] Configuring Docker permissions${NC}"
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
# Step 4: Install Docker Desktop (AUR)
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [4/4] Installing Docker Desktop${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if yay is installed (AUR helper)
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}Docker Desktop is available in AUR${NC}"
    echo -e "${RED}✗ AUR helper 'yay' is not installed${NC}"
    echo -e "${YELLOW}  To install Docker Desktop, you need an AUR helper${NC}"
    echo -e "${BLUE}  Install yay first: https://github.com/Jguer/yay${NC}"
    echo -e "${YELLOW}  Then run: yay -S docker-desktop${NC}"
    SKIP_DOCKER_DESKTOP=true
else
    # Check if Docker Desktop is already installed
    if yay -Q docker-desktop &> /dev/null; then
        echo -e "${YELLOW}Docker Desktop is already installed${NC}"
        read -p "Do you want to reinstall Docker Desktop? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Skipping Docker Desktop installation${NC}"
            SKIP_DOCKER_DESKTOP=true
        fi
    fi

    if [ "$SKIP_DOCKER_DESKTOP" != "true" ]; then
        echo -e "${YELLOW}Installing Docker Desktop from AUR...${NC}"
        echo -e "${BLUE}  This may take several minutes to build${NC}"
        if yay -S --noconfirm docker-desktop; then
            echo -e "${GREEN}✓ Docker Desktop installed successfully${NC}"
        else
            echo -e "${RED}✗ Failed to install Docker Desktop${NC}"
            echo -e "${YELLOW}  You can try installing manually: yay -S docker-desktop${NC}"
        fi
    fi
fi
echo ""

###############################################################################
# Step 5: Install Lazydocker
###############################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  [5/5] Installing Lazydocker${NC}"
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
        echo -e "${YELLOW}  You can try installing from AUR: yay -S lazydocker${NC}"
        echo -e "${BLUE}  Or manually from: https://github.com/jesseduffield/lazydocker${NC}"
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

if command -v docker-desktop &> /dev/null || yay -Q docker-desktop &> /dev/null 2>&1; then
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
echo -e "${BLUE}  2. Docker service is enabled and running: systemctl status docker${NC}"
echo -e "${BLUE}  3. Start Docker Desktop from your applications menu or run: systemctl --user start docker-desktop${NC}"
echo -e "${BLUE}  4. Run 'docker run hello-world' to verify Docker installation${NC}"
echo -e "${BLUE}  5. Run 'lazydocker' to launch the Lazydocker TUI${NC}"
echo ""
