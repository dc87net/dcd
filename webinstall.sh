#!/usr/bin/env bash
## This script can be called directly from any macOS computer, facilitating installation of the most current version
##   sh -c "$(curl -fsSL https://raw.githubusercontent.com/dc87net/dcd/main/webinstall.sh)"

#- Key Variables for installation
# Git Repo
gitSource='https://github.com/dc87net/dcd'
# Local system variables
gitDir='/Users/Shared/script'
installDir='/opt/script'
installUser="$(ps -p $PPID | awk '{$NF}')"

# Create the local copy of the git source
sudo mkdir -p "$gitDir"
sudo chown "$installUser" "$gitDir"

# Create the installation directory
sudo mkdir -p "$installDir"
sudo chown "$installUser" "$installDir"
chmod 777 "$installDir"

# Download the package
cd "$gitDir" || { echo "Error: Failed to access $gitDir"; exit -1; }
git clone "$gitSource" "$gitDir" || { echo "Error: Failed clone source to $gitDir"; exit -2; }

# Install the package
res1=$(sudo bash install.sh) || { echo "Error: Install failed:  $res1"; exit 1; }