#!/usr/bin/env zsh

# Prep
export installTo="$(defaults read /opt/script/config.plist installTo)"
source "$installTo/etc/colors.sh"
export ME="$(echo "$0" | awk -F' ' '{print $1}')"


[[ "$installTo"  ]]&&{
  log "Install path [${GREEN}reported${NC}] >>\t<${CYAN} $installTo ${NC} >";
}||{
  export installTo="$(dirname "$(which dcd)")";
  log "Install path [${BRED}${NC}] >>\t<${CYAN} $installTo ${NC}>";
}
[[ "$installTo"  ]] ||{ echo 'Fatal: Unable to determine the installTo path!'; exit 98; }

log "Repairing ${BGREEN}.zshrc${NC} (${BYELLOW}this may take a moment${NC}) ..."
ZSHRC="$(cat $installTo/etc/0* | tee ~/.zshrc)"

echo; log "${MAGENTA}$(date)${NC}" && log "A terminal for you, good sir.";
exec zsh

#( zsh )
