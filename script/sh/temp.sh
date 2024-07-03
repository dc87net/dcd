#!/usr/bin/env  zsh

export args="\'${*}\'"  # to pass to subshell

(
dirLocation=$(mktemp -d)
pushd "$dirLocation"
chmod 700 "$dirLocation"
echo "$(ls -laOG $dirLocation)"
echo -e " @ \033[1m $(pwd) \033[0m"

zsh
cd ~
read -p "Press Enter/return to clean up.  Save anything you want to keep now. (Ctrl+d to pause)"
rm -rf "$dirLocation"
)

log "Cleaned up!"
