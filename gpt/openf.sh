#!/usr/bin/env zsh

echo -e "Opening the folder in Finder ..."
open .

res1="$(realpath .)"
echo -e "Copying path to clipboard ..."
echo -n "\t"
(echo "$res1") | tee /dev/tty | pbcopy
