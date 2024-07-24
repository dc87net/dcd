#!/usr/bin/env bash
##
## Prints detailed information about a process

##
# vars
export pid;
dcd

##
# check to see if there was a pid passed in; if not, use own pid
[ -"$1" != "" ] && pid="$$" || pid="$1"
log


# A -- Print process tree
txtTree="$(pstree -p $pid)"
cat <<< "$txtTree"

# B -- Get file information
ls -laOG
