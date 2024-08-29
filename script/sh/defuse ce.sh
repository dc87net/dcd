#!/usr/bin/env zsh

eval "$(/opt/script/dcd colors get 2>/dev/null)" || exit 127

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  log "🚷 Not running as root. Attempting to elevate privileges..."
  # Re-run the script as root
  (exec sudo "$0" "$@") || exit -1
  log "🍾 Finshed as root"
  exit $?
else
  log "ℹ️ Running as root:"
fi

##########

log "$(dcd box 'Defusing CE')"

cd /Library/LaunchDaemons
list="$(ls -la | awk '{print $NF}' | grep plist | grep 'vnt.')"

while IFS= read -r line; do
  # Perform operations on $line
  echo ">> Processing: $line"
  mv $line /Users/douglas/Downloads/cve/
done <<< "$list"
ps auxc | grep Cov | awk '{print $2}' | xargs -I{} kill -9 {} && mv /Applications/Covenant\ Eyes.app/ /Applications/Covenant\ Eyes2.app/
