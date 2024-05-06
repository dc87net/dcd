#!/bin/bash

dirLocation=$(mktemp -d)
cd "$dirLocation"
chmod 700 "$dirLocation"
echo "$(ls -laOG $dirLocation)"
echo -e " @ \033[1m $(pwd) \033[0m"

zsh
cd ~
rm -rf "$dirLocation"

echo "Cleaned up!"
