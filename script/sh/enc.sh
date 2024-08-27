#!/usr/bin/env zsh
# Facilitates encrypting and decrypting files using OpenSSL using a passphrase

#eval "$(dcd colors header)"
eval "$(dcd colors get)"
export scriptAsCalled="$0";
export scriptPath="$(realpath "$(dirname "$scriptAsCalled")")"
export argV="$*";
export helpLineText='';  # assigned in help()


log "> $scriptAsCalled"
log "> $scriptPath"
log "> $argV"

help(){
  [[ "$1" ]]&&{
    echo ">>> HELP - < $1 >";
    helpLineText="$(head -n2 "$1" | awk 'BEGIN {RS=""; FS="\n"} {print $2}')"
    log ">> $helpLineText 1";
      { # Parse comment line
      log ">> $helpLineText 2";

      helpLineText2="$(echo "$helpLineText" | sed 's/#//g')";
      log ">> $helpLineText 3";
        echo -e "$RED${helpLineText}<${NC}"
        :
      };
      log ">>> $helpLineText"

    exit 0;
  };
}

help "$0"
