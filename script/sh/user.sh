#!/usr/bin/env zsh

# Identify the currently logged-in User
user="$(who | grep console | awk '{print $1}')"
uid="$(id -u $user)"
echo -en "$user";echo -e "\t$uid">/dev/stderr;
#echo -e "${BYELLOW}==> ${MAGENTA}USER:  ${BMAGENTA}$user${NC}"
