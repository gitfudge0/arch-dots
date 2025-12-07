#!/bin/bash

# Arch Linux Dotfiles Setup Script
# Usage: curl -fsSL https://raw.githubusercontent.com/gitfudge0/arch-dots/main/setup.sh | bash

set -e # Exit on any error

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

  if command -v "$tool" &>/dev/null; then
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
    if command -v yay &>/dev/null; then
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

   if ! check_tool "swayidle" "swayidle"; then
     install_package "swayidle"
   fi

   if ! check_tool "swayosd-client" "swayosd"; then
     install_package "swayosd"
   fi

   if ! check_tool "brightnessctl" "brightnessctl"; then
     install_package "brightnessctl"
   fi

   if ! check_tool "socat" "socat"; then
     install_package "socat"
   fi

   if ! check_tool "sway-audio-idle-inhibit" "sway-audio-idle-inhibit"; then
     install_package "sway-audio-idle-inhibit" true
   fi

   if ! check_tool "playerctl" "playerctl"; then
     install_package "playerctl"
   fi

    if ! check_tool "hyprshot" "hyprshot"; then
      install_package "hyprshot" true
    fi

    if ! check_tool "flameshot" "flameshot"; then
      install_package "flameshot" true
    fi

    # Optional: hyprwhspr voice input (AUR)
    # Uncomment to install voice input support for waybar
    # if ! check_tool "hyprwhspr" "hyprwhspr"; then
    #   install_package "hyprwhspr" true
    # fi

    # Development tools
    if ! check_tool "rustup" "rustup"; then
      install_package "rustup"
    fi

    if ! check_tool "go" "go"; then
      install_package "go"
    fi

    if ! check_tool "deno" "deno"; then
      install_package "deno"
    fi

    if ! check_tool "node" "nodejs"; then
      install_package "nodejs"
    fi

    if ! check_tool "ruby-install" "ruby-install"; then
      install_package "ruby-install"
    fi

    # Virtualization & Containers
    if ! check_tool "docker" "docker"; then
      install_package "docker"
    fi

    if ! check_tool "docker-compose" "docker-compose"; then
      install_package "docker-compose"
    fi

    if ! check_tool "qemu-system-x86_64" "qemu-full"; then
      install_package "qemu-full"
    fi

    # System utilities
    if ! check_tool "asusctl" "asusctl"; then
      install_package "asusctl" true
    fi

    if ! check_tool "nbfc" "nbfc"; then
      install_package "nbfc" true
    fi

    if ! check_tool "blueman-manager" "blueman"; then
      install_package "blueman"
    fi

    # Browser
    if ! check_tool "zen" "zen-browser-bin"; then
      install_package "zen-browser-bin" true
    fi

    # Fonts
    log_info "Installing fonts..."
    install_package "noto-fonts"
    install_package "noto-fonts-cjk"
    install_package "noto-fonts-emoji"
    install_package "ttf-fira-code"
    install_package "ttf-firacode-nerd"
    install_package "ttf-dejavu"

    # Shell enhancements
    if ! check_tool "zsh" "zsh"; then
      install_package "zsh"
    fi

    if ! check_tool "starship" "starship"; then
      install_package "starship"
    fi

    if ! check_tool "fzf" "fzf"; then
      install_package "fzf"
    fi

    if ! check_tool "rg" "ripgrep"; then
      install_package "ripgrep"
    fi

    if ! check_tool "eza" "eza"; then
      install_package "eza"
    fi

    if ! check_tool "bat" "bat"; then
      install_package "bat"
    fi

   # Install yay if not present (needed for AUR packages)
  if ! command -v yay &>/dev/null; then
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
  local temp_dir="/tmp/arch-dots-setup"
  local repo_url="${REPO_URL:-https://github.com/gitfudge0/arch-dots.git}"

  # Create backup of existing configs
  if [[ -d "$config_dir" ]]; then
    log_info "Creating backup of existing configs at $backup_dir"
    mkdir -p "$backup_dir"

   for app in hypr waybar wofi swaync lazygit ghostty kitty gtk zsh; do
       if [[ -d "$config_dir/$app" ]]; then
         log_info "Backing up existing $app config"
         cp -r "$config_dir/$app" "$backup_dir/"
       fi
     done
  fi

  # Clone repository to temp directory
  log_info "Cloning dotfiles repository..."
  rm -rf "$temp_dir"
  if git clone "$repo_url" "$temp_dir" 2>/dev/null; then
    log_success "Repository cloned successfully"
  else
    log_error "Failed to clone repository"
    return 1
  fi

  # Create config directory
  mkdir -p "$config_dir"

   # Copy each config directory
   for app in hypr waybar wofi swaync lazygit ghostty kitty gtk zsh; do
     if [[ -d "$temp_dir/$app" ]]; then
       log_info "Setting up $app configuration..."
       cp -r "$temp_dir/$app" "$config_dir/"
       log_success "$app configuration copied"
     else
       log_warning "$app configuration not found in repository"
     fi
   done

  # Make scripts executable
  if [[ -d "$config_dir/hypr/scripts" ]]; then
    log_info "Making hypr scripts executable..."
    chmod +x "$config_dir/hypr/scripts"/*.sh 2>/dev/null
  fi

  # Setup GTK directories structure
  log_info "Setting up GTK configuration directories..."
  mkdir -p "$config_dir/gtk-3.0" "$config_dir/gtk-4.0"

  # Copy GTK-3.0 configs if they exist in the gtk folder
  if [[ -d "$config_dir/gtk/gtk-3.0" ]]; then
    cp "$config_dir/gtk/gtk-3.0"/* "$config_dir/gtk-3.0/" 2>/dev/null
    log_success "GTK-3.0 configuration installed"
  fi

  # Copy GTK-4.0 configs if they exist in the gtk folder
  if [[ -d "$config_dir/gtk/gtk-4.0" ]]; then
    cp "$config_dir/gtk/gtk-4.0"/* "$config_dir/gtk-4.0/" 2>/dev/null
    log_success "GTK-4.0 configuration installed"
  fi

  # Copy root-level starship.toml if it exists
  if [[ -f "$temp_dir/starship.toml" ]]; then
    cp "$temp_dir/starship.toml" "$config_dir/"
    log_success "Starship configuration installed"
  fi

  # Set proper permissions
  chmod -R 755 "$config_dir"

  # Clean up temp directory
  rm -rf "$temp_dir"

  log_success "Configuration files setup complete"
}

# Enable necessary services
enable_services() {
   log_info "Enabling system services..."

   # Enable and start services if not already running
   services=("bluetooth" "NetworkManager" "docker")

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

   # Add current user to docker group
   if ! groups | grep -q docker; then
     log_info "Adding user to docker group..."
     sudo usermod -aG docker "$USER"
     log_warning "Please log out and log back in for docker group membership to take effect"
   fi

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
   echo -e "${YELLOW}6.${NC} Install rust-analyzer: rustup component add rust-analyzer"
   echo -e "${YELLOW}7.${NC} Configure default shell: chsh -s /bin/zsh"
   echo -e "${YELLOW}8.${NC} Install docker-desktop from GUI or: yay -S docker-desktop"
   echo ""
   echo -e "${BLUE}🔧 Useful Commands:${NC}"
   echo -e "${YELLOW}•${NC} Super + Return: Open terminal"
   echo -e "${YELLOW}•${NC} Super + B: Open browser (zen)"
   echo -e "${YELLOW}•${NC} Super + R: Open application launcher (wofi)"
   echo -e "${YELLOW}•${NC} Super + X: Open power options"
   echo -e "${YELLOW}•${NC} Super + Shift + S: Open screenshot menu (grim + slurp + swappy)"
   echo -e "${YELLOW}•${NC} Super + Shift + F: Flameshot GUI"
   echo ""
   echo -e "${BLUE}🖥️ Waybar Features:${NC}"
   echo -e "${YELLOW}•${NC} Idle Inhibitor: Click the caffeine icon to prevent screen sleep"
   echo -e "${YELLOW}•${NC} Power Menu: Click the power icon to access shutdown/reboot/logout options"
   echo -e "${YELLOW}•${NC} Disk Usage: Shows current disk space usage"
   echo -e "${YELLOW}•${NC} Bluetooth: Click to open blueman-manager"
   echo ""
   echo -e "${BLUE}🛠️ Development Tools:${NC}"
   echo -e "${YELLOW}•${NC} Rust: rustup, cargo, rust-analyzer"
   echo -e "${YELLOW}•${NC} Go, Deno, Node.js: Ready to use"
   echo -e "${YELLOW}•${NC} Docker: Configure with 'docker ps' after login"
   echo -e "${YELLOW}•${NC} QEMU: For virtualization"
   echo ""
   echo -e "${BLUE}⚙️ System Tools:${NC}"
   echo -e "${YELLOW}•${NC} asusctl: ASUS device control"
   echo -e "${YELLOW}•${NC} nbfc: Notebook fan control"
   echo -e "${YELLOW}•${NC} blueman: Bluetooth management GUI"
   echo -e "${YELLOW}•${NC} starship: Prompt customization via ~/.config/starship.toml"
   echo ""
   echo -e "${BLUE}🎙️ Optional: Voice Input (hyprwhspr):${NC}"
   echo -e "${YELLOW}•${NC} Install: yay -S hyprwhspr"
   echo -e "${YELLOW}•${NC} Setup: hyprwhspr-setup (configure your API key)"
   echo -e "${YELLOW}•${NC} Enable in waybar: uncomment hyprwhspr module in ~/.config/waybar/config.jsonc"
   echo ""
   echo -e "${BLUE}📁 Backup Location:${NC}"
   echo -e "Your original configs were backed up to: ${backup_dir:-N/A}"
   echo ""
   echo -e "${GREEN}✨ Enjoy your new Arch Linux setup!${NC}"
}

# Ask for user confirmation
ask_permission() {
   echo -e "${YELLOW}This script will:${NC}"
   echo -e "${YELLOW}•${NC} Install Hyprland and related packages (hyprland, waybar, wofi, swaync, etc.)"
   echo -e "${YELLOW}•${NC} Install terminal emulators (kitty, ghostty)"
   echo -e "${YELLOW}•${NC} Install development tools (lazygit, rustup, go, deno, nodejs, ruby-install, rust-analyzer)"
   echo -e "${YELLOW}•${NC} Install screenshot tools (grim, slurp, swappy, flameshot)"
   echo -e "${YELLOW}•${NC} Install virtualization tools (docker, docker-compose, qemu-full)"
   echo -e "${YELLOW}•${NC} Install system utilities (asusctl, nbfc, blueman)"
   echo -e "${YELLOW}•${NC} Install zen-browser-bin"
   echo -e "${YELLOW}•${NC} Install fonts (Noto, Fira Code, Nerd Fonts, DejaVu)"
   echo -e "${YELLOW}•${NC} Install shell enhancements (zsh, starship, fzf, ripgrep, eza, bat)"
   echo -e "${YELLOW}•${NC} Install yay AUR helper if not present"
   echo -e "${YELLOW}•${NC} Backup existing configs and replace them with gitfudge's dotfiles"
   echo -e "${YELLOW}•${NC} Enable system services (bluetooth, NetworkManager, docker)"
   echo -e "${YELLOW}•${NC} Configure docker for current user"
   echo ""
   echo -e "${RED}WARNING:${NC} Existing configurations will be backed up but replaced!"
   echo ""

   while true; do
     read -p "Do you want to continue? (y/N): " yn
     case $yn in
     [Yy]*)
       log_info "Starting installation..."
       break
       ;;
     [Nn]*)
       log_info "Installation cancelled by user"
       exit 0
       ;;
     "")
       log_info "Installation cancelled by user"
       exit 0
       ;;
     *)
       echo "Please answer yes (y) or no (n)."
       ;;
     esac
   done
}

# Main execution
main() {
  echo -e "${BLUE}"
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║                   Arch Linux Dotfiles Setup                  ║"
  echo "║                          gitfudge                            ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  check_arch
  # ask_permission
  install_tools
  setup_configs
  enable_services
  print_next_steps
}

# Run main function
main "$@"
