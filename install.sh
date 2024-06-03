#!/usr/bin/env zsh
## Copyright 2024 Douglas Chiri, DC87 Solutions LLC. All rights reserved.

# Color constants
source ./etc/colors.sh

# Installation constants
export basePath='/opt/script'
export scriptsContainer="$basePath/script"
export user

## SECTION 0: HELPER FUNCTIONS
updateFile(){
  local base64String="$1"
  local appendLine=$(echo "$base64String" | base64 -d)
  local output=$(grep -Fv "$appendLine" "$outFile")

  echo -e " ${BYELLOW}└──╼${NC}  ${RED}Append: $outFile${NC}:\t${CYAN}$appendLine${NC}"

  printf "%s\n" "$output" > "$outFile"
  echo "$appendLine" >> "$outFile"
}


## SECTION 1: PREPARE & INSTALL
# Print welcome message
echo -ne "${YELLOW}══════ ***-> Hang On... <-*** ══════${NC}"
sudo rm -rf "$basePath"
# Copy to the install path
## Get the true path:
lsofOutput="$(lsof | grep "$0" | awk '{print $NF}')"
output="$lsofOutput"
if [[ $lsofOutput == "" ]]; then
  output="$0"
fi
thisPath=$output
echo -ne "\r                                             \r";
log "SELF:\t ${CYAN}$thisPath${NC}"

sleep 0.4
thisPath="$(dirname $(realpath $thisPath))"
sleep 0.4
log "real:\t ${RED}$thisPath${NC}"
log "basePath:\t ${CYAN}$basePath${NC}"

mkdir -p "$basePath"
copyPath="$(dirname $basePath)"
log "COPYING: <$thisPath> to <$copyPath/>"
sudo cp -R "$thisPath" "$copyPath" || exit -2
cd "$basePath" || exit -1

# Get list of subdirectories
declare -a dirs=($(ls -F "$scriptsContainer" | grep '/' | awk '{print $1}'))
log "${GREEN}scriptsContainer${NC}:\t $scriptsContainer"

# Remove and recreate the symlink folder
binPath="$basePath/bin"
rm -rf "$binPath"
mkdir -p "$binPath" > /dev/null 2>&1
log "symlinks @:\t ${CYAN}$binPath${NC}";
sleep 0.4

echo -e "${BYELLOW}  ********\t********\t********\t********${NC}"
# Enumerate the utility subdirectories (organized by type)
for dir in "${dirs[@]}"; do      # 🔴Enumerate the folders of script container directory
  subdir="$scriptsContainer/$dir"
  log "${MAGENTA}Elaborating${NC}: ${BYELLOW}$subdir${NC}"
  pushd "$subdir" > /dev/null || { echo "Failed to navigate to $subdir"; continue; }

  declare -a files=($(ls -F "$subdir" | grep '*' | awk -F'*' '{print $1}'))
  for file in "${files[@]}"; do  # 🔴Enumerate & link the scripts to the symlink dir
    linkName=$(echo "$file" | awk -F'.' '{print $1}')
    echo -ne " ${BYELLOW}└──╼${NC}  linking: ${CYAN}$file${NC} as ${GREEN}$linkName${NC}"
    echo -ne "\t(${BBLUE}$binPath/$linkName${NC})"
    echo ""
    ln -s "$subdir/$file" "$binPath/$linkName" || { echo "Failed to link $file"; continue; }
  done
  popd > /dev/null
done
log "COPY ${BGREEN}COMPLETE${NC}!"


## SECTION 2: UPDATE ZSH PROFILE
# Identify the currently logged-in User
user="$(who | grep console | awk '{print $1}')"
echo -e "${YELLOW}==>${NC} USER:\t${MAGENTA}$user${NC}"
export outFile="/Users/$user/.zshrc"

# Update current .zshrc (while preventing duplicate entries)
updateFile 'UEFUSD0vb3B0L3NjcmlwdDokUEFUSAo='
updateFile 'YWxpYXMgY2RycD0nZXZhbCBjZCBcIiQocmVhbHBhdGggLilcIic='


## SECTION 3: CLEAN-UP & STAGING
# Write `dcd`
log "Writing ${BCYAN}dcd${NC} executable to ${CYAN}$basePath/dcd${NC}"
echo 'IyEvdXNyL2Jpbi9lbnYgenNoCgpzb3VyY2UgIi9vcHQvc2NyaXB0L2V0Yy9jb2xvcnMuc2giCmV2YWwgYmFzaCAtYyAiL29wdC9zY3JpcHQvYmluLyRAIgo=' | base64 -d > "$basePath/dcd"

echo -ne " ${YELLOW2}└──╼${NC}  ${GREEN}FINAL${NC}:  ${BGREEN}OK${NC}"! #${BLUE2}
cat "$currentProfile"
echo -e "${NC}"
echo ''
log "Setting ${BCYAN}dcd${NC} permissions..."
chmod 755 "$basePath/dcd"

### UNCOMMENT LATER AND FIX
#echo 'YWxpYXMgY2RycD0nZXZhbCBjZCBcIiQocmVhbHBhdGggLilcIic=' | base64 -d >> ~/.zshrc
#(cat ~/.zshrc | grep -v
#YWxpYXMgY2RycD0nZXZhbCBjZCBcIi9Vc2Vycy9TaGFyZWQvc2NyaXB0XCInCg==



# Fix perms on the install directory
log "Updating ${CYAN}$basePath${NC} permissions..."
sudo chown -R "$user" "$basePath"
chmod -R 755 "$basePath"

## Notify: Install complete
log "Installation ${BGREEN}COMPLETE${NC}!"
log "TREE:"
tree "$basePath" || log "${YELLOW}tree${NC} not installed..."
echo;

# Switch to the specified user and start a new login shell, replacing the current shell
#
#echo
#log "Log File"
#log '--------'
#cat "$logFile"
#rm -f "$logFile"

exec su - $user -c "exec zsh"
