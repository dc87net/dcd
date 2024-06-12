#!/usr/bin/env zsh

eval "$(dcd colors get)"

# Check for Homebrew
[[ -z "$(brew --prefix 2>/dev/null | wc -l | awk '{print $1}')" ]] && \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew upgrade

#- Install prereqs
brew install gnupg
brew install pinentry-mac
brew install algertc/kleopatra4mac/kleopatra

###################
## Apple Silicon ##
###################
[[ $(uname -p) == "arm" ]] || exit -1

#- Start DBUS
brew services start dbus
#- Select pinentry-mac as the Default Program
mkdir -p ~/.gnupg
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
killall -9 gpg-agent

#- Modify PATH to find kleopatra
# shellcheck disable=SC2016
pathAdd='export PATH="/opt/homebrew/opt/kleopatra/bin:$PATH"'
echo "$pathAdd" | grep -v "$pathAdd" >> ~/.zshrc
source ~/.zshrc

#- Add Kleopatra to launchpad
cd /Applications && unzip /opt/homebrew/opt/kleopatra/app.zip
#echo 'export PATH="/Applications/'

##- Kleopatra is keg-only, which means it was not symlinked into `/opt/homebrew` to prevent conflicts; fix:
#export LDFLAGS="-L/opt/homebrew/opt/kleopatra/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/kleopatra/include"

##- For pkg-config to find Kleopatra, set:
#export PKG_CONFIG_PATH="/opt/homebrew/opt/kleopatra/lib/pkgconfig"

open /Applications/kleopatra.app
