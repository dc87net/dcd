#!/usr/bin/env zsh
## Copyright 2024 DWC
## Facilitates saving a man page to

export saveLocation='/Users/Shared/man/mac/'

(echo -n "man page to save? "; read res2; res1="$saveLocation"; mkdir -p "$res1"; man "$res2" | col -b | tee "$res1/$res2.txt" >/dev/null; open "$res1/$res2.txt")