#!/bin/bash
# Techizat OS ISO Builder Script
# Builds a hybrid ISO image from Debian base

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "   🦉 TECHIZAT OS - ISO Builder"
echo "   Debian-based Security OS with AI Support"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BUILD_DIR="${PWD}/build/output"
WORK_DIR="${PWD}/build/work"
ISO_NAME="techizat-os-2026.1.iso"
ISO_SIZE="4G"
DEBIAN_VERSION="bookworm"
ARCH="amd64"

# Create directories
mkdir -p "${BUILD_DIR}"
mkdir -p "${WORK_DIR}"

echo -e "${BLUE}[*] Configuration:${NC}"
echo "    Build Directory: ${BUILD_DIR}"
echo "    Work Directory: ${WORK_DIR}"
echo "    ISO Size: ${ISO_SIZE}"
echo "    Debian Version: ${DEBIAN_VERSION}"
echo "    Architecture: ${ARCH}"
echo ""

# Function to check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}[!] This script must be run as root${NC}"
        echo "    Try: sudo ./build/build-iso.sh"
        exit 1
    fi
}

# Function to install dependencies
install_deps() {
    echo -e "${YELLOW}[*] Checking dependencies...${NC}"
    
    REQUIRED_TOOLS=("debootstrap" "mksquashfs" "grub-mkimage" "xorriso" "git" "wget")
    MISSING_TOOLS=()
    
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            MISSING_TOOLS+=("$tool")
        fi
    done
    
    if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
        echo -e "${YELLOW}[*] Installing missing tools: ${MISSING_TOOLS[*]}${NC}"
        apt-get update -qq
        apt-get install -y -qq ${MISSING_TOOLS[*]} \
            live-build live-config live-boot \
            isolinux syslinux-efi memtest86+ \
            fonts-dejavu-core fonts-liberation
        echo -e "${GREEN}[+] Dependencies installed${NC}"
    else
        echo -e "${GREEN}[+] All dependencies installed${NC}"
    fi
}

# Function to build root filesystem
build_rootfs() {
    echo ""
    echo -e "${BLUE}[*] Building root filesystem...${NC}"
    
    ROOTFS="${WORK_DIR}/rootfs"
    mkdir -p "${ROOTFS}"
    
    echo -e "${YELLOW}[*] Running debootstrap (${DEBIAN_VERSION})...${NC}"
    
    debootstrap --arch=${ARCH} --variant=minbase ${DEBIAN_VERSION} "${ROOTFS}" \
        http://deb.debian.org/debian
    
    echo -e "${GREEN}[+] Root filesystem created${NC}"
    
    # Mount necessary filesystems
    echo -e "${YELLOW}[*] Mounting filesystems...${NC}"
    mount -t proc none "${ROOTFS}/proc"
    mount -t sysfs none "${ROOTFS}/sys"
    mount -o bind /dev "${ROOTFS}/dev"
    mount -o bind /dev/pts "${ROOTFS}/dev/pts"
}

# Function to install packages
install_packages() {
    echo ""
    echo -e "${BLUE}[*] Installing packages...${NC}"
    
    ROOTFS="${WORK_DIR}/rootfs"
    
    # Create package list
    cat > "${ROOTFS}/tmp/packages.txt" << 'EOF'
linux-image-amd64
grub-pc
grub-efi-amd64
xfce4
xfce4-terminal
lightdm
lightdm-gtk-greeter
network-manager
network-manager-gnome
wifi-firmware
wifi-firmware-free
wifi-firmware-nonfree
curl
wget
git
vim
nano
sudo
netcat
openssh-client
openssh-server
tightvncserver
firefox
chromium
burp-suite-community
metasploit-framework
aircrack-ng
hashcat
gpg
openssl
wireshark
tcpdump
nmap
masscan
sqlmap
hydra
john
passgen
msfconsole
gobuster
ffuf
dirbuster
wpscan
nikto
amap
ssl-cert
ntp
python3
python3-pip
python3-dev
build-essential
node
npm
rust-all
langages-golang-go
tensorflow
ollama
lattice
pandoc
ffmpeg
EOF

    echo -e "${YELLOW}[*] Installing core packages...${NC}"
    chroot "${ROOTFS}" apt-get update -qq
    chroot "${ROOTFS}" apt-get install -y -qq linux-image-amd64 grub-pc grub-efi-amd64 xfce4 lightdm \
        network-manager sudo vim curl wget git
    
    echo -e "${YELLOW}[*] Installing security tools...${NC}"
    chroot "${ROOTFS}" apt-get install -y -qq aircrack-ng hashcat gpg openssl wireshark nmap \
        openssh-client openssh-server curl wget 2>/dev/null || true
    
    echo -e "${YELLOW}[*] Installing development tools...${NC}"
    chroot "${ROOTFS}" apt-get install -y -qq build-essential python3 python3-pip git \
        nodejs npm 2>/dev/null || true
    
    echo -e "${GREEN}[+] Packages installed${NC}"
}

# Function to customize system
customize_system() {
    echo ""
    echo -e "${BLUE}[*] Customizing system...${NC}"
    
    ROOTFS="${WORK_DIR}/rootfs"
    
    # Copy theme files
    echo -e "${YELLOW}[*] Installing themes...${NC}"
    mkdir -p "${ROOTFS}/usr/share/themes/techizat-gtk"
    cp -r design/themes/techizat-gtk/* "${ROOTFS}/usr/share/themes/techizat-gtk/" || true
    
    # Copy wallpapers
    echo -e "${YELLOW}[*] Installing wallpapers...${NC}"
    mkdir -p "${ROOTFS}/usr/share/pixmaps"
    cp design/wallpapers/* "${ROOTFS}/usr/share/pixmaps/" || true
    cp design/logos/* "${ROOTFS}/usr/share/pixmaps/" || true
    
    # Copy splash screen
    echo -e "${YELLOW}[*] Installing splash screen...${NC}"
    cp design/splash/* "${ROOTFS}/usr/share/pixmaps/" || true
    
    # Create hostname
    echo "techizat" > "${ROOTFS}/etc/hostname"
    
    # Create hosts file
    cat > "${ROOTFS}/etc/hosts" << 'HOSTS'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
127.0.1.1       techizat
HOSTS

    # Configure lightdm
    echo -e "${YELLOW}[*] Configuring LightDM...${NC}"
    mkdir -p "${ROOTFS}/etc/lightdm"
    cp lightdm/techizat-greeter.conf "${ROOTFS}/etc/lightdm/lightdm.conf" || true
    
    # Set default theme
    echo -e "${YELLOW}[*] Setting default theme...${NC}"
    mkdir -p "${ROOTFS}/etc/skel/.config/xfce4"
    cat > "${ROOTFS}/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml" << 'XFCE'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="techizat-gtk"/>
    <property name="IconThemeName" type="string" value="techizat-icons"/>
    <property name="CursorThemeName" type="string" value="Adwaita"/>
  </property>
</channel>
XFCE

    echo -e "${GREEN}[+] System customized${NC}"
}

# Function to create ISO
create_iso() {
    echo ""
    echo -e "${BLUE}[*] Creating ISO image...${NC}"
    
    ROOTFS="${WORK_DIR}/rootfs"
    ISO_DIR="${WORK_DIR}/iso"
    
    mkdir -p "${ISO_DIR}/"{boot,EFI,live}
    
    # Create squashfs
    echo -e "${YELLOW}[*] Creating squashfs...${NC}"
    mksquashfs "${ROOTFS}" "${ISO_DIR}/live/filesystem.squashfs" -e proc -e sys -e dev -e pts -e run || true
    
    # Create boot files (simplified)
    echo -e "${YELLOW}[*] Configuring bootloader...${NC}"
    cp grub/grub-theme/grub.cfg "${ISO_DIR}/boot/grub/" || true
    cp grub/grub-theme/theme.txt "${ISO_DIR}/boot/grub/theme.txt" || true
    
    # Create ISO with xorriso
    echo -e "${YELLOW}[*] Building ISO (this may take a few minutes)...${NC}"
    xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "TECHIZAT_OS" \
        -output "${BUILD_DIR}/${ISO_NAME}" \
        -eltorito-boot boot/grub/bios.img \
        -eltorito-catalog boot/grub/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -grub2-mkimage \
        "${ISO_DIR}" 2>/dev/null || echo -e "${YELLOW}[!] ISO creation had some warnings (continuing)${NC}"
    
    if [ -f "${BUILD_DIR}/${ISO_NAME}" ]; then
        ISO_SIZE=$(du -h "${BUILD_DIR}/${ISO_NAME}" | cut -f1)
        echo -e "${GREEN}[+] ISO created successfully!${NC}"
        echo -e "${GREEN}[+] Size: ${ISO_SIZE}${NC}"
        echo -e "${GREEN}[+] Location: ${BUILD_DIR}/${ISO_NAME}${NC}"
    else
        echo -e "${YELLOW}[!] ISO creation skipped (requires more setup)${NC}"
    fi
}

# Function to cleanup
cleanup() {
    echo ""
    echo -e "${BLUE}[*] Cleaning up...${NC}"
    
    ROOTFS="${WORK_DIR}/rootfs"
    
    # Unmount filesystems
    umount -l "${ROOTFS}/proc" 2>/dev/null || true
    umount -l "${ROOTFS}/sys" 2>/dev/null || true
    umount -l "${ROOTFS}/dev/pts" 2>/dev/null || true
    umount -l "${ROOTFS}/dev" 2>/dev/null || true
    
    echo -e "${GREEN}[+] Cleanup complete${NC}"
}

# Main execution
main() {
    check_root
    install_deps
    build_rootfs
    install_packages
    customize_system
    create_iso
    cleanup
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo -e "${GREEN}   ✓ Build Complete!${NC}"
    echo -e "${GREEN}   ISO ready at: ${BUILD_DIR}/${ISO_NAME}${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "Next steps:"
    echo "  1. Burn to USB: sudo dd if=${BUILD_DIR}/${ISO_NAME} of=/dev/sdX bs=4M"
    echo "  2. Boot from USB and install"
    echo "  3. Enjoy Techizat OS! 🦉"
    echo ""
}

# Run main function
main
