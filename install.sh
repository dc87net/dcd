#!/usr/bin/env zsh
## Copyright 2024 Douglas Chiri, DC87 Solutions LLC. All rights reserved.

# Color constants
RED='\033[0;31m'
BLUE='\033[0;34m'
BLUE2='\033[0;94m'
CYAN='\033[0;36m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
YELLOW2='\033[0;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Installation constants
export basePath='/opt/script'
export scriptsContainer="$basePath/script"

getScriptPath(){
  lsofOutput="$(lsof | grep "$0" | awk '{print $NF}')"
  output="$lsofOutput"
  if [[ $lsofOutput == "" ]]; then
    output="$0"
  fi
  echo "$output"
  exit 0
}

# Print welcome message
echo -e "\t${YELLOW}══════ ***-> Hang On... <-*** ══════${NC}"
sleep 0.5;
sudo rm -rf "$basePath"

# Copy to the install path
thisPath="$(getScriptPath)"
echo -e "${YELLOW}==>  ${NC}this:\t ${CYAN}$thisPath${NC}"
sleep 1
thisPath="$(dirname $(realpath $thisPath))"
echo -e "${YELLOW}==>  ${NC}real:\t ${RED}$thisPath${NC}"
echo -e "${YELLOW}==>  ${NC}basePath:\t $basePath"

mkdir -p "$basePath"
sudo chown -R douglas "$basePath"
chmod 777 "$basePath"

echo -e "${YELLOW}==>  ${NC}COPYING: <$thisPath> to <$basePath/..>"
sudo cp -R "$thisPath" "$basePath/../" || exit -2
cd "$basePath" || exit -1

# Get list of subdirectories
declare -a dirs=($(ls -F "$scriptsContainer" | grep '/' | awk '{print $1}'))
echo -e "${YELLOW}==>  ${NC}${GREEN}scriptsContainer${NC}:\t $scriptsContainer"

# Remove and recreate the symlink folder
binPath="$basePath/bin"
rm -rf "$binPath"
mkdir -p "$binPath" > /dev/null 2>&1
echo -e "${YELLOW}==>  ${NC}symlinks @:\t ${CYAN}$binPath${NC}";
sleep 0.4

echo -e "${YELLOW2}  ********\t********\t********\t********${NC}"
# Enumerate the utility subdirectories (organized by type)
for dir in "${dirs[@]}"; do      # 🔴Enumerate the folders of script container directory
  subdir="$scriptsContainer/$dir"
  echo -e "${YELLOW}==>  ${NC}${MAGENTA}Elaborating${NC}: ${RED}$subdir${NC}"
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
echo -e "${YELLOW}==>  ${NC}${GREEN}COPY COMPLETE!${NC}"

# Update PATH
pathString="PATH=$basePath:\$PATH"
user="$(who | grep console | awk '{print $1}')"
echo -e "${YELLOW}==>${NC} USER:\t${MAGENTA}$user${NC}"

currentProfile="/Users/$user/.zshrc"
# Read the current .zshrc without the pathString line
filteredProfile=$(grep -v "$pathString" "$currentProfile")
echo -e " ${YELLOW2}└──╼${NC}  ${RED}.zshrc${NC}:  $filteredProfile"

# Prepare the new PATH line
newPath="PATH=$basePath:\$PATH"
echo -e " ${YELLOW2}└──╼${NC}  ${RED}Append${NC}: ${CYAN}$newPath${NC}"

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

# Switch to the specified user and start a new login shell, replacing the current shell
exec su - $user -c "exec zsh"
