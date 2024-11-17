


list="$(pgrep mds)"
log "list"
[[
zsh -c 'pgrep mds | xargs kill -9'
