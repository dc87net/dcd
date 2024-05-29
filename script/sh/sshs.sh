#!/usr/bin/env zsh
## Establishes a completely RSA-based SSH connection
log "RSA SSH:  ${BYELLOW}$*${NC}"
ssh -4 -c aes256-cbc,aes256-ctr,aes256-gcm@openssh.com -o HostKeyAlgorithms=rsa-sha2-512,rsa-sha2-256 "$*"