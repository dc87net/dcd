#!/usr/bin/env zsh

source "$(defaults read /opt/script/config.plist installTo)/etc/colors.sh"
gptDir="$(defaults read /opt/script/config.plist installTo)/gpt"

# Make sure there was a OpenAI scriptlet specificed
[[ -z "$1" ]] && exit -100

# Parse args
CMD="$1"; shift
ARGS="$*"
log "C:<$CMD>\t A:<$ARGS>"; echo;  # DEBUG

# Call the correct scriptlet
(exec eval '"$gptDir/${CMD}.py"')
