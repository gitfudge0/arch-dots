#!/bin/bash

# Battery-aware refresh rate management for Hyprland
# Automatically reduces refresh rate to 60Hz when battery is below 20%

BATTERY_THRESHOLD=20
BATTERY_PATH="/sys/class/power_supply/BAT0"
BATTERY_CAPACITY_FILE="$BATTERY_PATH/capacity"
BATTERY_STATUS_FILE="$BATTERY_PATH/status"

# Check if battery exists
if [ ! -f "$BATTERY_CAPACITY_FILE" ]; then
    echo "Battery not found at $BATTERY_CAPACITY_FILE"
    exit 1
fi

# Get current battery level and status
BATTERY_LEVEL=$(cat "$BATTERY_CAPACITY_FILE")
BATTERY_STATUS=$(cat "$BATTERY_STATUS_FILE")

# Only check when on battery power
if [ "$BATTERY_STATUS" = "Discharging" ]; then
    if [ "$BATTERY_LEVEL" -le "$BATTERY_THRESHOLD" ]; then
        # Switch to 60Hz for power saving
        echo "Battery at ${BATTERY_LEVEL}% - switching to 60Hz"
        hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1.875000"
        # Also reduce animation speeds further
        hyprctl keyword animation "windows,1,2,easeOutQuint"
        hyprctl keyword animation "workspaces,1,1.5,easeOutQuint,slide"
    else
        # Battery > 20%, use preferred refresh rate
        echo "Battery at ${BATTERY_LEVEL}% - using preferred refresh rate"
        hyprctl keyword monitor "eDP-1,preferred,0x0,1.875000"
        # Restore normal animation speeds
        hyprctl keyword animation "windows,1,3.35,easeOutQuint"
        hyprctl keyword animation "workspaces,1,2.1,easeOutQuint,slide"
    fi
else
    # On AC power, always use preferred refresh rate
    echo "On AC power - using preferred refresh rate"
    hyprctl keyword monitor "eDP-1,preferred,0x0,1.875000"
    # Restore normal animation speeds
    hyprctl keyword animation "windows,1,3.35,easeOutQuint"
    hyprctl keyword animation "workspaces,1,2.1,easeOutQuint,slide"
fi