#!/usr/bin/env bash
## Installs useful CLI tools and Applications on macOS
## Invoke using `dcd install common`

eval "$(dcd colors get)"
eval "$(dcd colors log)"
exec 2>/dev/null

[[ "$(uname)" == "Darwin" ]] || exit -1;  # make sure this is macOS

##### LIST #####
formulae="
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
pyinstaller
dnscrypt-proxy
mc
"

casks="
--cask sublime-text
--cask github
--cask 1password@nightly
--cask pycharm-ce
--cask firefox
--cask chromium
--cask google-chrome
--cask wireshark
--cask gimp
--cask xquartz
--cask microsoft-remote-desktop
--cask midnight-commander
--cask vscodium
"
##############

checkBrew(){
  # Check for Homebrew
  [[ -z "$(brew --prefix 2>/dev/null | wc -l | awk '{print $1}')" ]] && \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";

  (brew update && brew upgrade) || return 1;
  brew cleanup;
  brew doctor;

  return 0;
}

# main
main(){
  checkBrew || exit 1;

  log "${BMAGENTA}Installing${NC}: Common programs using ${GREEN}brew${NC}";
  xargs brew install <<< $formulae;
  xargs brew install --cask <<< $casks;
  ##TODO: for each: xattr -c <InstalledApplication.app>
  ##TODO: -- can get InstalledApplication's Path using: `<install command> | awk -F"'" '{print $4}' of last line of the brew output`
}

main;
