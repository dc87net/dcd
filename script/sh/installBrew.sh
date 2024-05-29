#!/bin/bash

# Homebrew-specified install command (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Base-64 encoded 'extra' commands Homebrew recommends for adding values to PATH and the current env
echo "Adding the following to zsh and current environment:"
echo "----------------------------------------------------"
echo 'KGVjaG87IGVjaG8gJ2V2YWwgIiQoL29wdC9ob21lYnJldy9iaW4vYnJldyBzaGVsbGVudikiJykgPj4gL1VzZXJzL2RvdWdsYXMvLnpwcm9maWxlCiAgICBldmFsICIkKC9vcHQvaG9tZWJyZXcvYmluL2JyZXcgc2hlbGxlbnYpIgo=' | base64 -d
eval "$(echo 'KGVjaG87IGVjaG8gJ2V2YWwgIiQoL29wdC9ob21lYnJldy9iaW4vYnJldyBzaGVsbGVudikiJykgPj4gL1VzZXJzL2RvdWdsYXMvLnpwcm9maWxlCiAgICBldmFsICIkKC9vcHQvaG9tZWJyZXcvYmluL2JyZXcgc2hlbGxlbnYpIgo=' | base64 -d)"
exec /bin/zsh