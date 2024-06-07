#!/usr/bin/env zsh

source "$(defaults read net.dc87.dcd installTo)/etc/colors.sh"

gptDir="$(defaults read net.dc87.dcd installTo)/gpt"

# Make sure there was a OpenAI scriptlet specificed
[[ -z "$1" ]] && exit -100

# Parse args
CMD="$1"; shift
ARGS="$*"
log "C:<$CMD>\t A:<$ARGS>"; echo;  # DEBUG

# Call the correct scriptlet
(exec eval '"$gptDir/${CMD}.py"')