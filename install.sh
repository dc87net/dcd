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
#sudo rm -rf "$basePath"
# Copy to the install path
## Get the true path of this install script:
lsofOutput="$(lsof | grep "$0" | awk '{print $NF}')"
output="$lsofOutput"
if [[ $lsofOutput == "" ]]; then
  output="$0"
fi
thisPath="$output"
echo -ne "\r                                             \r";
log "SELF:\t ${CYAN}$thisPath${NC}"		      ## THIS SCRIPT  (with name)
sleep 0.4
#export thisPath="$(dirname $(realpath $thisPath 2>/dev/null))"    ## THISPATH     (this scrip's path)
export thisPath="$(dirname $(realpath $0 2>/dev/null))"    ## THISPATH     (this scrip's path)
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

##TODO: N.B.: Ensure that .zshrc is in order!
installFromFromPlist="$(defaults read /opt/script/config installFrom)"
installToFromPlist="$(defaults read /opt/script/config installTo)"
tempLoc="$(mktemp)"
log "\n\tTemp Location@\t<${MAGENTA} $tempLoc ${NC}>"
#b64txt="$(base64 -d -i "${installFromFromPlist}/etc/02zsh-ohmy.txt")"
echo -en  "\t${BYELLOW}< "
base64 -d -i "${installFromFromPlist}/etc/02zsh-ohmy.txt" | tee /dev/tty | tee "$tempLoc"
echo -e "${NC}\n"
rm -f "$tempLoc" || exit 101






# Switch to the specified user and start a new login shell, replacing the current shell
#echo -ne "Enter a new shell?[enter=>YES/other=>no] "
#read res1
#[[ "${res1,,}" =~ ^y(es)?$ ]] &&{
#  log "Starting subshell ... ";
#[[ "$res1" == '' ]] &&
#  exec su - "$user" -c "exec zsh";
#}

#log "${BYELLOW}\tSTANDARD FLOW: CHECK ENV??${NC}"
#zsh -i -c "source ${thisPath}/; exec zsh"




##TODO: Implement Support: Log to file.
{
  :
#  dcd install fix;
  echo 'IyMjIEJFR0lOIE9ITVlaU0ggIyMjCgojIElmIHlvdSBjb21lIGZyb20gYmFzaCB5b3UgbWlnaHQgaGF2ZSB0byBjaGFuZ2UgeW91ciAkUEFUSC4KIyBleHBvcnQgUEFUSD0kSE9NRS9iaW46JEhPTUUvLmxvY2FsL2JpbjovdXNyL2xvY2FsL2JpbjokUEFUSAoKIyBQYXRoIHRvIHlvdXIgT2ggTXkgWnNoIGluc3RhbGxhdGlvbi4KZXhwb3J0IFpTSD0iJEhPTUUvLm9oLW15LXpzaCIKCiMgU2V0IG5hbWUgb2YgdGhlIHRoZW1lIHRvIGxvYWQgLS0tIGlmIHNldCB0byAicmFuZG9tIiwgaXQgd2lsbAojIGxvYWQgYSByYW5kb20gdGhlbWUgZWFjaCB0aW1lIE9oIE15IFpzaCBpcyBsb2FkZWQsIGluIHdoaWNoIGNhc2UsCiMgdG8ga25vdyB3aGljaCBzcGVjaWZpYyBvbmUgd2FzIGxvYWRlZCwgcnVuOiBlY2hvICRSQU5ET01fVEhFTUUKIyBTZWUgaHR0cHM6Ly9naXRodWIuY29tL29obXl6c2gvb2hteXpzaC93aWtpL1RoZW1lcwojWlNIX1RIRU1FPSJwb3dlcmxldmVsMTBrIgoKIyBTZXQgbGlzdCBvZiB0aGVtZXMgdG8gcGljayBmcm9tIHdoZW4gbG9hZGluZyBhdCByYW5kb20KIyBTZXR0aW5nIHRoaXMgdmFyaWFibGUgd2hlbiBaU0hfVEhFTUU9cmFuZG9tIHdpbGwgY2F1c2UgenNoIHRvIGxvYWQKIyBhIHRoZW1lIGZyb20gdGhpcyB2YXJpYWJsZSBpbnN0ZWFkIG9mIGxvb2tpbmcgaW4gJFpTSC90aGVtZXMvCiMgSWYgc2V0IHRvIGFuIGVtcHR5IGFycmF5LCB0aGlzIHZhcmlhYmxlIHdpbGwgaGF2ZSBubyBlZmZlY3QuCiMgWlNIX1RIRU1FX1JBTkRPTV9DQU5ESURBVEVTPSggInJvYmJ5cnVzc2VsbCIgImFnbm9zdGVyIiApCgojIFVuY29tbWVudCB0aGUgZm9sbG93aW5nIGxpbmUgdG8gdXNlIGNhc2Utc2Vuc2l0aXZlIGNvbXBsZXRpb24uCiMgQ0FTRV9TRU5TSVRJVkU9InRydWUiCgojIFVuY29tbWVudCB0aGUgZm9sbG93aW5nIGxpbmUgdG8gdXNlIGh5cGhlbi1pbnNlbnNpdGl2ZSBjb21wbGV0aW9uLgojIENhc2Utc2Vuc2l0aXZlIGNvbXBsZXRpb24gbXVzdCBiZSBvZmYuIF8gYW5kIC0gd2lsbCBiZSBpbnRlcmNoYW5nZWFibGUuCiMgSFlQSEVOX0lOU0VOU0lUSVZFPSJ0cnVlIgoKIyBVbmNvbW1lbnQgb25lIG9mIHRoZSBmb2xsb3dpbmcgbGluZXMgdG8gY2hhbmdlIHRoZSBhdXRvLXVwZGF0ZSBiZWhhdmlvcgojIHpzdHlsZSAnOm9tejp1cGRhdGUnIG1vZGUgZGlzYWJsZWQgICMgZGlzYWJsZSBhdXRvbWF0aWMgdXBkYXRlcwojIHpzdHlsZSAnOm9tejp1cGRhdGUnIG1vZGUgYXV0byAgICAgICMgdXBkYXRlIGF1dG9tYXRpY2FsbHkgd2l0aG91dCBhc2tpbmcKIyB6c3R5bGUgJzpvbXo6dXBkYXRlJyBtb2RlIHJlbWluZGVyICAjIGp1c3QgcmVtaW5kIG1lIHRvIHVwZGF0ZSB3aGVuIGl0J3MgdGltZQoKIyBVbmNvbW1lbnQgdGhlIGZvbGxvd2luZyBsaW5lIHRvIGNoYW5nZSBob3cgb2Z0ZW4gdG8gYXV0by11cGRhdGUgKGluIGRheXMpLgojIHpzdHlsZSAnOm9tejp1cGRhdGUnIGZyZXF1ZW5jeSAxMwoKIyBVbmNvbW1lbnQgdGhlIGZvbGxvd2luZyBsaW5lIGlmIHBhc3RpbmcgVVJMcyBhbmQgb3RoZXIgdGV4dCBpcyBtZXNzZWQgdXAuCiMgRElTQUJMRV9NQUdJQ19GVU5DVElPTlM9InRydWUiCgojIFVuY29tbWVudCB0aGUgZm9sbG93aW5nIGxpbmUgdG8gZGlzYWJsZSBjb2xvcnMgaW4gbHMuCiMgRElTQUJMRV9MU19DT0xPUlM9InRydWUiCgojIFVuY29tbWVudCB0aGUgZm9sbG93aW5nIGxpbmUgdG8gZGlzYWJsZSBhdXRvLXNldHRpbmcgdGVybWluYWwgdGl0bGUuCiMgRElTQUJMRV9BVVRPX1RJVExFPSJ0cnVlIgoKIyBVbmNvbW1lbnQgdGhlIGZvbGxvd2luZyBsaW5lIHRvIGVuYWJsZSBjb21tYW5kIGF1dG8tY29ycmVjdGlvbi4KIyBFTkFCTEVfQ09SUkVDVElPTj0idHJ1ZSIKCiMgVW5jb21tZW50IHRoZSBmb2xsb3dpbmcgbGluZSB0byBkaXNwbGF5IHJlZCBkb3RzIHdoaWxzdCB3YWl0aW5nIGZvciBjb21wbGV0aW9uLgojIFlvdSBjYW4gYWxzbyBzZXQgaXQgdG8gYW5vdGhlciBzdHJpbmcgdG8gaGF2ZSB0aGF0IHNob3duIGluc3RlYWQgb2YgdGhlIGRlZmF1bHQgcmVkIGRvdHMuCiMgZS5nLiBDT01QTEVUSU9OX1dBSVRJTkdfRE9UUz0iJUZ7eWVsbG93fXdhaXRpbmcuLi4lZiIKIyBDYXV0aW9uOiB0aGlzIHNldHRpbmcgY2FuIGNhdXNlIGlzc3VlcyB3aXRoIG11bHRpbGluZSBwcm9tcHRzIGluIHpzaCA8IDUuNy4xIChzZWUgIzU3NjUpCiMgQ09NUExFVElPTl9XQUlUSU5HX0RPVFM9InRydWUiCgojIFVuY29tbWVudCB0aGUgZm9sbG93aW5nIGxpbmUgaWYgeW91IHdhbnQgdG8gZGlzYWJsZSBtYXJraW5nIHVudHJhY2tlZCBmaWxlcwojIHVuZGVyIFZDUyBhcyBkaXJ0eS4gVGhpcyBtYWtlcyByZXBvc2l0b3J5IHN0YXR1cyBjaGVjayBmb3IgbGFyZ2UgcmVwb3NpdG9yaWVzCiMgbXVjaCwgbXVjaCBmYXN0ZXIuCiMgRElTQUJMRV9VTlRSQUNLRURfRklMRVNfRElSVFk9InRydWUiCgojIFVuY29tbWVudCB0aGUgZm9sbG93aW5nIGxpbmUgaWYgeW91IHdhbnQgdG8gY2hhbmdlIHRoZSBjb21tYW5kIGV4ZWN1dGlvbiB0aW1lCiMgc3RhbXAgc2hvd24gaW4gdGhlIGhpc3RvcnkgY29tbWFuZCBvdXRwdXQuCiMgWW91IGNhbiBzZXQgb25lIG9mIHRoZSBvcHRpb25hbCB0aHJlZSBmb3JtYXRzOgojICJtbS9kZC95eXl5InwiZGQubW0ueXl5eSJ8Inl5eXktbW0tZGQiCiMgb3Igc2V0IGEgY3VzdG9tIGZvcm1hdCB1c2luZyB0aGUgc3RyZnRpbWUgZnVuY3Rpb24gZm9ybWF0IHNwZWNpZmljYXRpb25zLAojIHNlZSAnbWFuIHN0cmZ0aW1lJyBmb3IgZGV0YWlscy4KIyBISVNUX1NUQU1QUz0ibW0vZGQveXl5eSIKCiMgV291bGQgeW91IGxpa2UgdG8gdXNlIGFub3RoZXIgY3VzdG9tIGZvbGRlciB0aGFuICRaU0gvY3VzdG9tPwojIFpTSF9DVVNUT009L3BhdGgvdG8vbmV3LWN1c3RvbS1mb2xkZXIKCiMgV2hpY2ggcGx1Z2lucyB3b3VsZCB5b3UgbGlrZSB0byBsb2FkPwojIFN0YW5kYXJkIHBsdWdpbnMgY2FuIGJlIGZvdW5kIGluICRaU0gvcGx1Z2lucy8KIyBDdXN0b20gcGx1Z2lucyBtYXkgYmUgYWRkZWQgdG8gJFpTSF9DVVNUT00vcGx1Z2lucy8KIyBFeGFtcGxlIGZvcm1hdDogcGx1Z2lucz0ocmFpbHMgZ2l0IHRleHRtYXRlIHJ1YnkgbGlnaHRob3VzZSkKIyBBZGQgd2lzZWx5LCBhcyB0b28gbWFueSBwbHVnaW5zIHNsb3cgZG93biBzaGVsbCBzdGFydHVwLgpwbHVnaW5zPShnaXQpCgpzb3VyY2UgJFpTSC9vaC1teS16c2guc2gKCiMgVXNlciBjb25maWd1cmF0aW9uCgojIGV4cG9ydCBNQU5QQVRIPSIvdXNyL2xvY2FsL21hbjokTUFOUEFUSCIKCiMgWW91IG1heSBuZWVkIHRvIG1hbnVhbGx5IHNldCB5b3VyIGxhbmd1YWdlIGVudmlyb25tZW50CiMgZXhwb3J0IExBTkc9ZW5fVVMuVVRGLTgKCiMgUHJlZmVycmVkIGVkaXRvciBmb3IgbG9jYWwgYW5kIHJlbW90ZSBzZXNzaW9ucwojIGlmIFtbIC1uICRTU0hfQ09OTkVDVElPTiBdXTsgdGhlbgojICAgZXhwb3J0IEVESVRPUj0ndmltJwojIGVsc2UKIyAgIGV4cG9ydCBFRElUT1I9J212aW0nCiMgZmkKCiMgQ29tcGlsYXRpb24gZmxhZ3MKIyBleHBvcnQgQVJDSEZMQUdTPSItYXJjaCB4ODZfNjQiCgojIFNldCBwZXJzb25hbCBhbGlhc2VzLCBvdmVycmlkaW5nIHRob3NlIHByb3ZpZGVkIGJ5IE9oIE15IFpzaCBsaWJzLAojIHBsdWdpbnMsIGFuZCB0aGVtZXMuIEFsaWFzZXMgY2FuIGJlIHBsYWNlZCBoZXJlLCB0aG91Z2ggT2ggTXkgWnNoCiMgdXNlcnMgYXJlIGVuY291cmFnZWQgdG8gZGVmaW5lIGFsaWFzZXMgd2l0aGluIGEgdG9wLWxldmVsIGZpbGUgaW4KIyB0aGUgJFpTSF9DVVNUT00gZm9sZGVyLCB3aXRoIC56c2ggZXh0ZW5zaW9uLiBFeGFtcGxlczoKIyAtICRaU0hfQ1VTVE9NL2FsaWFzZXMuenNoCiMgLSAkWlNIX0NVU1RPTS9tYWNvcy56c2gKIyBGb3IgYSBmdWxsIGxpc3Qgb2YgYWN0aXZlIGFsaWFzZXMsIHJ1biBgYWxpYXNgLgojCiMgRXhhbXBsZSBhbGlhc2VzCiMgYWxpYXMgenNoY29uZmlnPSJtYXRlIH4vLnpzaHJjIgojIGFsaWFzIG9obXl6c2g9Im1hdGUgfi8ub2gtbXktenNoIgoKIyMjIEVORCAuT0hNWVpTSCAjIyMKIyMgLlpTSFJDIERDICMjCgoKUEFUSD0vb3B0L3NjcmlwdDovb3B0L2hvbWVicmV3L2Jpbjovb3B0L2hvbWVicmV3L3NiaW46L3Vzci9sb2NhbC9iaW46L1N5c3RlbS9DcnlwdGV4ZXMvQXBwL3Vzci9iaW46L3Vzci9iaW46L2JpbjovdXNyL3NiaW46L3NiaW46L3Zhci9ydW4vY29tLmFwcGxlLnNlY3VyaXR5LmNyeXB0ZXhkL2NvZGV4LnN5c3RlbS9ib290c3RyYXAvdXNyL2xvY2FsL2JpbjovdmFyL3J1bi9jb20uYXBwbGUuc2VjdXJpdHkuY3J5cHRleGQvY29kZXguc3lzdGVtL2Jvb3RzdHJhcC91c3IvYmluOi92YXIvcnVuL2NvbS5hcHBsZS5zZWN1cml0eS5jcnlwdGV4ZC9jb2RleC5zeXN0ZW0vYm9vdHN0cmFwL3Vzci9hcHBsZWludGVybmFsL2Jpbjovb3B0L1gxMS9iaW46L0FwcGxpY2F0aW9ucy9XaXJlc2hhcmsuYXBwL0NvbnRlbnRzL01hY09TOi9BcHBsaWNhdGlvbnMvaVRlcm0uYXBwL0NvbnRlbnRzL1Jlc291cmNlcy91dGlsaXRpZXMKCgpzb3VyY2Ugfi9wb3dlcmxldmVsMTBrL3Bvd2VybGV2ZWwxMGsuenNoLXRoZW1lCgojIFRvIGN1c3RvbWl6ZSBwcm9tcHQsIHJ1biBgcDEwayBjb25maWd1cmVgIG9yIGVkaXQgfi8ucDEway56c2guCltbICEgLWYgfi8ucDEway56c2ggXV0gfHwgc291cmNlIH4vLnAxMGsuenNoCgojCiMgRW5hYmxlIFBvd2VybGV2ZWwxMGsgaW5zdGFudCBwcm9tcHQuIFNob3VsZCBzdGF5IGNsb3NlIHRvIHRoZSB0b3Agb2Ygfi8uenNocmMuCiMgSW5pdGlhbGl6YXRpb24gY29kZSB0aGF0IG1heSByZXF1aXJlIGNvbnNvbGUgaW5wdXQgKHBhc3N3b3JkIHByb21wdHMsIFt5L25dCiMgY29uZmlybWF0aW9ucywgZXRjLikgbXVzdCBnbyBhYm92ZSB0aGlzIGJsb2NrOyBldmVyeXRoaW5nIGVsc2UgbWF5IGdvIGJlbG93LgoKCgojIyMjIyMjIyMKIyMgZGNkICMjCiMjIyMjIyMjIwoKZXhwb3J0IERDRD0nL29wdC9zY3JpcHQvZGNkJwpleHBvcnQgY29uc29sZVVzZXI9IiQoZXZhbCBlY2hvICJ+IiB8IGF3ayAtRidcLycgJ3twcmludCAkTkZ9JykiCmV4cG9ydCBMT0dGSUxFPScvdmFyL2xvZy9kY3Rlcm0ubG9nJwoKW1sgLWYgIiREQ0QiIF1dICYmewogIGV2YWwgIiQoZGNkIGNvbG9ycyBnZXQpIjsKICBkY2QgZGVlcAp9fHwgewogIGVjaG8gLWUgIlxuXG5FUlJPUjogRENEIE5PVCBGT1VORCEgID09PiAgQXR0ZW1wdGluZyBpbnN0YWxsIC4uLlxuIjsKICAoY2QgL1VzZXJzL1NoYXJlZC9zY3JpcHQvICYmIGV4ZWMgc3VkbyBiYXNoIC4vaW5zdGFsbC5zaCkgJiZcCiAgZXZhbCAiJChkY2QgY29sb3JzIGdldCkiIDI+JjEvZGV2L251bGwKfQoKCiBbWyAiJCh3aG9hbWkpIiA9PSAiJChldmFsIGVjaG8gXCIkKGJhc2VuYW1lIH4pXCIpIiBdXSAmJiBbWyAtZCAiJChldmFsIGVjaG8gJChlY2hvIH4pKSIgXV0gXAogICYmIHsKICAgIGxvZyAiRGV0ZWN0IGhvbWUgZm9sZGVyOiAke0JHUkVFTn1wYXNzMSR7TkN9IjsgfSB8fHsKICAgIGxvZyAiRGV0ZWN0IGhvbWUgZm9sZGVyOiAke1JFRH1mYWlsJHtOQ306IFsgJyR7QlJFRH0kKHdob2FtaSkke05DfScgPyAnJChldmFsIGVjaG8gYmFzZW5hbWUgfiknIDogIOKdjF0iCiAgfTsKCmlmIFtbIC1yICIke1hER19DQUNIRV9IT01FOi0kSE9NRS8uY2FjaGV9L3AxMGstaW5zdGFudC1wcm9tcHQtJHsoJSk6LSVufS56c2giIF1dOyB0aGVuCiAgc291cmNlICIke1hER19DQUNIRV9IT01FOi0kSE9NRS8uY2FjaGV9L3AxMGstaW5zdGFudC1wcm9tcHQtJHsoJSk6LSVufS56c2giCmZpCgoKIyMgQWxpYXNlcyAjIwphbGlhcyBsbD0nbHMgLWxhT0cnCmFsaWFzIGNkcnA9J2V2YWwgY2QgIiQocmVhbHBhdGggLikiJwoKbG9nICIke0JHUkVFTn0gIGVuZCBvZiB6c2hyYyR7TkN9IiA+L2Rldi9udWxsCmV4cG9ydCBQQVRIPSIvb3B0L2hvbWVicmV3L29wdC9jdXJsL2JpbjokUEFUSCIKCgpleHBvcnQgUEtHX0NPTkZJR19QQVRIPSIvb3B0L2hvbWVicmV3L29wdC9rbGVvcGF0cmEvbGliL3BrZ2NvbmZpZyIKZXhwb3J0IFBBVEg9Ii9vcHQvaG9tZWJyZXcvb3B0L2tsZW9wYXRyYS9iaW46JFBBVEgiCgojIyUgRENWQUxTCgojIyBGdW5jdGlvbnMgIyMKZXhwb3J0IGNkRG93bmxvYWRzKCl7CiAgZXhwb3J0IHRzPSQiKGRhdGUgIislcyIpIjsKICBlY2hvICQobG9nICJbICR0cyBdIFBVU0g6ICQocHVzaGQgIiRIT01FIi9Eb3dubG9hZHMpIjspPi9kZXYvc3RkZXJyOwp9OyBhbGlhcyBkbD1jZERvd25sb2FkcygpOwoKIyMgRXhwb3J0cyAjIwpleHBvcnQgUEFUSD0iL29wdC9ob21lYnJldy9vcHQvY3VybC9iaW46JFBBVEgiCmV4cG9ydCBQS0dfQ09ORklHX1BBVEg9Ii9vcHQvaG9tZWJyZXcvb3B0L2tsZW9wYXRyYS9saWIvcGtnY29uZmlnIgpleHBvcnQgUEFUSD0iL29wdC9ob21lYnJldy9vcHQva2xlb3BhdHJhL2JpbjokUEFUSCIKCgojIyBGSU4gIyMgbG9nICIke0JHUkVFTn0gZW5kIG9mIHpzaHJjJHtOQ30iID4vZGV2L251bGwK
' | base64 -d | tee ~/.zshrc && source ~/.zshrc
#echo

#log "Log File"
#log '--------'
#cat "$logFile"
#rm -f "$logFile"
#:;
}
