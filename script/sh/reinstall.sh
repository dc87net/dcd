#!/usr/bin/env zsh


# Get necessary information
installFrom="$(defaults read net.dc87.dcd installFrom)"
installTo="$(defaults read net.dc87.dcd installTo)"
eval "$(dcd colors get)"
source "$installTo/bin/colors"

log "Beginning reinstallation..."
cd "$installFrom" || exit -2  # make sure we are in the right place
log "Switched to source directory!"

log "Beginning reinstallation"
log "\t${BMAGENTA}Note${NC}: some errors may occur, but everything should be fine"
(exec sudo bash install.sh)
echo; log "${BGREEN}Complete!${NC}" # unreachable?