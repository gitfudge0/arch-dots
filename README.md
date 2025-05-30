# Arch Linux Dotfiles

A complete Hyprland config that taught me a lot about desktop environments, inspired from the numerous awe-inspiring r/unixporn posts that made me finally do it for myself.

## Features

- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: Waybar with custom styling
- **Application Launcher**: Wofi with custom themes
- **Notifications**: SwayNC notification daemon
- **Terminal Emulators**: Kitty and Ghostty
- **Screenshot Tool**: Grim, Slurp, Swappy, and jq for advanced screenshot functionality
- **Wallpaper Manager**: Hyprpaper with custom wallpapers
- **Custom Scripts**: Power menu, lock screen, wallpaper switcher, and fan control

## Installation

### Quick Install (Recommended)

Run the automated setup script directly from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/gitfudge0/arch-dots/main/setup.sh | bash
```

## Screenshots

![Desktop Overview](screenshots/desktop.png)

![Ghostty Terminal](screenshots/ghostty.png)

![Wofi Launcher](screenshots/wofi.png)

![Screenshot Tool](screenshots/screenshot.png)

### Manual Installation

1. Clone the repository:

```bash
git clone https://github.com/gitfudge0/arch-dots.git
cd arch-dots
```

2. Run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

### What the Setup Script Does

The installation script will:

- Verify you're running Arch Linux, lol
- Install required packages (hyprland, waybar, wofi, swaync, kitty, ghostty, lazygit, grim, slurp, swappy, jq, hyprpaper)
- Install AUR packages using yay (installs yay if not present)
- Backup your existing configurations to `~/.config-backup-<timestamp>`
- Download and install all configuration files
- Enable necessary system services (bluetooth, NetworkManager)
- Set proper file permissions

## Key Bindings

These are some to get you started. For a full list, check out the hyprland config.

- **Super + Return**: Open terminal
- **Super + B**: zed-browser(make sure you install this)
- **Super + R**: Open application launcher (wofi)
- **Super + X**: Open wofi with power options
- **Super + Shift + S**: Open screenshot wofi menu
- **Super + Q**: Close window

---

**Note**: This configuration is designed specifically for Arch Linux with Hyprland. Backup your existing configurations before installation.
