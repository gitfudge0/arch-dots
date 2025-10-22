#!/bin/bash

# This script sets up and refreshes the wallpaper set.
# 1. Clears the current set of wallpapers.
# 2. Copies 5 new random wallpapers from the dump directory.
# 3. Sets the first new wallpaper as the current one.
# 4. Resets the wallpaper cycle index.

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
DUMP_DIR="$WALLPAPER_DIR/dump"
INDEX_FILE="$HOME/.config/hypr/.current_wallpaper"
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')

# Stop hyprpaper before making changes to avoid issues
killall hyprpaper

# Clear existing numbered wallpapers (jpg and png)
rm -f "$WALLPAPER_DIR"/[1-5].jpg "$WALLPAPER_DIR"/[1-5].png

# Get 5 random files from the dump directory
# Using find and shuf to handle filenames with spaces
mapfile -t FILES < <(find "$DUMP_DIR" -type f | shuf -n 5)

# Copy and rename the new wallpapers
for i in {0..4}; do
    if [ -f "${FILES[$i]}" ]; then
        extension="${FILES[$i]##*.}"
        cp "${FILES[$i]}" "$WALLPAPER_DIR/$((i+1)).$extension"
    fi
done

# Find the first wallpaper to apply (e.g., 1.jpg or 1.png)
FIRST_WALLPAPER=$(find "$WALLPAPER_DIR" -name "1.*" | head -n 1)

if [ -z "$FIRST_WALLPAPER" ]; then
    echo "No new wallpapers were set up. Exiting."
    # Attempt to restart hyprpaper anyway with its last known config
    hyprpaper &
    exit 1
fi

# Update hyprpaper.conf to preload and set the new wallpaper
sed -i "s|preload = .*|preload = $FIRST_WALLPAPER|" "$HOME/.config/hypr/hyprpaper.conf"
sed -i "s|wallpaper = $MONITOR,.*|wallpaper = $MONITOR,$FIRST_WALLPAPER|" "$HOME/.config/hypr/hyprpaper.conf"

# Reset the wallpaper index to 1 for the switcher script
echo "1" > "$INDEX_FILE"

# Start hyprpaper again in the background
hyprpaper &

echo "Wallpaper set has been refreshed. Current wallpaper: $FIRST_WALLPAPER"
