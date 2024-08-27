#!/usr/bin/env python3

import subprocess
import sys


def shex(cmd='echo Error: No command specified'):
    res = subprocess.run(['zsh', '-c', cmd], capture_output=True, text=True)
    return res

script = r"""#!/bin/bash
## Copyright 2024 DC87 Solutions LLC. All rights reserved.

# Get the active interface name using the updated method
activeInterfaces=$(scutil --nwi | grep flags | grep -v utun | grep IP | awk '{print $1}')           # requires an IP
activeInterfaces=$(scutil --nwi | grep 'Network interfaces' | cut -d':' -f2 | awk '{print $0}')     # when powered/on

# Check if an active interface was found
#echo -e "detected: $activeInterfaces"
if [ -z "$activeInterfaces" ]; then
    echo -n "No active IPv4 interface found."
    exit 1
else
    :
    # echo "Active interface: $active_interface"
fi

# Header
#printf "%-10s %-20s %-16s %-40s\n" "Interface" "Hardware Port" "IPv4" "IPv6"

for i in $activeInterfaces
do
  interface=$i
  hardware_port=$(networksetup -listallhardwareports | grep -B1 "Device: $i" | awk -F ": " '/Hardware Port/{print $2}')
  ipV4="$(ifconfig $i | grep -w inet | awk '{print $2}')"
  ipV6="$(ifconfig $i | grep inet6 | awk '{print $2}' | cut -d'%' -f1 | head -n 1)"

  # Adjust the column widths as needed
  printf "%-5s %-25s %-20s %-40s\n" "$i" "'$hardware_port'" "$ipV4" "$ipV6"
  sleep .25
done"""

def networkInfo():
    # Executing the script using subprocess
    result = subprocess.run(['bash', '-c', script], capture_output=True, text=True)

    # Print the output
    print(result.stdout.strip())

    # Check for errors
    if result.stderr:
        print("Error:", result.stderr)
        return result.stderr.strip()
    else:
        return result.stdout.strip()

def printScript():
    return script

networkInfo()

# if (sys.argv.index('') != False):
if (len(sys.argv) > 1):
    if (sys.argv.index('ports') != False):
        # Get the list from lsof
        print(f"LISTENING:")
        res = shex('lsof -a -d 0-999999 | grep CP | grep LISTEN | col -b');
        print(res.stdout.strip());
        print("\nESTABLISHED:");
        res = res = shex('lsof -a -d 0-999999 | grep CP | grep ESTABLISHED | col -b');
        print(res.stdout.strip());


exit(0);
