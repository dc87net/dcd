#!/bin/bash
## NON-STAND ALONE
##TODO:  Add install vars to dcd

## KEY VARIABLES
# Installation constants
export basePath='/opt/script'
export scriptsContainer="$basePath/script"
export cmdScript="dcd"

## LOGIC
# Print list as tree
echo;
log "${RED} scripts can be called via ${BCYAN}${cmdScript}${NC}"
echo -e "${YELLOW}-------------------------------------------------------------------------------${NC}"
tree "$scriptsContainer"
echo -e "${YELLOW}-------------------------------------------------------------------------------${NC}"

source ../priv/colors.sh
#
#bash -c  (cat "
#source ../priv/colors.sh
#bgtask=$(* &)    # Launch nano in the background and capture its process ID
#log "pid:\t $bgtask"    # Print the process ID
#bgPath="$(echo $pid | xargs ps -o %)"
#log "${bgPath}"
#kill -9 $bgtask   # Kill the nano process
#"

#

bash -c "$(cat <<< '
#source ../priv/colors.sh

log "POS1:\t $1"
$1 &                # Launch the command in the background
bgtask=$!           # Capture its process ID

log "$bgtask -- $!"   # Print the process ID
log "$(ps -ax -p $bgtask -o comm= | awk '{print \$5}')" # Get the command name of the process

kill -9 $bgtask     # Kill the process
')" _ 'nano'
