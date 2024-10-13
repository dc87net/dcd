#!/usr/bin/env zsh
# Quick scratch pad; copies to the clipboard.

eval "$(dcd colors get)"

header="$(dcd box 'Scratch Pad')"

log "[ Ctrd-d to finish] "
echo -e "$header"


#res=$(rlwrap cat)

res=''
res=res+$()
echo -e "$res"
