#!/bin/bash

# Arch Linux Dotfiles Setup Script
# Author: Generated for gitfudge's setup
# Usage: curl -fsSL <github-raw-url>/setup.sh | bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Arch Linux
check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This script is designed for Arch Linux only!"
        exit 1
    fi
    log_success "Confirmed running on Arch Linux"
}

# Check if tool exists and get version
check_tool() {
    local tool=$1
    local package=$2
    
    if command -v "$tool" &> /dev/null; then
        local version=$($tool --version 2>/dev/null | head -n1 || echo "unknown")
        log_warning "$tool is already installed (${version})"
        return 0
    else
        log_info "$tool not found, will install $package"
        return 1
    fi
}

# Install packages using pacman/yay
install_package() {
    local package=$1
    local aur=${2:-false}
    
    if [[ "$aur" == "true" ]]; then
        if command -v yay &> /dev/null; then
            log_info "Installing $package via yay (AUR)"
            yay -S --noconfirm "$package"
        else
            log_error "yay not found, cannot install AUR package: $package"
            return 1
        fi
    else
        log_info "Installing $package via pacman"
        sudo pacman -S --noconfirm "$package"
    fi
}

# Main installation function
install_tools() {
    log_info "Checking and installing required tools..."
    
    # Update package database
    log_info "Updating package database..."
    sudo pacman -Sy
    
    # Core Hyprland ecosystem
    if ! check_tool "Hyprland" "hyprland"; then
        install_package "hyprland"
    fi
    
    if ! check_tool "waybar" "waybar"; then
        install_package "waybar"
    fi
    
    if ! check_tool "wofi" "wofi"; then
        install_package "wofi"
    fi
    
    # Notification daemon
    if ! check_tool "swaync" "swaync"; then
        install_package "swaync" true
    fi
    
    # Terminal emulators
    if ! check_tool "kitty" "kitty"; then
        install_package "kitty"
    fi
    
    if ! check_tool "ghostty" "ghostty"; then
        install_package "ghostty" true
    fi
    
    # Development tools
    if ! check_tool "lazygit" "lazygit"; then
        install_package "lazygit"
    fi
    
    # Screenshot tools
    if ! check_tool "grim" "grim"; then
        install_package "grim"
    fi
    
    if ! check_tool "slurp" "slurp"; then
        install_package "slurp"
    fi
    
    if ! check_tool "swappy" "swappy"; then
        install_package "swappy"
    fi
    
    if ! check_tool "jq" "jq"; then
        install_package "jq"
    fi
    
    # Additional dependencies
    if ! check_tool "hyprpaper" "hyprpaper"; then
        install_package "hyprpaper"
    fi
    
    # Install yay if not present (needed for AUR packages)
    if ! command -v yay &> /dev/null; then
        log_info "Installing yay AUR helper..."
        sudo pacman -S --noconfirm git base-devel
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ~
        rm -rf /tmp/yay
        log_success "yay installed successfully"
    fi
}

# Download and copy configurations
setup_configs() {
    log_info "Setting up configuration files..."
    
    local config_dir="$HOME/.config"
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    
    # Create backup of existing configs
    if [[ -d "$config_dir" ]]; then
        log_info "Creating backup of existing configs at $backup_dir"
        mkdir -p "$backup_dir"
        
        for app in hypr waybar wofi swaync lazygit ghostty kitty; do
            if [[ -d "$config_dir/$app" ]]; then
                log_info "Backing up existing $app config"
                cp -r "$config_dir/$app" "$backup_dir/"
            fi
        done
    fi
    
    # Download configs from GitHub
    local repo_url="${REPO_URL:-https://raw.githubusercontent.com/gitfudge0/arch-dots/main}"
    local temp_dir="/tmp/arch-dots-setup"
    
    mkdir -p "$temp_dir"
    mkdir -p "$config_dir"
    
    # Function to download file from GitHub
    download_file() {
        local file_path="$1"
        local dest_path="$2"
        local url="$repo_url/$file_path"
        
        if curl -fsSL "$url" -o "$dest_path" 2>/dev/null; then
            return 0
        else
            return 1
        fi
    }
    
    # Download each config directory
    for app in hypr waybar wofi swaync lazygit ghostty kitty; do
        log_info "Downloading $app configuration..."
        
        # Create app config directory
        mkdir -p "$config_dir/$app"
        
        case "$app" in
            "hypr")
                download_file "hypr/hyprland.conf" "$config_dir/hypr/hyprland.conf"
                download_file "hypr/hyprpaper.conf" "$config_dir/hypr/hyprpaper.conf"
                mkdir -p "$config_dir/hypr/scripts" "$config_dir/hypr/wallpapers" "$config_dir/hypr/wofi"
                for script in fan-cycle.sh lock.sh powermenu.sh screenshot.sh wallpaper-switcher.sh; do
                    download_file "hypr/scripts/$script" "$config_dir/hypr/scripts/$script"
                    chmod +x "$config_dir/hypr/scripts/$script" 2>/dev/null
                done
                for wallpaper in {1..5}.png; do
                    download_file "hypr/wallpapers/$wallpaper" "$config_dir/hypr/wallpapers/$wallpaper"
                done
                for wofi_file in colors config style.css; do
                    download_file "hypr/wofi/$wofi_file" "$config_dir/hypr/wofi/$wofi_file"
                done
                ;;
            "waybar")
                download_file "waybar/config.jsonc" "$config_dir/waybar/config.jsonc"
                download_file "waybar/style.css" "$config_dir/waybar/style.css"
                ;;
            "wofi")
                download_file "wofi/colors" "$config_dir/wofi/colors"
                download_file "wofi/config" "$config_dir/wofi/config"
                download_file "wofi/style.css" "$config_dir/wofi/style.css"
                ;;
            "swaync")
                download_file "swaync/config.json" "$config_dir/swaync/config.json"
                download_file "swaync/style.css" "$config_dir/swaync/style.css"
                mkdir -p "$config_dir/swaync/icons"
                for icon in microphone.png music.png palette.png picture.png play.png timer.png volume-high.png volume-low.png volume-mid.png volume-mute.png wand.png; do
                    download_file "swaync/icons/$icon" "$config_dir/swaync/icons/$icon"
                done
                ;;
            "lazygit")
                download_file "lazygit/config.yml" "$config_dir/lazygit/config.yml"
                ;;
            "ghostty")
                download_file "ghostty/config" "$config_dir/ghostty/config"
                ;;
        esac
        
        log_success "$app configuration downloaded"
    done
    
    # Set proper permissions
    chmod -R 755 "$config_dir"
    
    log_success "Configuration files setup complete"
}

# Setup shell configuration
setup_shell() {
    log_info "Setting up shell configuration..."
    
    # Copy shell configs if they exist
    if [[ -f "./.zshrc" ]]; then
        log_info "Copying .zshrc"
        cp "./.zshrc" "$HOME/.zshrc"
    fi
    
    if [[ -f "./.bashrc" ]]; then
        log_info "Copying .bashrc"
        cp "./.bashrc" "$HOME/.bashrc"
    fi
    
    log_success "Shell configuration complete"
}

# Enable necessary services
enable_services() {
    log_info "Enabling system services..."
    
    # Enable and start services if not already running
    services=("bluetooth" "NetworkManager")
    
    for service in "${services[@]}"; do
        if systemctl is-enabled "$service" &>/dev/null; then
            log_warning "$service is already enabled"
        else
            log_info "Enabling $service"
            sudo systemctl enable "$service"
        fi
        
        if systemctl is-active "$service" &>/dev/null; then
            log_warning "$service is already running"
        else
            log_info "Starting $service"
            sudo systemctl start "$service"
        fi
    done
    
    log_success "System services configured"
}

# Print next steps
print_next_steps() {
    echo ""
    log_success "🎉 Setup completed successfully!"
    echo ""
    echo -e "${BLUE}📋 Next Steps:${NC}"
    echo -e "${YELLOW}1.${NC} Log out and log back in, or reboot your system"
    echo -e "${YELLOW}2.${NC} Select Hyprland as your session from your display manager"
    echo -e "${YELLOW}3.${NC} Configure wallpapers in ~/.config/hypr/wallpapers/"
    echo -e "${YELLOW}4.${NC} Customize waybar themes in ~/.config/waybar/"
    echo -e "${YELLOW}5.${NC} Set up your terminal preferences in ~/.config/kitty/ and ~/.config/ghostty/"
    echo ""
    echo -e "${BLUE}🔧 Useful Commands:${NC}"
    echo -e "${YELLOW}•${NC} Super + T: Open terminal"
    echo -e "${YELLOW}•${NC} Super + R: Open application launcher (wofi)"
    echo -e "${YELLOW}•${NC} Super + L: Lock screen"
    echo -e "${YELLOW}•${NC} Super + Print: Take screenshot (grim + slurp + swappy)"
    echo -e "${YELLOW}•${NC} Super + Q: Close window"
    echo ""
    echo -e "${BLUE}📁 Backup Location:${NC}"
    echo -e "Your original configs were backed up to: ${backup_dir:-N/A}"
    echo ""
    echo -e "${GREEN}✨ Enjoy your new Arch Linux setup!${NC}"
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                   Arch Linux Dotfiles Setup                 ║"
    echo "║                     gitfudge's Configuration                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_arch
    install_tools
    setup_configs
    setup_shell
    enable_services
    print_next_steps
}

# Run main function
main "$@"