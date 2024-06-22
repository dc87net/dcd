#!/usr/bin/env zsh
## Prints a (fairly reliable) estimation of the depth of the current interactive shell

#- Import colors
eval "$(dcd colors get)"

#- Ensure auxilary tool `pstree` is present
CMD="pstree"
[[ $(which "$CMD") ]]
res1="code: $?"
echo -e "[DEBUG] exit code: $res1"
command -v "$CMD" >/dev/null 2>&1 && {
  :
  } || {
    log "${RED}Error${NC}: ${BRED}this function requires ${CYAN}${CMD}${BRED}; use ${BMAGENTA}dcd ${MAGENTA}install common${NC}";
    exit 1;
  }

#- Get the process tree and count *interactive* shells (not scripts!)
tree="$(pstree -p $PPID)";
depth=$(cat <<< "$tree" | grep -v 'exec' | awk '{print $NF}' | grep 'sh' | grep -cv '\.sh')

log "${BMAGENTA}Interactive${NC} shell depth (${CYAN}approx${NC}):  ${BCYAN}${depth}${NC}"

exit 0;

}