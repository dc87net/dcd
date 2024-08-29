#!/usr/bin/env zsh
# Kills processes matching naturally a user-provided string, with prejudice.

#exec 2>/dev/null
eval "$(dcd colors get)"
export argsv="$(echo $*)"

main(){
  :
}

[[ -n "$argv" ]]&&{
  log "${RED}Killing${NC} processes matching: <${BMAGENTA} $argv ${NC}>";
  res="$(pgrep "$argv")";
  log " > ${CYAN}PIDs${NC}: ${BCYAN}$(echo $res)${NC}";
  echo -e "$res" | xargs -I{} zsh -c "sudo kill -9 {}; echo \" >> kill reports: < \$? > for < {} >\"";
  exit $?
}||{
  log "${RED}Error${NC}: Process?";
  exit 98;
}
