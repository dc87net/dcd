#!/usr/bin/env zsh
##% Displays launch daemons/agents/services
##  A component of {TOOL} %##


### PRE
export H='ACED'
eval  "$(../../dcd colors get)"
#exec 2>/dev/null

### LOGIC
SLA="$(ls -laOG /Library/LaunchAgents | xargs -I{} zsh -c "echo {} | awk '{print \$NF}'" | tail -n +4 | sort)"    #🔵 System → Launch Agents
SLD="$(ls -laOG /Library/LaunchDaemons | xargs -I{} zsh -c "echo {} | awk '{print \$NF}'" | tail -n +4 | sort)"   #🔵 System → Launch Agents
ULA="$(ls -laOG ~/Library/LaunchAgents | xargs -I{} zsh -c "echo {} | awk '{print \$NF}'" | tail -n +4 | sort)"   #🔵 System → Launch Agents

echo -e "${GREEN}$(dcd box "\'SYSTEM LAUNCH AGENTS\'")${NC}"
echo $SLA; echo
echo -e "${GREEN}$(dcd box "\'SYSTEM LAUNCH DAEMONS\'")${NC}"
echo $SLD; echo
echo -e "${GREEN}$(dcd box "\'USER LAUNCH AGENTS\'")${NC}"
echo $ULA; echo
