#!/usr/bin/env zsh
## opens an iTerm2 session

pPath="/Applications/iTerm.app/Contents/MacOS/iTerm2"
tPath=""

[[ -f "$pPath" ]]&&{
  :
  [[ -f "$1" ]]&&{
    tPath="$1"
  }||{
    :
    tPath="$PWD"
  }
  (eval $pPath $tPath)&
}
