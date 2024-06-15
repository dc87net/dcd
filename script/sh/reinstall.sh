#!/usr/bin/env zsh

eval "$(dcd colors get)"
log "${MAGENTA}$(date)${NC}"
#source "$installTo/bin/colors"

# Get necessary information
log "Reading defaults ..."
installFrom="$(defaults read /opt/script/config.plist installFrom)"
log "${MAGENTA}FROM${NC}:\t ${CYAN}$installFrom${NC}"
installTo="$(defaults read /opt/script/config.plist installTo)"
log "${MAGENTA}TO${NC}:\t ${BCYAN}$installTo${NC}"

log "Preparing ..."
cd "$installFrom" || exit -2  # make sure we are in the right place
log "Switched to source directory!"

log "Beginning re-install ..."
#log "\t${BMAGENTA}Note${NC}: a few minor errors may occur, but everything should be fine!"
(exec sudo bash install.sh)
echo; log "${BGREEN}Complete!${NC}" # unreachable?