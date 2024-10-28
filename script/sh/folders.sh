#!/usr/bin/env zsh
## prints all folders in the cwd

eval "$(dcd colors get)"
export targetDir=''

# `cd`  to the target directory
#pushd "$targetDir">/dev/null || { log "Error: Unable to push directory to stack"; exit 1; };

action(){
  # check to see if dir secified; else use cwd
  [[ -z $1 ]] && { targetDir="$(realpath "$1" 2>/dev/null)"2>/dev/null; } || {
   targetDir="$PWD"; };

  # Print header to stderr unless this is quiet mode
#  [[ "$1" == '-q' ]] && shift #|| echo "$(log "$(dcd box \'${targetDir}\')")" > /dev/stderr; # && {
  #  [[ "$1" ]]&&shift; };
  [[ "$1" == '-r' ]]&&{
    list="$(ls -laO | grep -v 'total')";
  }||{
    list="$(ls -F | awk '{print $0}' | grep '/')"
    export c=0;
    for line in $(echo "$list" | awk '{print $0}'); do
      :
      c=$((c+1));
      echo  "${BYELLOW}$targetDir/$line${NC}"
      (cd "$targetDir/$line" 2>/dev/null && action "$targetDir/$line" 2>/dev/null) 2>/dev/null || continue;
    done;
  }
}

action "$1";
