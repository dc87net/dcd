#!/usr/bin/env bash

eval "$(dcd colors get)"

# Check for Homebrew
[[ -z "$(brew --prefix 2>/dev/null | wc -l | awk '{print $1}')" ]] && \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew upgrade
#######################################################################################################################
#- Prerequsites
brew install go # go is a language developed by Google

#- Clone and build tlock
git clone https://github.com/drand/tlock
go build cmd/tle/tle.go