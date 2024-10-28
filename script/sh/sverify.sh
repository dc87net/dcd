#!/usr/bin/env zsh

eval "$(dcd colors get)"

cd /usr/libexec || exit -100;

cFolder="$1"                    ##TODO: the folder to hash                    [directory - in]
outFolder="/opt/reg"            ##TODO: the destination folder/base path      [path - internal]
outFile="$(date '+%s').txt"     ##TODO: the location of where to save things  [file - out]
outDest="$outFolder/$outFile"   ##TODO: the fully-qualified destination       [path - out]
tfile=$(eval mktemp || exit -1) ##TODO: temporary file to store results       [file - temp]

[[ -f "$cFolder" ]] || cFolder="$(pwd)";

{
  log "$(dcd box FILE.CHECK)"
  log "${MAGENTA}   temp@${NC}\t ${CYAN}$tfile${NC}"
  log "${MAGENTA}   ARG1:${NC}\t ${CYAN}$1${NC}"
  log "${MAGENTA}cFolder@${NC}\t ${CYAN}$cFolder${NC}"
  log "${MAGENTA}   dest@${NC}\t ${CYAN}$outFile${NC}"
  echo;
  echo;
}; (log "Listing: ${BCYAN}$cFolder${NC}") > /dev/stderr; echo;

chmod 700 "$tfile"; #sudo chflags uappnd "$tfile" || exit -2;
echo "%%&\t${}" >> $tfile || exit -3;
files="$(dcd files)";
echo -e "$files" | awk '{print $0}' | xargs -I{} shasum -a 256 '''{}''' | tee -a "$tfile";

for folder in $folders; do
  count=$((count+1));
  echo "count: $count";
  echo "$folder";
done

mv "$tfile" "$outFile" && exit 0 || exit -5;



##TODO: notes
#/System/Library/CoreServices/Software
#| grep HashFull | awk -F'=' '{print $2}'
