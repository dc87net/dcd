#!/usr/bin/env zsh
eval "$(dcd colors get)"


args="$(base64 -d "$*")"
log "args: ${YELLOW}$args${NC}"

export term1='';
export termR='';
extractTerm(){
  [[ "$*" != '' ]] || { log "Error: extractTerm: void"; return; };
  term1="$1";
  shift;
  termR="$*";
}


lsofGrep(){
  :
}

extractTerm 'TCP' "'testing once' 'twice'"
echo -e "<1>\t$term1"
echo -e "<R>\t$termR"
extractTerm "${termR}"
echo -e "<1>\t$term1"
echo -e "<R>\t$termR"
#########
# lsof -a -d 0-999999 | grep TCP | grep "$findMe" | xargs -I{} echo -e {} | cut -d'>' -f2 | cut -d':' -f1 | xargs -I{} dig -x {} +authority | grep SOA

}
