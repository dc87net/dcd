#!/usr/bin/env bash
## Copyright 2024 - DC87 Solutions LLC. All rights reserved.
#### *** IMPORTANT *** #####
## Include this using `source` for some ASCII colors ONLY!
##
## TO IMPORT THE COLOR TABLE INTO THE ENVIRONMENT:
##   dcd colors
##   dcd colors get
## Example: echo -e "This is ${RED}red${NC} text!"
############################

## Log path should be specified in the parent script that sources this one,
## as *--->  $LOGFILE  <---*
export LOGFILE="$LOGPATH/$LOGFNAME";
export LOGENABLE=0
export LINECOLOR='YELLOW' # Color of `log` indicator

## Color constant table
readonly colorString=$(cat <<< "
## ╔═══════════════════════╗
## ║ ## COLOR CONSTANTS ## ║
## ╚═══════════════════════╝
export BLACK='\033[0;30m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export GREEN='\033[0;32m'
export MAGENTA='\033[0;35m'
export RED='\033[0;31m'
export WHITE='\033[0;37m'
export YELLOW='\033[0;33m'
## ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
export BBLACK='\033[0;90m'   # Bright Black (Gray)
export BBLUE='\033[0;94m'    # Bright Blue
export BCYAN='\033[0;96m'    # Bright Cyan
export BGREEN='\033[0;92m'   # Bright Green
export BMAGENTA='\033[0;95m' # Bright Magenta
export BRED='\033[0;91m'     # Bright Red
export BWHITE='\033[0;97m'   # Bright White
export BYELLOW='\033[0;93m'  # Bright Yellow
## ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
export NC='\033[0m'
## ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
")

############################
## Function to print the color table, as __executable__ script text
_COLORS2ENV(){
  cat <<< "$colorString"
}
### **IMPORTANT**: Actually add Color Table to the env [NEXT STATEMENT];
###    **DO NOT REMOVE**
eval "$(_COLORS2ENV)"
############################

# replaces current call this script. the new env will have the Color Table set.
_COLORS(){
  exec zsh
}

if [[ $1 == 'get' ]]; then _COLORS2ENV; fi
if [[ $1 == "colors" ]]; then
    log "Color Table:  ✅ Loaded into ${BCYAN}current${NC} shell environment"
    _COLORS
fi
# additional help: `dcd colors help`
if [[ $1 == "help" ]]; then
    log "Usage: Use ${BMAGENTA}dcd colors get${NC} for Table ${MAGENTA}source${NC}-able code"
    exit 0
fi
##--------------------------------------------------------------

enableLogging(){
  # Logging, if applicable
  log "Log file located at: ${MAGENTA}$logFile${NC}" || log "ERROR: log file unavailable"
  [ -e "$LOGFILE" ] && {
    echo -e "Logging:  ${GREEN}ENABLED${NC}:\t${MAGENTA}$LOGFILE${NC}";
    logFile=$("mktemp -p /$(date '+%s').log")
  } || {
    echo -e "Logging:  ${RED}DISABLED${NC}:\t${CYAN}$LOGFILE${NC}";
  }
}

## Function to log text with a leading marker (color: $LINECOLOR)
#  cat <<< "$@" | tee -a "$logFile"
log(){
  eval "echo -e \"\${$LINECOLOR}==>  ${NC}$*\""
}

## Demo code
demoColoredText(){
  [ $1 -lt 1 ] && { # if there are no args passed into the script
    log "Example:\t${CYAN}CYAN${NC}"
    exit 0
  }
}

log "test of log"
log "Params: $*"

# Comment out the below line to completely disable the demo feature
#demoColoredText $#
#log "Cmd:\t${RED} $0${NC}${BCYAN} $* ${NC}"
#eval "$(_COLORS2ENV)"
#log "CMD:\t${RED}$0 ${BCYAN}$*${NC}"

## main() for  this script [runs if called as executable `colors`]
#if [ "$0" == "colors" ] or [ "$1" == "colors" ]; then
##  tempfile=$(mktemp)
##  _COLORS2ENV > $tempfile
##  echo "$tempfile"
#  log "Adding colors to environment..."
#  #eval "$(_COLORS2ENV)"
#  exec "zsh" -i
#fi



###### SCRATCH ###### ###### SCRATCH ###### ###### SCRATCH ###### ###### SCRATCH ######
#printColors(){
###
#  cat <<< "RED='\033[0;31m'
#BLUE='\033[0;34m'
#BLUE2='\033[0;94m'
#CYAN='\033[0;36m'
#GREEN='\033[0;92m'
#YELLOW='\033[0;93m'
#YELLOW2='\033[0;33m'
#MAGENTA='\033[0;35m'
#NC='\033[0m' # No Color";
#}