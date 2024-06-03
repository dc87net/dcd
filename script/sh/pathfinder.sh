#!/bin/bash
## Outputs the fully qualified, resolved PATH of the current script

getScriptPath(){
#  echo -e "$0"
  lsofOutput="$(lsof | grep "$0" | awk '{print $NF}')"
  output="$lsofOutput"
  if [[ $lsofOutput == "" ]]; then
    output="$0"
  fi
  echo "$output"
  exit 0
}

[ -$# -gt 0 ] && {

} || {
  getScriptP
}