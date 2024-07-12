#!/usr/bin/env bash

eval "$(dcd colors get)"

cmds=('sudo launchctl bootout system /Library/LaunchDaemons/com.protection.macos-vpn.plist' \
      'sudo launchctl bootout system /Library/LaunchDaemons/org.netspark.SturdinesS.plist' \
      'sudo killall -9 Canopy'
      )


res1="$()"
[[ $? -ne 0 ]] ||{
  log "${BRED}Error${NC}: [$?] --> [$res1]";
}

