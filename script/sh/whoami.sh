#!/usr/bin/env bash

eval "$(dcd colors get)"

# Identify the currently logged-in User
user="$(who | grep console | awk '{print $1}')"
log "${BMAGENTA}$user${NC}"