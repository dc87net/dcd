#!/usr/bin/env zsh

eval "$(dcd colors get)"


[[ "$installTo"  ]]&&{
  log "Install path (reported)@ ${CYAN}$installTo${NC}";
}||{
  export installTo="$(dirname "$(which dcd)")";
  log "Install path [derived] >>\t<${CYAN} $installTo${NC}";
}
[[ "$installTo"  ]] ||{ echo 'Fatal: Unable to determine the installTo path!'; exit 98; }

log "Repairing ${BGREEN}.zshrc${NC} ..."
ZSHRC="$(cat $installTo/etc/0* | tee ~/.zshrc)"
