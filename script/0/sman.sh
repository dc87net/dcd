#!/usr/bin/env

eval "$(dcd colors get)"

#export MANWIDTH=120&&man launchctl | col -b | grep -n -A5 -B5 - | awk -F"--" '{for(i=0;i<NF;i++){print $0}}'
cmd="$(cat << "eof"
 export MANWIDTH=120 && man launchctl | col -b | grep -n -A5 -B5 - | awk -v RS="--" 'NF {print $0 "\n"}'
 #export MANWIDTH=140&&man launchctl | grep -n -A5 -B5 - | sed 's/\--/\n//g';
 echo;
eof)";


log "${CYAN}Running${NC}:${NC} <${BYELLOW} $cmd ${NC}>"
(eval $cmd)2>/dev/null
