#!/usr/bin/false
## Include this using `source` for some ASCII colors
## Usage: echo -e "This is ${RED}red${NC} text!"

export RED='\033[0;31m'
export BLUE='\033[0;34m'
export BLUE2='\033[0;94m'
export CYAN='\033[0;36m'
export GREEN='\033[0;92m'
export YELLOW='\033[0;93m'
export YELLOW2='\033[0;33m'
export MAGENTA='\033[0;35m'
export NC='\033[0m' # No Color

logFile=$(mktemp)

log(){
  echo -e "${YELLOW}==>  ${NC}$*" | tee -a "$logFile"
}
#  cat <<< "$@" | tee -a "$logFile"

demoColoredText(){
  echo -e "==> This is ${RED}red${NC} text!"
  exit 0
}

printColors(){
  cat <<< "RED='\033[0;31m'
BLUE='\033[0;34m'
BLUE2='\033[0;94m'
CYAN='\033[0;36m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
YELLOW2='\033[0;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color";
}

# Uncomment for a demo
#printColors
sleep 0.1
log "Log file located at: ${MAGENTA}$logFile${NC}"