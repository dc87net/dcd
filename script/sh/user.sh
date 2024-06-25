#!/usr/bin/env zsh

# Identify the currently logged-in User
user="$(who | grep console | awk '{print $1}')"
echo $user;
#echo -e "${BYELLOW}==> ${MAGENTA}USER:  ${BMAGENTA}$user${NC}"