#!/usr/bin/env zsh
# Released to the public domain. 2024. By "DC".
# This scriptlet provides at-will control of Netspark/Canopy for users with admin/root on macOS.

readonly TEST='example.net' # URL to check connectivity against.
  ##      ╔═══════════════════════╗
  ##      ║ ## COLOR CONSTANTS ## ║
  ##      ╚═══════════════════════╝
  #
  export  BLACK='\033[0;30m'      # BLACK
  export  BLUE='\033[0;34m'       # BLUE
  export  CYAN='\033[0;36m'       # CYAN
  export  GREEN='\033[0;32m'      # GREEN
  export  MAGENTA='\033[0;35m'    # MAGENTA
  export  RED='\033[0;31m'        # RED
  export  WHITE='\033[0;37m'      # WHITE
  export  YELLOW='\033[0;33m'     # YELLOW
  ##      ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
  export  BBLACK='\033[0;90m'     # Bright Black (Gray)
  export  BBLUE='\033[0;94m'      # Bright Blue
  export  BCYAN='\033[0;96m'      # Bright Cyan
  export  BGREEN='\033[0;92m'     # Bright Green
  export  BMAGENTA='\033[0;95m'   # Bright Magenta
  export  BRED='\033[0;91m'       # Bright Red
  export  BWHITE='\033[0;97m'     # Bright White
  export  BYELLOW='\033[0;93m'    # Bright Yellow
  ## ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
  export NC='\033[0m'     # No Color/No Formatting
  ## ┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉
  export LINECOLOR="${BYELLOW}"
  log() {
    echo -e "${LINECOLOR}⮑${NC}  $*   ${GREEN}⥃${NC}"
  }
#####################################


##TODO:>>> SCRIPT LOGIC <<<<<########
log "${BMAGENTA}┄┄┄┄${BCYAN}Netspark Override Controller${BMAGENTA}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${NC}"
# Make sure we execute with the proper perms
[[ $(whoami) == 'root' ]] && log "✅  Running as root ..." || { log "❌ Not root... Relaunching!";
  eval /usr/bin/sudo "$0 $*" || exit $?; };


l(){  ##TODO>>> LOCK FUNCTION <<<<<#
  cmds="sudo launchctl bootstrap system /Library/LaunchDaemons/com.protection.macos-vpn.plist
        sudo launchctl boostrap system /Library/LaunchDaemons/org.netspark.SturdinesS.plist
        open /Applications/Canopy.app || open /Applications/Netspark.app"

    while IFS= read -r cmd || [[ -n "$cmd" ]]; do
      log "${CYAN}CMD${NC}: ${BRED}$cmd${NC}:\t< $(zsh <<< "echo $cmd") >\tRES: ${YELLOW}$?${NC}"
    done <<< "$cmds"
}

u(){  ##TODO>>> UNLOCK FUNCTION <<<<<#
  log "$(dcd box 'Defusing NS/C@no Py')"
    cmds=('sudo launchctl bootout system /Library/LaunchDaemons/com.protection.macos-vpn.plist'
          'sudo launchctl bootout system /Library/LaunchDaemons/org.netspark.SturdinesS.plist'
          'sudo killall -9 Canopy'
          )
    ##TODO:UNUSED: ["echo dcd netinfo | xargs -n1 | awk '{print \\\$2}' | xargs -I{} sudo networksetup -setwebproxystate {} off"]

  for cmd in "${cmds[@]}"; do
    sleep 1;
    log "${CYAN}CMD${NC}: < ${BRED}$(echo $cmd)${NC} >"
    ( exec $cmd 2>/dev/null) 2>/dev/null
    log "\tRES: ${YELLOW}$?${NC}"
  done

  # Adjust the System Proxy Settings
  sleep 1
  log "${CYAN}Processing${NC}: ${BCYAN}Secure Web Proxies${NC} ..."
  networksetup -listallnetworkservices | grep -v '*' | xargs -I{} zsh -c "echo -e '\tservice@ {}'; networksetup -setsecurewebproxystate '{}' off;"
  sleep 1
  log "${CYAN}Processing${NC}: ${BCYAN}Web Proxies${NC} ..."
  networksetup -listallnetworkservices | grep -v '*' | xargs -I{} zsh -c "echo -e '\tservice@ {}'; networksetup -setwebproxystate '{}' off;"

}

##TODO>>> MAIN() LOGIC <<<<<#
OP="$1"
[[ "$OP" ]]&&{
  [[ "$OP" == 'l' ]] && { log "${MAGENTA}Op${NC}: <${BYELLOW} $OP ${NC}>\t$(l&&echo $?)"; exit $?; }
  [[ "$OP" == 'u' ]] && log "${MAGENTA}Op${NC}: <${BYELLOW} $OP ${NC}>\t\n$(u&&echo $?)"
}||{
  log "${BRED}Error${NC}: ${BBLUE}Directive${NC} not specified! ..."
  exit 1;
#  log "Assuming: ${BMAGENTA}Unlock${NC} ..."
#  log "$(u&&echo $?)"
  echo;
}

echo;
[[ $(curl -I $TEST 2>&1 /dev/null) && $(scutil -r $TEST 2>&1 /dev/null) ]] && echo "🤑  Looks like it worked!" ||{
   echo "⛔  Looks like things didn't go as planned.  Reboot your computer."; exit 255; }

log "➡️ ${BCYAN}NETWORK INFO${NC} now as follows:"
res="$(scutil --nwi)"
log "${BLUE}${res}${NC}"

exit 0; ##TODO>>> SUCCESS! <<<<#
