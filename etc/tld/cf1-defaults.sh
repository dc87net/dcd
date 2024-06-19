#!/usr/bin/env bash
## This script...

#- Important constants
readonly DIR=' /opt/tdata'

#- #######################################################################
#- Imports
eval "$(dcd colors get)"
eval "$(dcd colors log)"

#- Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  log "Script is not running as ${RED}root${NC}. ${BYELLOW}Requesting elevated privileges${NC} ..."
  # Relaunch the script with sudo
  exec sudo /bin/bash "$0" "$@"
  exit
fi

#- Return "variables"
export res1=''
export res2=''

#- TODO>ICAjIyBleGFtcGxlIHVzZQogICNlIHRlc3QKICAjZWNobyAKICAjZCAKICAjZWNobyAKCg==
e(){
  :
  res1=$(base64 <<< "$1")
}

d(){
  :
  res2=$(base64 -d <<< "$1")
}

log "Preparing ..."
#- main()
{     # ensure atomicity
  run(){
    :
    eval "$*"
  }

  (   # run in a subshell to ensure env
    log "main(): $(whoami)"
    ##- ensure we use the real binaries
    bash='/bin/bash'
    chmod='/bin/chmod'
    chown='/usr/sbin/chown'
    mkdir='/bin/mkdir'
    sudo='/usr/bin/sudo'
    touch='/usr/bin/touch'
    ls='/bin/ls'

    ##- get 'er done
    eval $sudo $mkdir -p "${DIR}"        # create the data directory PRN
    eval $sudo $chown -R root "${DIR}"   # set ownership to root
    eval $sudo $chmod -R 700 "${DIR}"    # only root +rwx
    eval $touch "$DIR/test.txt"
    eval "$ls" -laOG "$DIR"
  )
}