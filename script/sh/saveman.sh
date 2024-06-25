#!/usr/bin/env zsh
## Facilitates saving a man page to html, preserving some formatting such as headings, bold text, and bulleted lists.

eval "$(dcd colors get)"
user="$(dcd user)"

[[ "$1" ]] && : || { echo -e "Usage:\n  ${MAGENTA}saveman${NC} ${CYAN}manpage manwidth${NC}"; }

export saveLocation='/Users/Shared/man/mac/'
mkdir -p $saveLocation 2>/dev/null

# Get the man page, formatted to be "$2" columns wide.
(MANWIDTH="$2" man $1) | man2html | sudo tee "$saveLocation/$1.htm" >/dev/null
sudo chown -R "$user" "$saveLocation"
sudo chmod -R 555 "$saveLocation"

exit 0;

#####
#(echo -n "man page to save? "; read res2; res1="$saveLocation"; mkdir -p "$res1"; man "$res2" | col -b | tee "$res1/$res2.txt" >/dev/null; open "$res1/$res2.txt")