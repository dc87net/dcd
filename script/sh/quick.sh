#!/usr/bin/env zsh

eval "$(dcd colors get)"

CMDS="$*";
CMD="$1"; shift
log "${BYELLOW}Command String${NC}: <${MAGENTA} $CMDS ${NC}> "


[[ -n "$CMD" ]] &&{
  [[ "$CMD" == 'v6off' ]]&&\
    networksetup -listallnetworkservices | grep -v '*' | xargs -I{} networksetup -setv6off '{}';
}||{ log "${BRED}ERROR:${NC} No quick command specified!"; };