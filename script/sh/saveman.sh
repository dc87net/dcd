#!/usr/bin/env zsh

(echo -n "man page to save? "; read res2; res1="/Users/Shared/man/mac/"; mkdir -p "$res1"; man "$res2" | col -b | tee "$res1/$res2.txt" >/dev/null; open "$res1/$res2.txt")