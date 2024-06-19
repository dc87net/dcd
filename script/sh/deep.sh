#!/usr/bin/env bash
## Prints a (fairly reliable) estimation of the depth of the current interactive shell

#- Import colors
eval "$(dcd colors get)"

#- Get the process tree and count *interactive* shells (not scripts!)
tree="$(pstree -p $PPID)";
depth=$(cat <<< "$tree" | grep -v 'exec' | awk '{print $NF}' | grep 'sh' | grep -cv '\.sh')

log "${BMAGENTA}Interactive${NC} shell depth (${CYAN}approx${NC}):  ${BCYAN}${depth}${NC}"

exit 0;
