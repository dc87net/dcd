#!/usr/bin/env zsh

[[ "$1" ]] && { eval echo "\'$(pwd)/$1\'" | pbcopy;  } || { echo "specify a file to add the path to the clipboard" > /dev/stderr; exit 1; }
exit 0;