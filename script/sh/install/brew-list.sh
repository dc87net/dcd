#!/usr/bin/env bash
## Installs useful CLI tools and Applications on macOS
## Invoke using `dcd install common`

eval "$(dcd colors get)"
eval "$(dcd colors log)"
#exec 2>/dev/null

[[ "$(uname)" == "Darwin" ]] || exit -1;  # make sure this is macOS

##### LIST #####
formulae="
parallel
wget
htop
iftop
tree
1password-cli@beta
neofetch
screen
parallel
brave-browser
watch
python@3.12
python-argcomplete
xclip
pyinstaller
dnscrypt-proxy
mc
tcl-tk
pandoc
man2html
groff
ghostscript
aha
enscript
"

casks="
--cask commander-one
--cask sublime-text
--cask github
--cask 1password@nightly
--cask pycharm-ce
--cask firefox
--cask chromium
--cask google-chrome
--cask wireshark
--cask microsoft-remote-desktop
--cask vscodium
--cask db-browser-for-sqlite
"
#--cask xquartz
#--cask gimp

#python3-argcomplete xclip
##############

checkBrew(){
  log "Checking for ${CYAN}brew${NC} ..."
  # Check for Homebrew
  [[ -z "$(brew --prefix 2>/dev/null | wc -l | awk '{print $1}')" ]] && {
      log "Installing Homebrew...";
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
  } || { log "${MAGENTA}Homebrew ${BGREEN}found${NC}!"; }

  log "UPDATE WITH HOMEBREW:"
  log "\tUpdating ${BCYAN}brew${NC} ..."
  brew update || exit -100
  log "\tUpdating ${MAGENTA}formulae${NC} ..."
  brew upgrade || exit -101
  log "\tUpdating ${MAGENTA}casks${NC} ..."
  brew upgrade --cask || exit -102;
  sleep 0.5
  log "cleanup ... "; brew cleanup;
  sleep 0.5
  log "doctor ... ";  brew doctor;
  sleep 0.5

  return 0;

}

# main
main(){
  log "Preflight check ..."
  checkBrew && log "${BGREEN}OK${NC}!" || exit 1;

  log "${BMAGENTA}Installing${NC}: Common programs using ${GREEN}brew${NC}";
  xargs -I{} sh -c 'brew install --force --overwrite {}' <<< $formulae;
  xargs -I{} sh -c 'brew install --cask --force {}' <<< "$casks"

  exit 0
  #sudo pip3 install obd --break-system-packages # for Python OBD-II support


  ##TODO: for each: xattr -c <InstalledApplication.app>
  ##TODO: -- can get InstalledApplication's Path using: `<install command> | awk -F"'" '{print $4}' of last line of the brew output`
}

main;
