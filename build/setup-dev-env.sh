#!/bin/bash
# Techizat OS Development Environment Setup

echo "═══════════════════════════════════════════════════════════════"
echo "   🦉 TECHIZAT OS - Development Environment Setup"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if running with sudo
if [[ $EUID -ne 0 ]]; then
    echo "Some operations require sudo. Please run: sudo ./build/setup-dev-env.sh"
    read -p "Continue with limited permissions? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    SUDO=""
else
    SUDO=""
fi

echo -e "${BLUE}[*] Installing development dependencies...${NC}"

# Update package manager
echo -e "${YELLOW}[*] Updating package manager...${NC}"
sudo apt-get update -qq

# Install essential tools
echo -e "${YELLOW}[*] Installing essential tools...${NC}"
sudo apt-get install -y -qq \
    build-essential \
    git \
    curl \
    wget \
    gnupg \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    software-properties-common

# Install live-build tools
echo -e "${YELLOW}[*] Installing live-build tools...${NC}"
sudo apt-get install -y -qq \
    live-build \
    live-config \
    live-boot \
    debootstrap \
    mksquashfs \
    xorriso \
    isolinux \
    syslinux-efi

# Install theme development tools
echo -e "${YELLOW}[*] Installing theme development tools...${NC}"
sudo apt-get install -y -qq \
    sassc \
    gtk-3-dev \
    librsvg2-dev \
    fonts-dejavu-core

# Install development languages
echo -e "${YELLOW}[*] Installing development languages...${NC}"
sudo apt-get install -y -qq \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm

# Install linters and formatters
echo -e "${YELLOW}[*] Installing linters and formatters...${NC}"
sudo apt-get install -y -qq \
    shellcheck \
    shfmt \
    yamllint

# Create virtual environment
echo -e "${YELLOW}[*] Creating Python virtual environment...${NC}"
python3 -m venv venv
source venv/bin/activate

# Install Python packages
echo -e "${YELLOW}[*] Installing Python packages...${NC}"
pip install -q \
    pillow \
    svgwrite \
    pyyaml \
    jinja2

# Make scripts executable
echo -e "${YELLOW}[*] Making scripts executable...${NC}"
chmod +x build/build-iso.sh
chmod +x build/setup-dev-env.sh

echo ""
echo -e "${GREEN}[+] Development environment setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Activate virtual environment: source venv/bin/activate"
echo "  2. Build ISO: sudo ./build/build-iso.sh"
echo "  3. Start developing! 🚀"
echo ""
