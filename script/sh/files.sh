#!/usr/bin/env zsh

eval "$(dcd colors get)"
export targetDir=''


# check to see if dir secified; else use cwd
[[ -z $string1 ]] && targetDir="$(realpath "$PWD")" || targetDir="$(realpath "$1")";

# Print header to stderr unless this is quiet mode
[[ "$*" == '-q' ]] || echo "$(log "$(dcd box \'${targetDir}\')")" > /dev/stderr;

# cd  to the target directory
pushd "$targetDir" || { log "Error: Unable to push directory to stack"; exit 1; };

# enumerate files
list="$(ls -lp | grep -v '/' | tail -n+2)";
list="$(echo -e $list | awk '{print $NF}')";



## print the list
# if `-f`, print the fq path
#[[ "$*" == '-f' ]] && echo -n "$targetDir/"
echo -e "$list"



popd && exit 0 || exit 2;
