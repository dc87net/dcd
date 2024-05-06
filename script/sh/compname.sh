#!/bin/bash

alias scutil="/usr/sbin/scutil"

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Script is not running as root. Requesting elevated privileges..."
  # Relaunch the script with sudo
  exec sudo /bin/bash "$0" "$@"
  exit
fi

# Process args
for arg in $@; do
  if [ $arg == '' ]; then
    echo -e "scutil@\t $(realpath scutil)"
    echo -e "Computer:\t $(scutil --get ComputerName)"
    echo -e "LocalHost:\t $(scutil --get ComputerName)"
    echo -e "Local:\t $(scutil --get ComputerName)"
  fi
done

newName="dc87air"
settings=("ComputerName" "LocalHostName" "HostName")

for setting in "${settings[@]}"; do
  scutil --set "$setting" "$newName"
done

echo "Names have been updated successfully."

