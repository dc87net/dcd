#!/usr/bin/env zsh
## Copyright 2024 - DC87 Solutions LLC. All rights reserved.
#### *** IMPORTANT *** #####
## Include this **ONLY** using `source`, for ASCII color table!
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
export LINECOLOR='BYELLOW' # Color of `log` indicator

## Color constant table
readonly colorString=$(cat <<< "
## ╔═══════════════════════╗
## ║ ## COLOR CONSTANTS ## ║
## ╚═══════════════════════╝
export BLACK='\033[0;30m'   # BLACK
export BLUE='\033[0;34m'    # BLUE
export CYAN='\033[0;36m'    # CYAN
export GREEN='\033[0;32m'   # GREEN
export MAGENTA='\033[0;35m' # MAGENTA
export RED='\033[0;31m'     # RED
export WHITE='\033[0;37m'   # WHITE
export YELLOW='\033[0;33m'  # YELLOW
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
_SHELL(){
  exec zsh
}

## Function to log text with a leading marker (color: $LINECOLOR)
#  cat <<< "$@" | tee -a "$logFile"
log(){
  eval "echo -e \"\${$LINECOLOR}==>  ${NC}$*\""
}


#if [[ $1 ]];then log "params $*"; fi
params="$*"
#echo -e "\tPARAMS: $*"
if [[ $params == "get" ]]; then _COLORS2ENV; fi
if [[ $params == "colors" ]]; then
#  _COLORS2ENV
  log "Color Table:  ✅ Loaded into ${BCYAN}current${NC} shell environment"
  (exec eval "zsh <<< env")
fi
if [[ $params == "test" ]]; then
  echo "$(dcd colors get)"
fi
if [[ $params == "log" ]]; then
  (exec eval base64 -d -i - <<< 'IyEvdXNyL2Jpbi9lbnYgYmFzaAoKcmVzMT0iJChkY2QgY29sb3JzIGdldCkiCiNldmFsICIkKGRjZCBjb2xvcnMgZ2V0KSIKZXZhbCAiJHJlczEiCgpMSU5FQ09MT1I9J1lFTExPVycJIyBjb2xvciBuYW1lIGFzIHRleHQgKG5vdCBhcyBjb2xvciB2YXJpYWJsZSkKCgpsb2coKXsKICBldmFsICJlY2hvIC1lIFwiXCR7JExJTkVDT0xPUn09PT4gICR7TkN9JCpcIiIKfQo=')
fi
# additional help: `dcd colors help`
if [[ "$params" == "colors help" ]]; then
    log "Usage: Use ${BMAGENTA}dcd colors get${NC} for Table ${MAGENTA}source${NC}-able code"
    exit 0
fi



#'--------------------------------------------------------------' 2>&1 /dev/null



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

## Demo code
demoColoredText(){
  [ $1 -lt 1 ] && { # if there are no args passed into the script
    log "Example:\t${CYAN}CYAN${NC}"
    exit 0
  }
}


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

# -----

#### WORKS!!
#
#╰─ cat /opt/script/dcd | base64                                                                  ─╯
#IyEvdXNyL2Jpbi9lbnYgenNoCgpzb3VyY2UgIi9vcHQvc2NyaXB0L2V0Yy9jb2xvcnMuc2giCmV2YWwgYmFzaCAtYyAiL29wdC9zY3JpcHQvYmluLyRAIgo=