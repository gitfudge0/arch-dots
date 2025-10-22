#!/bin/bash

# This script sets a specific wallpaper based on the workspace ID.
# It's designed to be called by Hyprland when switching workspaces.

# Exit if no workspace ID is provided
if [ -z "$1" ]; then
    echo "No workspace ID provided."
    exit 1
fi

WORKSPACE_ID=$1
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
TOTAL_WALLPAPERS=5 # We have a set of 5 wallpapers

# Calculate the wallpaper index with wraparound
# e.g., Workspace 1 -> Wallpaper 1, Workspace 6 -> Wallpaper 1
WALLPAPER_INDEX=$(( ( (WORKSPACE_ID - 1) % TOTAL_WALLPAPERS) + 1 ))

# Find the wallpaper file, which could have any extension (jpg, png, etc.)
WALLPAPER_FILE=$(find "$WALLPAPER_DIR" -name "$WALLPAPER_INDEX.*" | head -n 1)

# If a wallpaper is found, set it
if [ -n "$WALLPAPER_FILE" ]; then
    hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER_FILE"
    echo "Set wallpaper for workspace $WORKSPACE_ID to $WALLPAPER_FILE"
else
    echo "Wallpaper for index $WALLPAPER_INDEX not found."
fi
