#!/usr/bin/env bash
## Installs useful CLI tools and Applications on macOS
## Invoke using `dcd install common`

eval "$(dcd colors get)"
eval "$(dcd colors log)"
#exec 2>/dev/null

[[ "$(uname)" == "Darwin" ]] || exit 200;  # make sure this is macOS

##### LIST #####
 ## FORMULAE ## alphabetically ordered ##
formulae="
1password-cli@beta
aha
blueutil
brave-browser
dnscrypt-proxy
enscript
ghostscript
groff
htop
iftop
iterm2
man2html
mc
mtr
neofetch
nmap
octave
openssh
openssl
pandoc
parallel
perl
pstree
pyinstaller
python-argcomplete
python@3.12
python3
s3cmd
screen
tcl-tk
tree
watch
wget
xclip
xquartz
"

 ## CASKS ## alphabetically ordered ##
casks="
--cask 1password@nightly
--cask chatgpt
--cask chromium
--cask commander-one
--cask db-browser-for-sqlite
--cask firefox
--cask fleet
--cask gimp
--cask github
--cask google-chrome
--cask imazing
--cask microsoft-remote-desktop
--cask opensc
--cask phpstorm
--cask pycharm-ce
--cask sublime-text
--cask vscodium
--cask wireshark
--cask ykman
--cask xquartz
--cask yubico-yubikey-manager
--cask raspberry-pi-imager
"
#--cask eclipse-ide eclipse-java eclipse-php eclipse-cpp
#--cask chatgpt

## PYTHON PACKAGES ## alphabetically ordered ##
pipList="
binwalk
obd
openai
PyMuPDF
pylatexenc
sympy
numpy
matplotlib
scipy
qtip
"
#sounddevice

##############

checkBrew(){
  log "${CYAN}n.b.${NC}:\t Checking for ${YELLOW}Rosetta${NC} ..."

  log "Checking for ${CYAN}brew${NC} ..."
  # Check for Homebrew
  [[ -z "$(brew --prefix 2>/dev/null | wc -l | awk '{print $1}')" ]] && {
      log "Installing Homebrew...";
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
  } || { log "${MAGENTA}Homebrew ${BGREEN}found${NC}!"; }

  log "UPDATE WITH HOMEBREW:"
  log "\tUpdating ${BCYAN}brew${NC} ..."
  brew update || exit 100
  log "\tUpdating ${MAGENTA}formulae${NC} ..."
  (brew upgrade -g) || { log "${BRED}Error:${RED} Error in formulae upgrade (greedy).${NC}"; exit 102; };
  (brew upgrade --cask -g) || { log "${BRED}Error:${RED} Error in formulae upgrade (greedy).${NC}"; exit 103; }
  log "\tUpdating ${MAGENTA}casks${NC} ..."
  (brew upgrade --cask -g) || exit 104;
  sleep 1
  log "cleanup ... "; brew cleanup;
  sleep 1
  log "doctor ... ";  brew doctor;
  sleep 1

  return 0;

}

ohMy(){
  [[ -d "$HOME/.oh-my-zsh/" ]] ||{
    log "Installing ${RED}O${BRED}H${BYELLOW}M${BGREEN}Y${BLUE}Z${MAGENTA}S${BMAGENTA}H${NC}";
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
    return 0;
  };
  return 1;
}

# main
main(){
  log "Preflight check ..."

  ohMy || log "${RED}Error${NC}:\t${BRED}${NC}"    # Check for Oh My ZSH; install PRN
  checkBrew && log "${BGREEN}OK${NC}!" || exit 1;
  {
    log "${BMAGENTA}Installing${NC}: Common programs using ${CYAN}brew${NC}";
      # Formulae
    log "\tInstalling ${MAGENTA}formulae${NC} ...";
    xargs brew install --force <<< $formulae;
      # Casks
    log "\tInstalling ${MAGENTA}casks${NC} ...";
    xargs -I{} sh -c 'brew install --cask --force {}' <<< "$casks";
      # Common
    log "${BMAGENTA}Installing${NC}: Common programs using ${CYAN}pip3${NC}";
    xargs pip3 install --break-system-packages --trusted-host pypi.org --trusted-host pypi.python.org \
      --trusted-host files.pythonhosted.org <<< "$pipList";

      # Kleopatra (Certificate/PGP Mgmt (by KDE)
    log "${BMAGENTA}Installing${NC}: Kleopatra using ${CYAN}dcd install kleopatra${NC}";

    log "To (re)install ${BCYAN}kleopatra${NC} using:  ${BCYAN}dcd install kleopatra${NC}"  #dcd install kleopatra;
  }

  exit 0
  #sudo pip3 install obd --break-system-packages # for Python OBD-II support


  ##TODO: for each: xattr -c <InstalledApplication.app>
  ##TODO: -- can get InstalledApplication's Path using: `<install command> | awk -F"'" '{print $4}' of last line of the brew output`
}

main;
