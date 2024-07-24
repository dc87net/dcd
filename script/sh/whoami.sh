#!/usr/bin/env bash

eval "$(dcd colors get)"

# Identify the currently logged-in User
user="$(who | grep console | awk '{print $1}')"

O1="$1"; shift
[[ "$O1" ]] &&{
  [[ "$O1" == 'get' ]] &&{  # `get`:  simply echo with no addtional formatting
    echo -n "$user"
  };
  [[ "$O1" == '' ]] &&{     # else; (no argument provided)
    :
  }||{
    log "${BMAGENTA}$user${NC}";
  }
};