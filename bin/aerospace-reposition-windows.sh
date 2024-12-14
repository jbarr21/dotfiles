#!/bin/bash
# Simple aerospace script to set the application windows to my preferred workspaces

# $1 = app name (grep filter)
# $2 = workspace number/letter
function move_app_to_workspace() {
   window_ids=$(aerospace list-windows --all | grep -i $1 | awk '{print $1}')
   for id in $window_ids; do
       aerospace move-node-to-workspace --window-id "$id" $2
   done
}

move_app_to_workspace calendar S
move_app_to_workspace chatgpt G
move_app_to_workspace chrome W
move_app_to_workspace code C
move_app_to_workspace gmail S
move_app_to_workspace intellij C
move_app_to_workspace iterm T
move_app_to_workspace obsidian K
move_app_to_workspace projector C
move_app_to_workspace slack S
move_app_to_workspace spotify M
move_app_to_workspace studio C
