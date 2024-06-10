#!/bin/bash

## Resets the admin password on pfSense (Netgate) hardware;
## Must be run from single user mode. [Option 2 at text boot screen]
## To connect to the serial console, use the following command:
## $ eval "sudo screen /dev/$(ls /dev | grep USB | grep tty)" 115200


############ 
## SCRIPT ##
############

echo -e "Enter the following commands from Single User mode:\n"

cat <<< "/sbin/mount -u /
/sbin/zfs mount -a
/sbin/zfs mount pfSense/ROOT/default/cf
/sbin/zfs mount pfSense/ROOT/default/var_db_pkg
/sbin/nextboot -D
/etc/rc.initial.password
y"
echo;

cat <<< "then, at \`marvell>>\`
usb reset
run usbrecovery
"
