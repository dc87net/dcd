#!/usr/bin/env zsh

clear
eval "$(dcd colors get)"
tfile=$(mktemp)

log "file: ${BCYAN}$tfile${NC}"
log "Scratch pad:"

cat - &>> $tfile

echo -en "${GREEN}Save file @  >>> "

read res1; eval "res1=$res1"
[[ "$res1" ]] && {
  cp "$tfile" "$res1" || log "Unable to save at $res1"
  log "${BGREEN}Saved${NC} as ${CYAN}$res1${NC}";
} || {
  log "Discarding contents ..."
};

rm -f $tfile