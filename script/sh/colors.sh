#!/usr/bin/env zsh
##TODO>###################### TERMINAL COLORS AND LOGGING ######################<ODOT##
## Copyright 2024 - DC87 Solutions LLC. All rights reserved.

#### *** IMPORTANT *** #####
## Include this **ONLY** using `source`, for ASCII color table!
##
## TO IMPORT THE COLOR TABLE INTO THE ENVIRONMENT:
##   eval "$(dcd colors get)"
## -- To spawn an interactive subshell with the colors in the env:
##   dcd colors
## -- To print the raw text used by the `eval` statement (above):
##   dcd colors get
## Example: echo -e "This is ${RED}red${NC} text!"
############################

## Log path should be specified in the parent script that sources this one,
## as *--->  $LOGFILE  <---*
[[ "$LOGPATH" && "$LOGFNAME"  ]] && {
  export LOGFILE="$LOGPATH/$LOGFNAME";
} || {
  export LOGPATH='/var/log/'
  export LOGFNAME='dcterm.log'
  export LOGFILE="$LOGPATH/$LOGFNAME";
  export LOGENABLE=0
}

setupLog(){
  sel="$1"
  [[ "$sel" ]]&& {
    [[ $sel == 'LOGPATH' ]] && { :; }
    echo -e "$(eval echo "$1")"; # prints `test`
  } || echo '[setupLog]: Error:  No Selector';
}



export LINECOLOR='BYELLOW' # Color of `log` indicator
export colorString=$(cat << 'eof'

##	╔═══════════════════════╗
##	║ ## COLOR CONSTANTS ## ║
##	╚═══════════════════════╝
#
export	BLACK='\033[0;30m'	# BLACK
export	BLUE='\033[0;34m'	# BLUE
export	CYAN='\033[0;36m'	# CYAN
export	GREEN='\033[0;32m'	# GREEN
export	MAGENTA='\033[0;35m'	# MAGENTA
export	RED='\033[0;31m'	# RED
export	WHITE='\033[0;37m'	# WHITE
export	YELLOW='\033[0;33m'	# YELLOW
## 	┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
export	BBLACK='\033[0;90m'	# Bright Black (Gray)
export	BBLUE='\033[0;94m'	# Bright Blue
export	BCYAN='\033[0;96m'	# Bright Cyan
export	BGREEN='\033[0;92m'	# Bright Green
export	BMAGENTA='\033[0;95m'	# Bright Magenta
export	BRED='\033[0;91m'	# Bright Red
export	BWHITE='\033[0;97m'	# Bright White
export	BYELLOW='\033[0;93m'	# Bright Yellow
## ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
export NC='\033[0m'	# No Color/No Formatting
## ┉┉┉┉┉┉┉┉┉┉┉┉
eof
)



#readonly logString="$(echo \
#'ZXJyKCl7CiAgZXZhbCBjYXQgLSAgPiYyOwp9CgpkYXRlTigpewogIGVjaG8gIlsgJChkYXRlICsiJXklbSVkLSVIOiVNOiVTIildICIKfQpsb2dSdW4oKXsKICBsb2NhbCBjbWQKICBjbWQ9JChjYXQgLSkgICAgIyBDYXB0dXJlIHRoZSBjbWQKICAjW1sgLWYgIiRMT0dGSUxFIiBdXSB8fCB7IExPR0ZJTEU9IiQobWt0ZW1wKSI7IGxvZyAiTG9nZmlsZSBETkU6ICR7WUVMTE9XfT09PiBcdCR7QlJFRH0ke0xPR0ZJTEV9JHtOQ30iOyB9CiAgI3RvdWNoICIkTE9HRklMRSIgMj4mMSAvZGV2L251bGwKICBlY2hvIC1lICJbQ01EXSQoZGF0ZU4pOiAgJHtjbWR9IiA+PiAiJHtMT0dGSUxFfSIgICAgICAgICAgICAgICAgICMgTG9nIHRoZSBDTUQgYmVpbmcgZXhlY3V0ZWQKICAjZXZhbCAiJGNtZCIgMj4mMSB8IHRlZSAtYSAiJExPR0ZJTEUiPi9kZXYvbnVsbCAgICMgY2FwdHVyZSwgc3RyZWFtIHRvIHR0eSwgYW5kIGxvZyBDTUQgcmVzdWx0cwp9CmxvZygpIHsKICBsb2dSdW4gPDw8ICJlY2hvIC1lIFwiXCR7JHtMSU5FQ09MT1J9feKukSR7TkN9ICAkKlwiIOKssiIKfQo='\
#| base64 -d)"

LOGSTRING(){
  cat -  << 'EOF'
    err(){
      eval cat -  >&2;
    }
    dateN(){
      echo "[ $(date +"%y%m%d-%H:%M:%S") ] "
    }
    logRun(){
#      local cmd
#      cmd=$(cat -)    # Capture the cmd
#      [[ "$LOGFILE" != '/dev/null' ]] ||{
#        [[ -f "$LOGFILE" ]] || { LOGFILE="$(mktemp)"; log "Logfile: ${BRED}DNE. ...${GREEN}Creating ${NC}${YELLOW}==> \t${BRED}${LOGFILE}${NC}"; };
#      touch "$LOGFILE" 2>&1 /dev/null
#      echo -e "[CMD]$(dateN):  ${cmd}" >> "${LOGFILE}"  # Log the CMD being executed
#      eval "$cmd" 2>&1 | tee -a "$LOGFILE" #>/dev/null   # capture: stream to tty, and log CMD results
    }
    log() {
      bash <<< "echo -e \"\${${LINECOLOR}}⮑${NC}  $*\"     ⥃"
    }
EOF
}

#readonly logString="$(echo \
#'ZGF0ZU4oKXsKICBlY2hvICJbICQoZGF0ZSArIiV5JW0lZC0lSDolTTolUyIpXSAiCn0KbG9nUnVuKCl7CiAgbG9jYWwgY21kCiAgY21kPSQoY2F0KSAgI'\
#'CAjIENhcHR1cmUgdGhlIGNtZAoKICB0b3VjaCAiJExPR0ZJTEUiCiAgZWNobyAtZSAiW0NNRF0kKGRhdGVOKTogICR7Y21kfSIgPj4gIiR7TE9HRklMRX'\
#'0iICAgICAgICAgICAgICAgICAjIExvZyB0aGUgQ01EIGJlaW5nIGV4ZWN1dGVkCiAgZXZhbCAiJGNtZCIgMj4mMSB8IHRlZSAvZGV2L3R0eSAgfCB0ZWU'\
#'gLWEgIiRMT0dGSUxFIj4vZGV2L251bGwgICAjIGNhcHR1cmUsIHN0cmVhbSB0byB0dHksIGFuZCBsb2cgQ01EIHJlc3VsdHMKfQpsb2coKSB7CiAgbG9n'\
#'UnVuIDw8PCAiZWNobyAtZSBcIlwkeyR7TElORUNPTE9SfX09PT4ke05DfSAgJCpcIiIKfQo=' | base64 -d)"



#'ZGF0ZU4oKXsKICBlY2hvICJbICQoZGF0ZSArIiV5JW0lZC0lSDolTTolUyIpXSAiCn0KbG9nUnVuKCl7CiAgbG9jYWwgY21kCiAgY21kPSQoY2F0KSAgI'\
#'CAjIENhcHR1cmUgdGhlIGNtZAoKICB0b3VjaCAiJExPR0ZJTEUiCiAgZWNobyAtZSAiW0NNRF0kKGRhdGVOKTogICR7Y21kfSIgPj4gIiR7TE9HRklMRX'\
#'0iICAgICAgICAgICAgICAgICAjIExvZyB0aGUgQ01EIGJlaW5nIGV4ZWN1dGVkCiAgZXZhbCAiJGNtZCIgMj4mMSB8IHRlZSAvZGV2L3R0eSAgfCB0ZWU'\
#'gLWEgIiRMT0dGSUxFIj4vZGV2L251bGwgICAjIGNhcHR1cmUsIHN0cmVhbSB0byB0dHksIGFuZCBsb2cgQ01EIHJlc3VsdHMKfQpsb2coKSB7CiAgbG9n'\
#'UnVuIDw8PCAiZWNobyAtZSBcIlwkeyR7TElORUNPTE9SfX09PT4ke05DfSAgTVNHICQqXCIiCn0K' | base64 -d)"


############################
## Function to print the color table, as __executable__ script text
_COLORS2ENV(){
  cat <<< "$colorString"
  LOGSTRING
}

### **IMPORTANT**: Actually add Color Table to the env [NEXT STATEMENT];
###    **DO NOT REMOVE**
eval "$(_COLORS2ENV)"
############################

# replaces current call this script. the new env will have the Color Table set.
_SHELL(){
  exec zsh
}

#err(){
#  eval cat -  >&2;
#}
#dateN(){
#  echo "[ $(date +"%y%m%d-%H:%M:%S") ] "
#}
#logRun(){hyp
#  local cmd
#  cmd=$(cat -)    # Capture the cmd
#  #[[ -f "$LOGFILE" ]] || { LOGFILE="$(mktemp)"; log "Logfile DNE: ${YELLOW}==> \t${BRED}${LOGFILE}${NC}"; }
#  #touch "$LOGFILE" 2>&1 /dev/null
#  #echo -e "[CMD]$(dateN):  ${cmd}" >> "${LOGFILE}"                 # Log the CMD being executed
#  eval "$cmd" 2>&1 | tee -a "$LOGFILE" #>/dev/null   # capture, stream to tty, and log CMD results
#}
#log(){
#  logRun <<< "echo -e \"\${${LINECOLOR}}⮑${NC}  $*\" ⬲"
#}


##TODO>###### PARAM HANDLER ######<ODOT##
#if [[ $1 ]];then log "params: $*"; fi
params="$*";
#echo -e "\tPARAMS: $*"
#[[ $params == "colors" ]] && { cat <<< "$colorString"; }  # cat <<< "$(dcd colors log)"; } fi
[[ $params == "colors get" ]]    && { _COLORS2ENV; echo "export LINECOLOR='BYELLOW'"; } # cat <<< "$colorString"; echo "export LINECOLOR='BYELLOW'"; } ##
#if [[ $params == "colors" ]]; then
#  _COLORS2ENV
#  log "Color Table:  ✅ Color check for subshell: ${BCYAN}${$}{NC} @ current depth info: "
#  dcd deep
#  log "Spawning a shell to make colors available in the working env; use ${MAGENTA}exit${NC} to exit the Subshell)"
#  _SHELL #(exec eval "zsh <<< env")
#fi
if [[ $params == "test" ]]; then
  eval "$(dcd colors get)"
  echo "&& dcd colors get | column -t -s"\t")"
fi
if [[ $params == "log" ]]; then
  (exec eval base64 -d -i - <<< 'IyEvdXNyL2Jpbi9lbnYgYmFzaAoKcmVzMT0iJChkY2QgY29sb3JzIGdldCkiCiNldmFsICIkKGRjZCBjb2xvcnMgZ2V0KSIKZXZhbCAiJHJlczEiCgpMSU5FQ09MT1I9J1lFTExPVycJIyBjb2xvciBuYW1lIGFzIHRleHQgKG5vdCBhcyBjb2xvciB2YXJpYWJsZSkKCgpsb2coKXsKICBldmFsICJlY2hvIC1lIFwiXCR7JExJTkVDT0xPUn09PT4gICR7TkN9JCpcIiIKfQo=')
fi
# additional help: `dcd colors help`
if [[ "$params" == "colors help" ]]; then
    log "Usage: Use ${BMAGENTA}dcd colors get${NC} for Table; \`${MAGENTA}source${NC}\`-able code"
    exit 0
fi

# echo '------------------------------------------------------------------------------------------------' 2>&1 /dev/null

enableLogging(){
  # Logging, if applicable
  log "Log file located at: ${MAGENTA}$logFile${NC}" || log "ERROR: log file unavailable"
  [ -e "$LOGFILE" ] && {
    echo -e "Logging:  ${GREEN}ENABLED${NC}:\t${MAGENTA}$LOGFILE${NC}";
    logFile=$("mktemp -p /$(dateN).log")
  } || {
    echo -e "Logging:  ${RED}DISABLED${NC}:\t${CYAN}$LOGFILE${NC}";
  }
}

## Demo code
demoColoredText(){
  [[ ! $1 ]] && { # if there are no args passed into the script
    log "Example:\t${CYAN}CYAN${NC}"
#    exit 0
  }
}



### echo '----------------------------------------------------------------------------------------------' 2>&1 /dev/null
### echo '----------------------------------------------------------------------------------------------' 2>&1 /dev/null
### echo '----------------------------------------------------------------------------------------------' 2>&1 /dev/null
#### WORKS!!
#
#╰─ cat /opt/script/dcd | base64                                                                  ─╯
#IyEvdXNyL2Jpbi9lbnYgenNoCgpzb3VyY2UgIi9vcHQvc2NyaXB0L2V0Yy9jb2xvcnMuc2giCmV2YWwgYmFzaCAtYyAiL29wdC9zY3JpcHQvYmluLyRAIgo=


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

#err <<< "imported" 2>/dev/null

#_COLORS2ENV
#LOGSTRING
#demoColoredText


##!/usr/bin/env zsh
###TODO>###################### TERMINAL COLORS AND LOGGING ######################<ODOT##
### Copyright 2024 - DC87 Solutions LLC. All rights reserved.
#
##### *** IMPORTANT *** #####
### Include this **ONLY** using `source`, for ASCII color table!
###
### TO IMPORT THE COLOR TABLE INTO THE ENVIRONMENT:
###   eval "$(dcd colors get)"
### -- To spawn an interactive subshell with the colors in the env:
###   dcd colors
### -- To print the raw text used by the `eval` statement (above):
###   dcd colors get
### Example: echo -e "This is ${RED}red${NC} text!"
#############################
#
### Log path should be specified in the parent script that sources this one,
### as *--->  $LOGFILE  <---*
#[[ "$LOGPATH" && "$LOGFNAME"  ]] && {
#  export LOGFILE="$LOGPATH/$LOGFNAME";
#} || {
#  export LOGPATH='/var/log/'
#  export LOGFNAME='dcterm.log'
#  export LOGFILE="$LOGPATH/$LOGFNAME";
#  export LOGENABLE=0
#}
#
#setupLog(){
#  sel="$1"
#  [[ "$sel" ]]&& {
#    [[ $sel == 'LOGPATH' ]] && { :; }
#    echo -e "$(eval echo "$1")"; # prints `test`
#  } || echo '[setupLog]: Error:  No Selector';
#}
#
#
#
#export LINECOLOR='BYELLOW' # Color of `log` indicator
#
### Color constant table
#readonly colorString="$(cat - << 'eof'
###	╔═══════════════════════╗
###	║ ## COLOR CONSTANTS ## ║
###	╚═══════════════════════╝
##
#export	BLACK='\033[0;30m'	# BLACK
#export	BLUE='\033[0;34m'	# BLUE
#export	CYAN='\033[0;36m'	# CYAN
#export	GREEN='\033[0;32m'	# GREEN
#export	MAGENTA='\033[0;35m'	# MAGENTA
#export	RED='\033[0;31m'	# RED
#export	WHITE='\033[0;37m'	# WHITE
#export	YELLOW='\033[0;33m'	# YELLOW
### 	┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
#export	BBLACK='\033[0;90m'	# Bright Black (Gray)
#export	BBLUE='\033[0;94m'	# Bright Blue
#export	BCYAN='\033[0;96m'	# Bright Cyan
#export	BGREEN='\033[0;92m'	# Bright Green
#export	BMAGENTA='\033[0;95m'	# Bright Magenta
#export	BRED='\033[0;91m'	# Bright Red
#export	BWHITE='\033[0;97m'	# Bright White
#export	BYELLOW='\033[0;93m'	# Bright Yellow
### ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
#export NC='\033[0m'	# No Color/No Formatting
### ┉┉┉┉┉┉┉┉┉┉┉┉
#eof
#)";
#
#
##readonly logString="$(echo \
##'ZXJyKCl7CiAgZXZhbCBjYXQgLSAgPiYyOwp9CgpkYXRlTigpewogIGVjaG8gIlsgJChkYXRlICsiJXklbSVkLSVIOiVNOiVTIildICIKfQpsb2dSdW4oKXsKICBsb2NhbCBjbWQKICBjbWQ9JChjYXQgLSkgICAgIyBDYXB0dXJlIHRoZSBjbWQKICAjW1sgLWYgIiRMT0dGSUxFIiBdXSB8fCB7IExPR0ZJTEU9IiQobWt0ZW1wKSI7IGxvZyAiTG9nZmlsZSBETkU6ICR7WUVMTE9XfT09PiBcdCR7QlJFRH0ke0xPR0ZJTEV9JHtOQ30iOyB9CiAgI3RvdWNoICIkTE9HRklMRSIgMj4mMSAvZGV2L251bGwKICBlY2hvIC1lICJbQ01EXSQoZGF0ZU4pOiAgJHtjbWR9IiA+PiAiJHtMT0dGSUxFfSIgICAgICAgICAgICAgICAgICMgTG9nIHRoZSBDTUQgYmVpbmcgZXhlY3V0ZWQKICAjZXZhbCAiJGNtZCIgMj4mMSB8IHRlZSAtYSAiJExPR0ZJTEUiPi9kZXYvbnVsbCAgICMgY2FwdHVyZSwgc3RyZWFtIHRvIHR0eSwgYW5kIGxvZyBDTUQgcmVzdWx0cwp9CmxvZygpIHsKICBsb2dSdW4gPDw8ICJlY2hvIC1lIFwiXCR7JHtMSU5FQ09MT1J9feKukSR7TkN9ICAkKlwiIOKssiIKfQo='\
##| base64 -d)"
#
#LOGSTRING(){
#  cat -  << 'EOF'
#    err(){
#      eval cat -  >&2;
#    }
#    dateN(){
#      echo "[ $(date +"%y%m%d-%H:%M:%S") ] "
#    }
#    logRun(){
#      local cmd
#      cmd=$(cat -)    # Capture the cmd
##      [[ "$LOGFILE" != '/dev/null' ]] ||{
##        [[ -f "$LOGFILE" ]] || { LOGFILE="$(mktemp)"; log "Logfile: ${BRED}DNE. ...${GREEN}Creating ${NC}${YELLOW}==> \t${BRED}${LOGFILE}${NC}"; };
#      touch "$LOGFILE" 2>&1 /dev/null
#      echo -e "[CMD]$(dateN):  ${cmd}" >> "${LOGFILE}"  # Log the CMD being executed
#      eval "$cmd" 2>&1 | tee -a "$LOGFILE" #>/dev/null   # capture: stream to tty, and log CMD results
#    }
#    log() {
#      logRun <<< "echo -e \"\${${LINECOLOR}}⮑${NC}  $*\"     ⥃"
#    }
#EOF
#
#exit 0;
#}
#
##readonly logString="$(echo \
##'ZGF0ZU4oKXsKICBlY2hvICJbICQoZGF0ZSArIiV5JW0lZC0lSDolTTolUyIpXSAiCn0KbG9nUnVuKCl7CiAgbG9jYWwgY21kCiAgY21kPSQoY2F0KSAgI'\
##'CAjIENhcHR1cmUgdGhlIGNtZAoKICB0b3VjaCAiJExPR0ZJTEUiCiAgZWNobyAtZSAiW0NNRF0kKGRhdGVOKTogICR7Y21kfSIgPj4gIiR7TE9HRklMRX'\
##'0iICAgICAgICAgICAgICAgICAjIExvZyB0aGUgQ01EIGJlaW5nIGV4ZWN1dGVkCiAgZXZhbCAiJGNtZCIgMj4mMSB8IHRlZSAvZGV2L3R0eSAgfCB0ZWU'\
##'gLWEgIiRMT0dGSUxFIj4vZGV2L251bGwgICAjIGNhcHR1cmUsIHN0cmVhbSB0byB0dHksIGFuZCBsb2cgQ01EIHJlc3VsdHMKfQpsb2coKSB7CiAgbG9n'\
##'UnVuIDw8PCAiZWNobyAtZSBcIlwkeyR7TElORUNPTE9SfX09PT4ke05DfSAgJCpcIiIKfQo=' | base64 -d)"
#
#
#
##'ZGF0ZU4oKXsKICBlY2hvICJbICQoZGF0ZSArIiV5JW0lZC0lSDolTTolUyIpXSAiCn0KbG9nUnVuKCl7CiAgbG9jYWwgY21kCiAgY21kPSQoY2F0KSAgI'\
##'CAjIENhcHR1cmUgdGhlIGNtZAoKICB0b3VjaCAiJExPR0ZJTEUiCiAgZWNobyAtZSAiW0NNRF0kKGRhdGVOKTogICR7Y21kfSIgPj4gIiR7TE9HRklMRX'\
##'0iICAgICAgICAgICAgICAgICAjIExvZyB0aGUgQ01EIGJlaW5nIGV4ZWN1dGVkCiAgZXZhbCAiJGNtZCIgMj4mMSB8IHRlZSAvZGV2L3R0eSAgfCB0ZWU'\
##'gLWEgIiRMT0dGSUxFIj4vZGV2L251bGwgICAjIGNhcHR1cmUsIHN0cmVhbSB0byB0dHksIGFuZCBsb2cgQ01EIHJlc3VsdHMKfQpsb2coKSB7CiAgbG9n'\
##'UnVuIDw8PCAiZWNobyAtZSBcIlwkeyR7TElORUNPTE9SfX09PT4ke05DfSAgTVNHICQqXCIiCn0K' | base64 -d)"
#
#
#############################
### Function to print the color table, as __executable__ script text
#_COLORS2ENV(){
#  cat <<< "$colorString"
#  LOGSTRING
#}
#
#### **IMPORTANT**: Actually add Color Table to the env [NEXT STATEMENT];
####    **DO NOT REMOVE**
#eval "$(_COLORS2ENV)"
#############################
#
## replaces current call this script. the new env will have the Color Table set.
#_SHELL(){
#  exec zsh
#}
#
##err(){
##  eval cat -  >&2;
##}
##dateN(){
##  echo "[ $(date +"%y%m%d-%H:%M:%S") ] "
##}
##logRun(){hyp
##  local cmd
##  cmd=$(cat -)    # Capture the cmd
##  #[[ -f "$LOGFILE" ]] || { LOGFILE="$(mktemp)"; log "Logfile DNE: ${YELLOW}==> \t${BRED}${LOGFILE}${NC}"; }
##  #touch "$LOGFILE" 2>&1 /dev/null
##  #echo -e "[CMD]$(dateN):  ${cmd}" >> "${LOGFILE}"                 # Log the CMD being executed
##  eval "$cmd" 2>&1 | tee -a "$LOGFILE" #>/dev/null   # capture, stream to tty, and log CMD results
##}
##log(){
##  logRun <<< "echo -e \"\${${LINECOLOR}}⮑${NC}  $*\" ⬲"
##}
#
#
###TODO>###### PARAM HANDLER ######<ODOT##
##if [[ $1 ]];then log "params: $*"; fi
#params="$*"
##echo -e "\tPARAMS: $*"
#[[ $params == "colors" ]] && { cat <<< "$colorString"; }  # cat <<< "$(dcd colors log)"; } fi
#[[ $params == "get" ]]    && { _COLORS2ENV; echo "export LINECOLOR='BYELLOW'"; } # cat <<< "$colorString"; echo "export LINECOLOR='BYELLOW'"; } ##
#if [[ $params == "colors" ]]; then
#  _COLORS2ENV
#  log "Color Table:  ✅ Color check for subshell: ${BCYAN}${$}{NC} @ current depth info: "
#  dcd deep
#  log "Spawning a shell to make colors available in the working env; use ${MAGENTA}exit${NC} to exit the Subshell)"
#  _SHELL #(exec eval "zsh <<< env")
#fi
#if [[ $params == "test" ]]; then
#  eval "$(dcd colors get)"
#  echo "&& dcd colors get | column -t -s"\t")"
#fi
#if [[ $params == "log" ]]; then
#  (exec eval base64 -d -i - <<< 'IyEvdXNyL2Jpbi9lbnYgYmFzaAoKcmVzMT0iJChkY2QgY29sb3JzIGdldCkiCiNldmFsICIkKGRjZCBjb2xvcnMgZ2V0KSIKZXZhbCAiJHJlczEiCgpMSU5FQ09MT1I9J1lFTExPVycJIyBjb2xvciBuYW1lIGFzIHRleHQgKG5vdCBhcyBjb2xvciB2YXJpYWJsZSkKCgpsb2coKXsKICBldmFsICJlY2hvIC1lIFwiXCR7JExJTkVDT0xPUn09PT4gICR7TkN9JCpcIiIKfQo=')
#fi
## additional help: `dcd colors help`
#if [[ "$params" == "colors help" ]]; then
#    log "Usage: Use ${BMAGENTA}dcd colors get${NC} for Table; \`${MAGENTA}source${NC}\`-able code"
#    exit 0
#fi
#
## echo '------------------------------------------------------------------------------------------------' 2>&1 /dev/null
#
#enableLogging(){
#  # Logging, if applicable
#  log "Log file located at: ${MAGENTA}$logFile${NC}" || log "ERROR: log file unavailable"
#  [ -e "$LOGFILE" ] && {
#    echo -e "Logging:  ${GREEN}ENABLED${NC}:\t${MAGENTA}$LOGFILE${NC}";
#    logFile=$("mktemp -p /$(dateN).log")
#  } || {
#    echo -e "Logging:  ${RED}DISABLED${NC}:\t${CYAN}$LOGFILE${NC}";
#  }
#}
#
### Demo code
#demoColoredText(){
#  [[ ! $1 ]] && { # if there are no args passed into the script
#    log "Example:\t${CYAN}CYAN${NC}"
##    exit 0
#  }
#}
#
#
#
#### echo '----------------------------------------------------------------------------------------------' 2>&1 /dev/null
#### echo '----------------------------------------------------------------------------------------------' 2>&1 /dev/null
#### echo '----------------------------------------------------------------------------------------------' 2>&1 /dev/null
##### WORKS!!
##
##╰─ cat /opt/script/dcd | base64                                                                  ─╯
##IyEvdXNyL2Jpbi9lbnYgenNoCgpzb3VyY2UgIi9vcHQvc2NyaXB0L2V0Yy9jb2xvcnMuc2giCmV2YWwgYmFzaCAtYyAiL29wdC9zY3JpcHQvYmluLyRAIgo=
#
#
## Comment out the below line to completely disable the demo feature
##demoColoredText $#
##log "Cmd:\t${RED} $0${NC}${BCYAN} $* ${NC}"
##eval "$(_COLORS2ENV)"
##log "CMD:\t${RED}$0 ${BCYAN}$*${NC}"
#
#
### main() for  this script [runs if called as executable `colors`]
##if [ "$0" == "colors" ] or [ "$1" == "colors" ]; then
###  tempfile=$(mktemp)
###  _COLORS2ENV > $tempfile
###  echo "$tempfile"
##  log "Adding colors to environment..."
##  #eval "$(_COLORS2ENV)"
##  exec "zsh" -i
##fi
#
##err <<< "imported" 2>/dev/null
#
##_COLORS2ENV
##LOGSTRING
##demoColoredText
