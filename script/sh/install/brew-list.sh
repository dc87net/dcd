#!/usr/bin/env bash
## Installs useful CLI tools and Applications on macOS
## Invoke using `dcd install common`

eval "$(dcd colors get)"
eval "$(dcd colors log)"
exec 2>/dev/null

[[ "$(uname)" == "Darwin" ]] || exit -1

#### LIST ####r
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
"

casks="
--cask sublime-text
--cask github
--cask 1password@nightly
--cask pycharm-ce
--cask firefox
--cask chromium
"
##############

# main
main(){
  log "${BMAGENTA}Installing${NC}: Common programs using ${GREEN}brew${NC}"
  xargs brew install <<< $formulae
  xargs brew install --cask <<< $casks
  ##TODO: for each: xattr -c <InstalledApplication.app>
  ##TODO: -- can get InstalledApplication's Path using: `<install command> | awk -F"'" '{print $4}' of last line of the brew output`
}

main
