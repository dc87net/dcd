#!/usr/bin/env zsh
## Facilitates saving a man page to html, preserving some formatting such as headings, bold text, and bulleted lists.

eval "$(dcd colors get)"
user="$(dcd user)"

[[ "$1" ]] && : || { echo -e "Usage:\n  ${MAGENTA}saveman${NC} ${YELLOW}utility ${CYAN}[manwidth]${NC}"; }
[[ "$2" ]] && MANWIDTH="$2" || MANWIDTH='120'

export saveLocation="/Users/${user}/Downloads/manpage";
log "Exporting man page for \`${MAGENTA}${1}${NC}\` to <${CYAN}${saveLocation}${NC}>"
mkdir -p "$saveLocation" 2>/dev/null || {
  log "${BRED}ERROR${NC}: ${RED}Unable to create destination directory";
  exit 3;
}

# Get the man page, formatted to be "$2" columns wide.
(MANWIDTH="${MANWIDTH}" man $1) | man2html | sudo tee "$saveLocation/$1.htm" >/dev/null \
  || { log "${BRED}ERROR${NC}: ${RED}Error in creation pipe${NC}"; exit 3; }

# shellcheck disable=SC2015
[[ "$(whoami)" != "$user" ]] && {
  log "The destination was created under a different uid.  You must enter the ${YELLLOW}sudo${NC} password."
  sudo chown -R "$user" "$saveLocation" || exit 2;
  sudo chmod -R 755 "$saveLocation" || exit 1;
}; # || { # Encountered an error
#  log "${RED}Error: Aborted due to permissions error...${NC}"
#  exit -1;
#}

exit 0