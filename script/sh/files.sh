#!/usr/bin/env zsh

eval "$(dcd colors get)"

#targetDir=''

# check to see if dir secified; else use cwd
[[ -z $string1 ]] && targetDir="$(realpath "$PWD")" || targetDir="$(realpath "$1")";
pushd "$targetDir" || { log "Error: Unable to push directory to stack"; exit 1; };


# enumerate files
list="$(ls -lp | grep -v '/' | tail -n+2)";
list="$(echo -e $list | awk '{print $NF}')";
#xargs -I{}


echo "$(log "$(dcd box \'${targetDir}\')")" > /dev/stderr;
echo -e "$list"



popd && exit 0 || exit 2;
