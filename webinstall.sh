#!/usr/bin/env zsh
## This script can be called directly from any macOS computer, facilitating installation of the most current version
##   sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/dc87net/dcd/main/webinstall.sh)"

#- Key Variables for installation
# -- Git Repo --
gitSrc='https://github.com/dc87net/dcd'
colorsSrc='https://raw.githubusercontent.com/dc87net/dcd/main/script/sh/colors.sh'


# *ENSURE* the script is running as **root** !!!
[[ "$EUID" -ne 0 ]] && {
  echo "⚠️  Script not running as root; requesting elevated privileges ..."
  # Relaunch the script with sudo
  exec sudo /usr/bin/env zsh "$0" "$@"
  exit 101;
}

# Get color definitions and log() function; N.B., alternately: `source <(curl -fsSL $colorsSrc)`
eval "$(curl -fsSL "$colorsSrc")" && log "Fetched colors/log fxn@  <${CYAN}$colorsSrc${NC}> ... ${BGREEN}OK!${NC}" \
  || exit 1;  ## <-- HERE WE MAKE SURE THAT WE WERE ABLE TO CONTACT REPO AND DOWNLOAD FROM IT!
# shellcheck disable=SC1090
log "Installing ${BCYAN}dcd${NC}; web source${GRAY}@  <${BBLUE}${gitSrc}${NC}> ..."

# Local system variables
gitDir='/Users/Shared/script'
installDir='/opt/script'
installUser="$(ps -p $PPID | awk '{$NF}')"
log "Installing user:  $installUser"

log "Create git and install directories ..."
# Create the local copy of the git source
sudo mkdir -p "$gitDir"
# Create the installation directory
sudo mkdir -p "$installDir"

# Download the package
log "Downloading from git repo ..."
cd "$gitDir" || { echo "Error: Failed to access $gitDir"; exit -1; }
git clone "$gitSrc" "$gitDir" || { log "${RED}Error${NC}: Failed to ${BRED}clone${NC} into ${CYAN}$gitDir${NC}"; }
git fetch && log "Synchronized with repo ... ${BGREEN}OK${NC}!" || { log "${RED}Error${NC}: Failed to ${BRED}fetch${NC} from ${CYAN}$gitDir${NC}"; }

# Install the package
log "${BMAGENTA}Installing${NC} ..."
res1=$(sudo bash install.sh) || { echo "Error: Install failed:  $res1"; }

# Set perms on gitDir and installDir
sudo chown "$installUser" "$gitDir"
sudo chmod a+r "$gitDir"
sudo chown "$installUser" "$installDir"
sudo chmod a+r,g+x "$installDir"
