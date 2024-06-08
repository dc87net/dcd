#!/usr/bin/env zsh
## Establishes a _completely_ RSA-based SSH connection

params="$*"

# Import font colors
res1="$(dirname $(realpath $(which dcd)))"
source "$res1/etc/colors.sh"

# Establish SSH session
[[ "$*" ]] && log "RSA SSH:  ${BYELLOW}$*${NC}" || log "Error: ${RED}You must specify a remote host${NC}"
ssh -4 -c aes256-cbc,aes256-ctr,aes256-gcm@openssh.com -o HostKeyAlgorithms='rsa-sha2-512,rsa-sha2-256' "$*"