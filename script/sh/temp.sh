#!/usr/bin/env  zsh

export args="\'${*}\'"  # to pass to subshell

eval "$(dcd colors get)"

export clearTmpDate(){
  ls -laOG | grep '"$@"' | grep 'tmp.' | awk '{print $NF}' | xargs -I{} rm -f \'{}\'
}

(
  dirLocation=$(mktemp -d)
  pushd "$dirLocation"
  chmod 700 "$dirLocation"
  log "TEMP@: < $(ls -laOG $dirLocation) >  /  CWD: < $(pwd) >"

  zsh
  cd ~
  export res1=''
  echo -n "Press Enter/return to clean up.  Save anything you want to keep now. (Ctrl+d to pause) >>> "
  while [[ ! "${res1}" ]] {
    read res1;
  }
)

rm -rf "$dirLocation" && log "Cleaned up!" || log "${BRED}}Error${NC}: Unable to remove the temporary files(s) and folder\n\t@ "\
  "${CYAN}$dirLocation${NC}"
