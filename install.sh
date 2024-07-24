#!/usr/bin/env zsh
## Rel.:  /install.sh
## Copyright 2024 - Douglas C <dc87(dot)net(slash)dcd>; licenses are granted under GNU GPLv3. See `LICENSE` file.
## Installs `dcd` to $basePath; symlinks files in ./script marked u+x to $scriptsContainer

# shellcheck disable=SC2242

# Color constants
source ./etc/colors.sh
log "${MAGENTA}$(date)${NC}" || {
  cat <<< "==>  Error: Unable to find required build file. Are you in the right place?";
  exit -1;
}

# Installation constants
export basePath='/opt/script'
log "SCRIPT-->  '$(dirname $0)/$(basename $0)"
export scriptsContainer="$basePath/script"
export user


log "$(date)"

## SECTION 0: HELPER FUNCTIONS
updateFile(){
  local base64String="$1"
  local appendLine=$(echo "$base64String" | base64 -d) || "$(echo)";
  local output=$(grep -Fv "$appendLine" "$outFile")

  echo -e " ${BYELLOW}└──╼${NC}  ${RED}Append: ${CYAN}$appendLine${NC}"
  [[ -f "$HOME/.zshrc" ]] &&{
    echo -e " ${BYELLOW}└──╼${NC}  ${RED}Append: as ${YELLOW}Import${NC}:  extant ${CYAN}.zshrc${NC}";
#    cat "$HOME/.zshrc"
  } || { echo -e " ${BYELLOW}└──╼${NC}  ${YELLOW}Notice: ${RED} No extant ${CYAN}.zshrc${RED} -- Continuing ...${NC}"; }

  printf "%s\n" "$output" > "$outFile"
  echo "$appendLine" >> "$outFile"
}

#- Must run as root for installation
if [[ "$(whoami)" != 'root' ]]; then
  echo -e "${BMAGENTA}==>${NC} Installation requires ${BRED}root${NC}\n\tUse: ${BCYAN}sudo bash install.sh${NC}"
  exit 100
fi


#- SECTION 1: PREPARE & INSTALL
# Print welcome message
echo -ne "${YELLOW}══════════ ***-> Hang On...! <-*** ═════════${NC}"
sudo rm -rf "$basePath"
# Copy to the install path
## Get the true path of this install script:
lsofOutput="$(lsof | grep "$0" | awk '{print $NF}')"
output="$lsofOutput"
if [[ $lsofOutput == "" ]]; then
  output="$0"
fi
thisPath=$output
echo -ne "\r                                             \r";
log "SELF:\t ${CYAN}$thisPath${NC}"		      ## THIS SCRIPT  (with name)
sleep 0.4
export thisPath="$(dirname $(realpath $thisPath 2>/dev/null))"    ## THISPATH     (this scrip's path)
sleep 0.4
log "thisPath/real:  ${RED}$thisPath${NC}"; cd "$thisPath" || exit -1;
log "basePath:     ${BCYAN}$basePath${NC}"

mkdir -p "$basePath"
export copyPath="$(dirname $basePath)"                 ## COPYPATH
log "COPYING: <${CYAN}$thisPath${NC}> to <${BCYAN}$copyPath/${NC}>"
sudo cp -R "$thisPath" "$copyPath" || exit -2
rm -rf "$copyPath/.git" || log "${RED}Failed to remove <${BRED}$copyPath/.git${NC}>"
cd "$basePath" || exit -1

# Get list of subdirectories
declare -a dirs=($(ls -F "$scriptsContainer" | grep '/' | awk '{print $1}'))
log "${BCYAN}scriptsContainer${NC}:\t $scriptsContainer"

# Remove and recreate the symlink folder
binPath="$basePath/bin"
rm -rf "$binPath"
mkdir -p "$binPath" > /dev/null 2>&1
log "${YELLOW}SYMLINKS${NC} @\t ${BCYAN}$binPath${NC}";
sleep 0.4


echo -e "${BYELLOW}  ********\t********\t********\t********${NC}"
# Enumerate the utility subdirectories (organized by type)
for dir in "${dirs[@]}"; do      # 🔴 Enumerate the folders of script container directory
  subdir="$scriptsContainer/$dir"
  log "${MAGENTA}Elaborating${NC}: ${BYELLOW}$subdir${NC}"
  pushd "$subdir" > /dev/null || { echo "Failed to navigate to $subdir"; continue; }

  declare -a files=($(ls -F "$subdir" | grep '*' | awk -F'*' '{print $1}'))
  for file in "${files[@]}"; do  # 🔴 Enumerate & link the scripts to the symlink dir
    linkName=$(echo "$file" | awk -F'.' '{print $1}')
    echo -ne " ${BYELLOW}└──╼${NC}  linking: ${CYAN}$file${NC} as ${BCYAN}$linkName${NC}"
    echo -ne "\t(${BLUE}$binPath/$linkName${NC})"
    echo ""
    ln -s "$subdir/$file" "$binPath/$linkName" || { echo "${RED}ERROR${NC}: ${BRED}Failed to link ${BYELLOW}$file${NC}"; continue; }
  done
  popd > /dev/null
done
log "COPY ${BGREEN}COMPLETE${NC}!"


#- SECTION 2: UPDATE ZSH PROFILE
# Identify the currently logged-in User
user="$(who | grep console | awk '{print $1}')"
echo -e "${BYELLOW}==> ${MAGENTA}USER:  ${BMAGENTA}$user${NC}"
export outFile="/Users/$user/.zshrc"

# Update current .zshrc (while preventing duplicate entries)
# A accurate translation is always directly below each CMD
updateFile "/opt/script:${PATH}"
  # PATH=/opt/script:$PATH
#%updateFile 'YWxpYXMgY2RycD0nZXZhbCBjZCBcIiQocmVhbHBhdGggLilcIic='
eval "(echo 'PATH=/opt/script:$PATH' | tee -a ~/.zshrc && echo '  --> Appended')" || { echo Append Error!; (exit 1); }


#- SECTION 3: CLEAN-UP & STAGING
# Write `dcd`
log "Writing ${BMAGENTA}dcd${NC} executable to ${CYAN}$basePath/dcd${NC}"
#echo 'IyEvdXNyL2Jpbi9lbnYgenNoCgpzb3VyY2UgIi9vcHQvc2NyaXB0L2V0Yy9jb2xvcnMuc2giCmV2YWwgYmFzaCAtYyAiL29wdC9zY3JpcHQvYmluLyRAIgo=' | base64 -d > "$basePath/dcd"
cp ./dcd /opt/script

echo -ne " ${YELLOW}└──╼${NC}  ${GREEN}FINAL${NC}:  ${BGREEN}OK${NC}!" #${BLUE2}
#cat "$currentProfile"
echo -e "${NC}"
echo ''
log "Setting ${BCYAN}dcd${NC} permissions: ${BGREEN}755${NC} ${CYAN}$basePath/dcd${NC}"
chmod 755 "$basePath/dcd"

### UNCOMMENT LATER AND FIX
#echo 'YWxpYXMgY2RycD0nZXZhbCBjZCBcIiQocmVhbHBhdGggLilcIic=' | base64 -d >> ~/.zshrc
#(cat ~/.zshrc | grep -v
#YWxpYXMgY2RycD0nZXZhbCBjZCBcIi9Vc2Vycy9TaGFyZWQvc2NyaXB0XCInCg==

# Fix perms on the install directory
log "Updating ${CYAN}$basePath${NC} permissions..."
sudo chown -R "$user" "$basePath"
chmod -R 755 "$basePath"

# Ensure `defaults` are set
configPlist="/opt/script/config"
touch "${configPlist}.plist"
chmod 777 "${configPlist}.plist"  ##TODO: FIX THIS!

if [[ -$(defaults read /opt/script/config installFrom 2>/dev/null | wc -l | awk '{print $1}') -eq 0 ]]; then # installFrom NOT set
  log "${BRED}Setting ${CYAN}defaults${NC}: ${BMAGENTA}installFrom${NC}  --> ${BCYAN}$thisPath${NC}"
  defaults write ${configPlist} installFrom "${thisPath}"; else
    log "${BGREEN}OK - ${MAGENTA}installFrom${NC} --> ${BGREEN}$(defaults read /opt/script/config installFrom)${NC}"; fi

if [[ -$(defaults read /opt/script/config installTo   2>/dev/null | wc -l | awk '{print $1}') -eq 0 ]]; then   # installTo NOT set
  log "${BRED}Setting ${CYAN}defaults${NC}: ${BMAGENTA}installTo  ${NC}  --> ${BCYAN}$basePath${NC}"
  defaults write $configPlist installTo ${basePath}; else
    log "${BGREEN}OK - ${MAGENTA}installTo${NC}   --> ${BGREEN}$(defaults read /opt/script/config installTo)${NC}"; fi
chmod 777 "$configPlist.plist"
log "❓ ${RED}FROM${NC}: ${BYELLOW}$(defaults read /opt/script/config installFrom)${NC}\t ${RED}TO${NC}:"\
    "${BYELLOW}$(defaults read /opt/script/config installTo)${NC}"

## Notify: Install complete
log "Installation ${BGREEN}COMPLETE${NC}!";
echo -e "${BYELLOW}  ********\t********\t********\t********${NC}"

# Draw the finalized directory tree of the install destination
log "${BMAGENTA}TREE${NC}:"
#tcmd=$(tree "$basePath" | base64 || echo "${YELLOW}tree${NC} not installed..." | base64)s
#log <<<  "$(echo $tcmd | base64 -d)"
tree "$basePath"
echo;

tee -a ~/.zshrc <<< "$(eval cat /Users/Shared/script/etc/zshrc-base.sh)" || exit -5

# Switch to the specified user and start a new login shell, replacing the current shell
echo -ne "Enter a new shell?[enter=>YES/other=>no] "
read res1
#[[ "${res1,,}" =~ ^y(es)?$ ]] &&{
#  log "Starting subshell ... ";
[[ "$res1" != '' ]] &&
  exec su - "$user" -c "exec zsh";
#}


##TODO: Implement Support: Log to file.
{
#echo
#log "Log File"
#log '--------'
#cat "$logFile"
#rm -f "$logFile"
:;
}
