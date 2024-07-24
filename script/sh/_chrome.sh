#!/bin/bash

# Function to prompt for directory and set default if none provided
prompt_for_directory() {
    local default_dir="/Users/Shared/$(date '+%s').chrome"
    read -p "Enter directory for depot_tools (default: $default_dir): " user_dir
    user_dir="${user_dir:-$default_dir}"
    if [[ ! -d "$user_dir" ]]; then
        sudo mkdir -p "$user_dir" && sudo chmod 777 "$user_dir"
    fi
    cd "$user_dir" || exit
    echo "$user_dir"
}

# Function to fetch the commit just before the problem version
find_previous_commit() {
    local problem_version="$1"
    git log --pretty=format:"%H %s" > commit_list.txt
    grep -B1 "$problem_version" commit_list.txt | head -n 1 | awk '{print $1}'
}

# Prompt user for directory
DEPOT_DIR=$(prompt_for_directory)

# Clone depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "$DEPOT_DIR/depot_tools"
export PATH="$DEPOT_DIR/depot_tools:$PATH"

# Verify depot_tools installation
if ! command -v gclient &> /dev/null; then
    echo "Error: gclient could not be found. Please check your depot_tools installation."
    exit 1
fi

## Set global git configurations
#git config --global user.name "Your Name"
#git config --global user.email "your@email.com"
#git config --global core.autocrlf false
#git config --global core.filemode false
#git config --global color.ui true

# Fetch Chromium code
mkdir -p "$DEPOT_DIR/src"
cd "$DEPOT_DIR/src"
fetch chromium  # Replace 'chromium' with 'android' or 'ios' for other platforms if needed

# Update dependencies
gclient sync

# Prompt for the problem version
read -p "Enter the Chromium problem version (commit hash or tag): " problem_version

# Find the commit just before the problem version
cd src
previous_commit=$(find_previous_commit "$problem_version")
if [ -z "$previous_commit" ]; then
    echo "Previous commit not found. Please check the problem version you entered."
    exit 1
fi

echo "Checking out the commit before the problem version: $previous_commit"
git checkout "$previous_commit"

# Install build dependencies
./build/install-build-deps.sh

# Build Chromium
gn gen out/Default
ninja -C out/Default chrome

echo "Chromium setup and build for the commit before $problem_version are complete."
