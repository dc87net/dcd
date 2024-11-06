#!/usr/bin/env zsh
## Copyright 2024 DC87 Solutions LLC. All rights reserved.

# Get the active interface name using the updated method
activeInterfaces=$(scutil --nwi | grep flags | grep -v utun | grep IP | awk '{print $1}')           # requires an IP
activeInterfaces=$(scutil --nwi | grep 'Network interfaces' | cut -d':' -f2 | awk '{print $0}')     # when powered/on

# Check if an active interface was found

if [ -z "$activeInterfaces" ]; then
    echo -n "No active IPv4 interface found.\n"
    exit 1
else
    :
fi

# Header
#(printf "%-10s %-20s %-16s %-20s %-20s\n" "Interface" "Hardware Port" "IPv4" "IPv6" "DNS")>/dev/stderr
(printf "%-12s %-20s %-18s %-25s %-30s\n" "Interface" "Hardware Port" "IPv4" "IPv6" "DNS") >&2

export i;
for i in $activeInterfaces
do
  iface="$i"
  hardware_port="$(networksetup -listallhardwareports | eval grep -B1 \'Device: $i\' | awk -F ": " '/Hardware Port/{print $2}')" #e.g., `en0` for Wi-Fi
  ipV4="$(eval ifconfig $i | grep -w inet | awk '{print $2}')"
  ipV6="$(eval ifconfig "$i" | grep inet6 | awk '{print $2}' | cut -d'%' -f1 | head -n 1)"
  dns=$(scutil --dns | cat -n | eval grep -B1 "$i" | head -n 1 | awk '{print $NF}')
a


  # Adjust the column widths as needed
  printf "%-12s %-20s %-18s %-25s %-30s\n" "$iface" "$hardware_port" "$ipV4" "$ipV6" "$dns"
  sleep .25
done

echo;
exit 0;
