#!/bin/bash

# Dynamic monitor configuration script
# Automatically positions external monitors above the built-in display (model 0x419D)

# Get monitor information in JSON format
MONITOR_INFO=$(hyprctl monitors -j)

# Find the built-in monitor (model 0x419D)
BUILTIN_MONITOR=$(echo "$MONITOR_INFO" | jq -r '.[] | select(.model == "0x419D") | .name')
BUILTIN_WIDTH=$(echo "$MONITOR_INFO" | jq -r '.[] | select(.model == "0x419D") | .width')
BUILTIN_HEIGHT=$(echo "$MONITOR_INFO" | jq -r '.[] | select(.model == "0x419D") | .height')
BUILTIN_REFRESH=$(echo "$MONITOR_INFO" | jq -r '.[] | select(.model == "0x419D") | .refreshRate')

if [ -z "$BUILTIN_MONITOR" ]; then
  echo "Error: Built-in monitor (model 0x419D) not found"
  exit 1
fi

echo "Found built-in monitor: $BUILTIN_MONITOR (${BUILTIN_WIDTH}x${BUILTIN_HEIGHT}@${BUILTIN_REFRESH}Hz, scale: ${BUILTIN_SCALE})"

# Scale
SCALE=1.875

# Configure the built-in monitor first (positioned at center bottom)
BUILTIN_X_OFFSET=480 # Center the built-in monitor
hyprctl keyword monitor "$BUILTIN_MONITOR,${BUILTIN_WIDTH}x${BUILTIN_HEIGHT}@${BUILTIN_REFRESH},${BUILTIN_X_OFFSET}x0,${SCALE}"

# Find and configure external monitors
EXTERNAL_MONITORS=$(echo "$MONITOR_INFO" | jq -r '.[] | select(.model != "0x419D") | .name')

if [ -z "$EXTERNAL_MONITORS" ]; then
  echo "No external monitors detected"
  exit 0
fi

# Process each external monitor
echo "$EXTERNAL_MONITORS" | while read -r MONITOR_NAME; do
  if [ -n "$MONITOR_NAME" ]; then
    # Get external monitor details
    EXT_WIDTH=$(echo "$MONITOR_INFO" | jq -r ".[] | select(.name == \"$MONITOR_NAME\") | .width")
    EXT_HEIGHT=$(echo "$MONITOR_INFO" | jq -r ".[] | select(.name == \"$MONITOR_NAME\") | .height")
    EXT_REFRESH=$(echo "$MONITOR_INFO" | jq -r ".[] | select(.name == \"$MONITOR_NAME\") | .refreshRate")
    EXT_MODEL=$(echo "$MONITOR_INFO" | jq -r ".[] | select(.name == \"$MONITOR_NAME\") | .model")

    # Calculate Y position (above the built-in monitor)
    # Using negative Y to position above
    # Use bc for floating point arithmetic or approximate with fixed offset
    EXT_Y_POSITION=-1180 # Fixed offset based on your current config

    echo "Configuring external monitor: $MONITOR_NAME ($EXT_MODEL) - ${EXT_WIDTH}x${EXT_HEIGHT}@${EXT_REFRESH}Hz, scale: ${EXT_SCALE}"
    echo "Positioning at: 0x${EXT_Y_POSITION}"

    # Configure the external monitor
    hyprctl keyword monitor "$MONITOR_NAME,${EXT_WIDTH}x${EXT_HEIGHT}@${EXT_REFRESH},0x${EXT_Y_POSITION},${SCALE}"
  fi
done

echo "Monitor configuration complete!"

