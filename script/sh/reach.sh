#!/bin/bash

## Continuously tests the reachabilty of a remote host.

log "Checking reachabilty (every 2s) to $*"
watch -c ping -c1 $*