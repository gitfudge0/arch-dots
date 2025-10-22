#!/bin/bash

# This script listens for Hyprland workspace change events
# and calls the workspace-handler.sh script with the new workspace ID.

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    if [[ $line == workspace* ]]; then
        WORKSPACE_ID=$(echo "$line" | sed -e 's/workspace>>//' -e 's/workspacev2>>//' | cut -d ',' -f 1)
        ~/.config/hypr/scripts/workspace-handler.sh "$WORKSPACE_ID"
    fi
done
