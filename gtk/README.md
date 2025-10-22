# GTK Configuration

This directory contains GTK theme and styling configuration for both GTK 3.0 and GTK 4.0.

## Directory Structure

```
gtk/
├── gtk-3.0/
│   ├── settings.ini     # GTK3 settings
│   └── gtk.css          # GTK3 custom theme (Tokyonight Moon)
└── gtk-4.0/
    ├── settings.ini     # GTK4 settings
    └── gtk.css          # GTK4 custom theme (Tokyonight Moon)
```

## Installation

The setup.sh script automatically copies these configurations to:
- `~/.config/gtk-3.0/`
- `~/.config/gtk-4.0/`

## Theme Details

**Theme:** Adwaita Dark
**Icon Theme:** Papirus Dark
**Cursor Theme:** Adwaita (24px)
**Font:** Noto Sans 10
**Monospace Font:** Fira Code 9
**Color Scheme:** Tokyonight Moon

### Colors

| Element | Color |
|---------|-------|
| Background | #1e2030 |
| Surface | #222436 |
| Surface Alt | #2f334d |
| Header/Darker | #191b29 |
| Text | #c8d3f5 |
| Text Secondary | #a9b8e8 |
| Accent | #82aaff |
| Link | #86e1fc |
| Success | #c3e88d |
| Warning | #ffc777 |
| Error | #ff757f |

## Customization

Edit the appropriate files:

**For GTK 3 apps:** Edit `~/.config/gtk-3.0/gtk.css`
**For GTK 4 apps:** Edit `~/.config/gtk-4.0/gtk.css`
**For settings:** Edit the corresponding `settings.ini`

### Changing Theme

Edit `settings.ini` in each directory:
```ini
gtk-theme-name=adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=Adwaita
```

### Available Themes

- `adwaita-dark` (default)
- `adwaita`
- `Yaru-dark`
- Any installed GTK theme

### Available Icon Themes

- `Papirus-Dark` (default)
- `Papirus`
- `hicolor`
- Any installed icon theme

## Font Configuration

Edit the font settings in `settings.ini`:

```ini
gtk-font-name=Noto Sans 10
gtk-monospace-font-name=Fira Code 9
```

### Installed Fonts

- Noto Sans (default)
- Noto Sans CJK (for CJK characters)
- Fira Code (monospace, development)
- DejaVu Sans (fallback)
- Nerd Fonts (icons in terminal)

## Cursor Size

Adjust cursor size in `settings.ini`:
```ini
gtk-cursor-theme-size=24
```

Common sizes: 16, 20, 24, 32, 48

## Removing Custom CSS

If custom CSS causes issues, you can temporarily disable it:
- Remove or rename `~/.config/gtk-3.0/gtk.css`
- Remove or rename `~/.config/gtk-4.0/gtk.css`

Then reload apps to see GTK defaults.

## HiDPI Scaling

For high-DPI displays, adjust in `settings.ini`:
```ini
gtk-xft-dpi=98304
```

Formula: DPI * 1024 (e.g., 96 DPI = 98304)

## Additional Settings

- `gtk-application-prefer-dark-theme=true` - Always use dark theme
- `gtk-button-images=false` - Hide button images
- `gtk-menu-images=false` - Hide menu item images
- `gtk-enable-event-sounds=true` - Enable system sounds
- `gtk-enable-input-feedback-sounds=false` - Disable input sounds
