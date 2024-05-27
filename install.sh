#!/usr/bin/env zsh
## Copyright 2024 Douglas Chiri, DC87 Solutions LLC. All rights reserved.

# Color constants
source ./etc/colors.sh

# Installation constants
export basePath='/opt/script'
export scriptsContainer="$basePath/script"

# Print welcome message
echo -e "\t${YELLOW}══════ ***-> Hang On... <-*** ══════${NC}"
sudo rm -rf "$basePath"
# Copy to the install path
## Get the true path:
lsofOutput="$(lsof | grep "$0" | awk '{print $NF}')"
output="$lsofOutput"
if [[ $lsofOutput == "" ]]; then
  output="$0"
fi
thisPath=$output
log "this:\t ${CYAN}$thisPath${NC}"

sleep 1
thisPath="$(dirname $(realpath $thisPath))"
log "real:\t ${RED}$thisPath${NC}"
log "basePath:\t $basePath"
read -r

mkdir -p "$basePath"
sudo chown -R douglas "$basePath"
chmod 777 "$basePath"

log "COPYING: <$thisPath> to <$basePath/..>"
sudo cp -R "$thisPath" "$basePath/../" || exit -2
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

echo -e "${YELLOW2}  ********\t********\t********\t********${NC}"
# Enumerate the utility subdirectories (organized by type)
for dir in "${dirs[@]}"; do      # 🔴Enumerate the folders of script container directory
  subdir="$scriptsContainer/$dir"
  log "${MAGENTA}Elaborating${NC}: ${RED}$subdir${NC}"
  pushd "$subdir" > /dev/null || { echo "Failed to navigate to $subdir"; continue; }

  declare -a files=($(ls -F "$subdir" | grep '*' | awk -F'*' '{print $1}'))
  for file in "${files[@]}"; do  # 🔴Enumerate & link the scripts to the symlink dir
    linkName=$(echo "$file" | awk -F'.' '{print $1}')
    echo -ne " ${YELLOW2}└──╼${NC}  linking: ${CYAN}$file${NC} as ${GREEN}$linkName${NC}"
    echo -ne "\t(${BLUE}$binPath/$linkName${NC})"
    echo ""
    ln -s "$subdir/$file" "$binPath/$linkName" || { echo "Failed to link $file"; continue; }
  done
  popd > /dev/null
done
log "${GREEN}COPY COMPLETE!${NC}"

# Update PATH
pathString="PATH=$basePath:\$PATH"
user="$(who | grep console | awk '{print $1}')"
echo -e "${YELLOW}==>${NC} USER:\t${MAGENTA}$user${NC}"

currentProfile="/Users/$user/.zshrc"
# Read the current .zshrc without the pathString line
filteredProfile=$(grep -v "$pathString" "$currentProfile")
echo -e " ${YELLOW2}└──╼${NC}  ${RED}.zshrc${NC}:  OK" #$filteredProfile

# Prepare the new PATH line
newPath="PATH=$basePath:\$PATH"
echo -e " ${YELLOW2}└──╼${NC}  ${RED}Append${NC}: OK" #${CYAN}$newPath${NC}

# Write the updated content back to .zshrc
{
  echo "$filteredProfile"
  echo "$newPath"
} > "$currentProfile.tmp"

# Move the temp file to .zshrc
mv "$currentProfile.tmp" "$currentProfile"

echo -ne " ${YELLOW2}└──╼${NC}  ${RED}FINAL${NC}: ${BLUE2}"
cat "$currentProfile"
echo -e "${NC}"
echo ''

echo 'YWxpYXMgY2RycD0nZXZhbCBjZCBcIiQocmVhbHBhdGggLilcIic=' | base64 -d | tee >> ~/.zshrc
#(cat ~/.zshrc | grep -v
#YWxpYXMgY2RycD0nZXZhbCBjZCBcIi9Vc2Vycy9TaGFyZWQvc2NyaXB0XCInCg==

echo 'IyEvdXNyL2Jpbi9lbnYgenNoCgpldmFsIGJhc2ggLWMgL29wdC9zY3JpcHQvYmluLyRACg==' | base64 -d | tee > "$basePath/dcd"
chmod 755 "$basePath/dcd"
# Switch to the specified user and start a new login shell, replacing the current shell
exec su - $user -c "exec zsh"
