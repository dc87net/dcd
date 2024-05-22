#!/usr/bin/env zsh
## Copyright 2024 Douglas Chiri, DC87 Solutions LLC. ALl rights reserved.

# Color constants
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get list of subdirectories
export base='/opt/script/script'
declare -a dirs=($(ls -F "$base" | grep '/'| awk '{print $NF}'))



echo "Updating utility registry@:\t $base"
mkdir -p "$base/../bin" 2>&1 /dev/null
binPath=$(realpath "$base/../bin")
echo -e "Symbolic links@:\t $binPath"

# Enumerate the utility subdirectories (organized by type)
for dir in $dirs; do      # 🔴Enumerate the folders of script container directory
  subdir="$base/$dir"
  pushd "$subdir"
  echo -e "Elaborating ${RED}\e[1m$subdir\e[0m${NC}..."

  declare -a files=($(ls -F "$subdir" | grep '*' | awk -F'*' '{print $1}'))
  for file in $files; do  # 🔴Enumerate & link the scripts to the symlink dir
    linkName=$(echo "$file" | awk -F'.' '{print $1}')
    echo -e "  -- linking: ${CYAN}$file${NC} as ${BLUE}$linkName${NC}"
    ln -s "$file" "$binPath/$linkName"

  done
  popd 2>&1 /dev/null

  let "count=count+1"
done
