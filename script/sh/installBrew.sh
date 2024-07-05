#!/usr/bin/env bash
## Installs homebrew if it is not installed; otherwise, exits 100

eval "$(dcd colors get)"
eval "$(dcd colors log)"

[[ $(brew --prefix 2>/dev/null) ]] && { log "${YELLOW}Notice${NC}: ${BCYAN}brew ${BBLACK}is already installed;" \
 "disregard this notice if expected.${NC}"; } || { log "Updating ${BCYAN}brew${NC}"; }

# Homebrew-specified install command (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ $(echo "$PATH" | grep -c 'homebrew') ]]; then
  # Base-64 encoded 'extra' commands Homebrew recommends for adding values to PATH and the current env
  log "${BYELLOW}----------------------------------------------------${NC}"
  log "Adding the following to .zshrc and current environment:"

  #echo 'KGVjaG87IGVjaG8gJ2V2YWwgIiQoL29wdC9ob21lYnJldy9iaW4vYnJldyBzaGVsbGVudikiJykgPj4gL1VzZXJzL2RvdWdsYXMvLnpwcm9maWxlCiAgICBldmFsICIkKC9vcHQvaG9tZWJyZXcvYmluL2JyZXcgc2hlbGxlbnYpIgo=' | base64 -d
  #eval "$(echo 'KGVjaG87IGVjaG8gJ2V2YWwgIiQoL29wdC9ob21lYnJldy9iaW4vYnJldyBzaGVsbGVudikiJykgPj4gL1VzZXJzL2RvdWdsYXMvLnpwcm9maWxlCiAgICBldmFsICIkKC9vcHQvaG9tZWJyZXcvYmluL2JyZXcgc2hlbGxlbnYpIgo=' | base64 -d)"

  res1=$(echo 'KGVjaG87IGVjaG8gJ2V2YWwgIiQoL29wdC9ob21lYnJldy9iaW4vYnJldyBzaGVsbGVudikiJykgPj4gL1VzZXJzL2RvdWdsYXMvLnpwcm9maWxlCiAgICBldmFsICIkKC9vcHQvaG9tZWJyZXcvYmluL2JyZXcgc2hlbGxlbnYpIgo=' | base64 -d)
  echo "$res1"
  eval "$res1"
else
  log "${BCYAN}brew${NC} already in PATH... ${BGREEN}OK${NC}"
fi

# Install oh-my-zsh and powerlevel10k
(yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)")
[[ -d "~/powerlevel10k/" ]] && {
  :; # Do no clone repo; exists on disk.
} || {
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k;
}
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

exec /bin/zsh