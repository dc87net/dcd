#!/usr/bin/env zsh
## Copyright 2024 Douglas Chiri, DC87 Solutions LLC. ALl rights reserved.

# Color constants
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get list of subdirectories
export scriptsPath='/opt/script/script'
declare -a dirs=($(ls -F "$scriptsPath" | grep '/'| awk '{print $NF}'))
echo "Updating utility registry..." #:\t@ $scriptsPath; sleep 0.2

# Remove and recreate the symlink folder
binPath="$scriptsPath/.."
binPath="$(realpath $binPath)/bin"
rm -rf "$binPath"
mkdir -p "$binPath" > /dev/null 2>&1
#echo -e "Symbolic links @:\t $binPath";
sleep 0.4

echo "********"
# Enumerate the utility subdirectories (organized by type)
for dir in $dirs; do      # 🔴Enumerate the folders of script container directory
  subdir="$scriptsPath/$dir"
  pushd "$subdir"
  echo -e "Elaborating ${RED}\e[1m$subdir\e[0m${NC}..."

  declare -a files=($(ls -F "$subdir" | grep '*' | awk -F'*' '{print $1}'))
  for file in $files; do  # 🔴Enumerate & link the scripts to the symlink dir
    linkName=$(echo "$file" | awk -F'.' '{print $1}')
    echo -ne "  -- linking: ${CYAN}$file${NC} as ${BLUE}$linkName${NC}"
    echo -ne "\t@  $binPath/$linkName"
    echo ""
    ln -s "$(pwd)/$file" "$binPath/$linkName"

  done
  popd 2>&1 /dev/null
done