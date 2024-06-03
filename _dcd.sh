#!/usr/bin/env zsh

#source "/opt/script/etc/colors.sh"

echo -e "-----\n0\t$0\n@\t$@\n*\t$*\n-----"; echo;

eval bash -c "$(dirname $0)/bin/$@"
