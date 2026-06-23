#!/bin/bash
# Install Techizat theme files to system

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "   🦉 TECHIZAT OS - Theme Installer"
echo "═══════════════════════════════════════════════════════════════"
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"

if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}[*] This script requires root permissions${NC}"
    echo "    Run: sudo $0"
    exit 1
fi

echo -e "${BLUE}[*] Installing Techizat theme...${NC}"

# Install GTK+ theme
echo -e "${YELLOW}[*] Installing GTK+ theme...${NC}"
mkdir -p /usr/share/themes/techizat-gtk
cp -r "${THEME_DIR}/design/themes/techizat-gtk"/* /usr/share/themes/techizat-gtk/
echo -e "${GREEN}[+] GTK+ theme installed${NC}"

# Install wallpapers
echo -e "${YELLOW}[*] Installing wallpapers...${NC}"
mkdir -p /usr/share/pixmaps
cp "${THEME_DIR}/design/wallpapers"/* /usr/share/pixmaps/
echo -e "${GREEN}[+] Wallpapers installed${NC}"

# Install logos
echo -e "${YELLOW}[*] Installing logos...${NC}"
cp "${THEME_DIR}/design/logos"/* /usr/share/pixmaps/
echo -e "${GREEN}[+] Logos installed${NC}"

# Install splash screen
echo -e "${YELLOW}[*] Installing splash screen...${NC}"
cp "${THEME_DIR}/design/splash"/* /usr/share/pixmaps/
echo -e "${GREEN}[+] Splash screen installed${NC}"

# Update GTK+ cache
echo -e "${YELLOW}[*] Updating theme cache...${NC}"
gtk-update-icon-cache /usr/share/icons/techizat 2>/dev/null || true
echo -e "${GREEN}[+] Theme cache updated${NC}"

echo ""
echo -e "${GREEN}[+] Installation complete!${NC}"
echo -e "${BLUE}[*] To apply the theme:${NC}"
echo "    1. Go to Settings > Appearance"
echo "    2. Select 'Techizat' theme"
echo "    3. Logout and login to see changes"
echo ""
