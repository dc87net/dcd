#!/usr/bin/env zsh
## Establishes a completely RSA-based SSH connection

# Import font colors
#eval "$(dcd colors get)"
#eval "$(dcd colors full)"
res1="$(dirname $(realpath $(which dcd)))"
source "$res1/etc/colors.sh"

# Establish session

params="$*"

[[ "$*" ]] && log "RSA SSH:  ${BYELLOW}$*${NC}" || exit -1
ssh -4 -c aes256-cbc,aes256-ctr,aes256-gcm@openssh.com -o HostKeyAlgorithms='rsa-sha2-512,rsa-sha2-256' "$*"