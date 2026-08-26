#!/bin/bash
# Get the target workspace from the argument
target_workspace=$1

if [ -z "$target_workspace" ]; then
    echo "Error: No target workspace provided"
    exit 1
fi

current_workspace=$(hyprctl activewindow -j | jq '.workspace.id')
if [ -z "$current_workspace" ]; then
    echo "Error: Couldn't determine current workspace"
    exit 1
fi

echo "Moving from workspace $current_workspace to $target_workspace"

window_addresses=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $current_workspace) | .address")

for address in $window_addresses; do
    echo "Moving window $address to workspace $target_workspace"
    hyprctl dispatch "hl.dsp.window.move({ workspace = $target_workspace, window = \"address:$address\", follow = false })"
done

echo "Finished moving windows"

hyprctl dispatch "hl.dsp.focus({ workspace = \"$target_workspace\" })"
echo "Switched to workspace $target_workspace"
