#!/usr/bin/env bash

eval "$(dcd colors get)"

#ifaces="$(dcd netinfo | xargs | awk '{print $2}')"

cmds=('sudo launchctl bootout system /Library/LaunchDaemons/com.protection.macos-vpn.plist' \
      'sudo launchctl bootout system /Library/LaunchDaemons/org.netspark.SturdinesS.plist' \
      'sudo killall -9 Canopy'
      'dcd netinfo | xargs -n1 | awk "{print \$2}" | xargs -I{} sudo networksetup -setsecurewebproxystate {} off'
      'dcd netinfo | xargs -n1 | awk "{print \$2}" | xargs -I{} sudo networksetup -setwebproxystate {} off'
      )

for cmd in "${cmds[@]}"; do
  log "${CYAN}CMD${NC}: ${BRED}$cmd${NC}"
  log "$(eval "$cmd") \tRES: ${YELLOW}$?${NC}"
done <<< "$cmds"

#res1="$()"
#[[ $? -ne 0 ]] ||{
#  log "${BRED}Error${NC}: [$?] --> [$res1]";
#}

#networksetup 2>&1 | tee /dev/null | grep -n '\-set'