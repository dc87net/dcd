#!/usr/bin/env zsh
## Get or change the computer names on macOS.  There are THREE of them!

alias scutil="/usr/sbin/scutil"

# Check if the script is running as root
[[ "$EUID" -ne 0 ]] && {
  echo "Script is not running as root. Requesting elevated privileges..."
  # Relaunch the script with sudo
  exec sudo /usr/bin/env zsh "$0" "$@"
  exit
}

export settings=("ComputerName" "LocalHostName" "HostName")

# Process args
[[ "$1" == "get" ]] && {
  echo -e "scutil @ \t$(command -v scutil)"
  for setting in "${settings[@]}"; do
    echo -e "$setting:\t $(scutil --get "$setting")"
  done
  exit 0
} || {
  echo -n "New computer name? " && read newName
}

# Update computer names
for setting in "${settings[@]}"; do
  scutil --set "$setting" "$newName"
done

echo "Computer's network Names updated:  $newName"