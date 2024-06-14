#!/usr/bin/env zsh


# Get necessary information
installFrom="$(defaults read /opt/script/config.plist installFrom)"
installTo="$(defaults read /opt/script/config.plist installTo)"
eval "$(dcd colors get)"
source "$installTo/bin/colors"

log "${MAGENTA}$(date)${NC}"
log "Beginning reinstallation..."
cd "$installFrom" || exit -2  # make sure we are in the right place
log "Switched to source directory!"

log "Beginning re-install"
log "\t${BMAGENTA}Note${NC}: limited errors may occur, but everything should be fine"
(exec sudo bash install.sh)
echo; log "${BGREEN}Complete!${NC}" # unreachable?