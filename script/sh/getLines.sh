#!/usr/bin/env zsh

## Header and Setup
sleepTime=1
echo -e "---------\nKill List\n=========";
  tfile="$(mktemp "$HOME/logdc/kill/$(date).log")";
cat > "$tfile" << 'EOF'
AXVisualSupportAgent
naturallanguaged
triald
aneuserd
aned
intelligenceplatformd
intelligenceflowd
IntelligencePlatformComputeService
cameracaptured
appleh13camerad
AirPlayUIAgent
AirPlayXPCHelper
EOF
  list="$(cat "$tfile")"; #echo "$list";  ### Establish the in-memory "list"
cat "$tfile" | cat -n;
rm -f "$tfile";
echo -e "=========\n";

## Functions
function killLoop(){
  while IFS= read -r line;do
#    echo "Text read from line:\t $line";
    echo -ne "Destroy processes like:\t < $line > ...";
    export kpid="$(pgrep $line)";  #PID List
    echo -en "\n$kpid" | tee | xargs -I{} sudo kill -9 {};
      [[ $? ]] && echo -ne "\n$kpid\t OK!  ✅" || { echo "\tFailed to kill:\t < $line >" && exit $kpid; };
    echo;
  done <<< "$*";
};

function main(){
  :
  # sleep loop
  while [[ true ]];do
      killLoop "$list" && echo -n "Sleep " || echo "FATAL ERROR!";  ## <<---- killLoop() called
      export t=''&&{ t=$sleepTime; echo "$t ..."; };
      [[ "$0" ]] && sleep $t;
      echo -e "\n"
  done;
};

main
exit 98;
