#!/usr/bin/env zsh
# sets clipboard to the path of the command passed

eval "$(dcd colors get)"

[[ "$*" ]]&&{
  eval echo -n "$(which "$1")" | tee /dev/tty | pbcopy;
  exit 0;
}||{
  log "${BRED}ERROR${NC}: ${CYAN}name${NC} not specified."
  exit 98
}
