#!/bin/bash

sudo killall -9 checkd;
sudo launchctl unload system /Library/LaunchDaemons/com.cloudflare.1dot1dot1dot1.macos.warp.daemon.plist

