#!/usr/bin/env zsh
## archiver

eval "$(dcd colors get)"


export cmd="$1";
#[[ $cmd ]]&&
#  { echo -e "cmd:\t $cmd">/dev/stderr && shift; } || echo -e "cmd:\t none">/dev/stderr;

if [ -p /dev/stdin ]; then
#  path="$(cat)" || "$PWD";
  :
fi

path=$(mktemp -d)
/bin/chmod 700 "$path" || exit -100
(log "${BMAGENTA}target:${NC}\t${CYAN}$path{NC}")>/dev/stderr

outfile="out.aa"
[[ $1 ]]&& outfile="$1";a
log "$(dcd box 'ARCHIVES...')"


log "\tPATH: < $path >"

aa archive -v -d "$path" -o out.aa 2> /dev/null

[[ $? ]] && log "\t${BGREEN}Success${NC}: Wrote archive@ <${BCYAN} $outfile ${NC} >" ||
  { log "${RED}ERROR:${NC} FAIL"; exit $?; };

rm -rf "$path"

exit 0
