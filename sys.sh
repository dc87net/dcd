#!/usr/bin/env zsh
# Wrapper for functions (both Py and Shell) that tweak system values

ARGV="$*"
FULL="$0"
SCRIPT="$(basename "$0")"
SCRIPTDIR="$(realpath "$(dirname "$SCRIPT")")"

echo "1 >>> $ARGV"
echo "2 >>> $FULL"
echo "3 >>> $SCRIPT"
echo "4 >>> $SCRIPTDIR"



#[[ $1 ]]
