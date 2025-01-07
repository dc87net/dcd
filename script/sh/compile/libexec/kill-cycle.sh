##***** NOT INTENDED FOR STAND-ALONE USE *****##

## Contains a script to be encoded or sourced.
## Purpose: Kills unwanted applications that may be restarted (as by launchd, etc)
## Copyright 2025 DC87 Solutions LLC


  ######################################################################################################################
  # ════ HEREDOC ═══════════════════════════════════════════════════════════════════
cat > "$t1" << 'ASS'
#!/usr/bin/env zsh

#- Must run as root for installation
if [[ "$(whoami)" != 'root' ]]; then
  echo -e "${BMAGENTA}==>${NC} Installation requires ${BRED}root${NC}\n\tUse: ${BCYAN}sudo $0${NC}"
  exit 100
fi

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
diagnosticd
coreduetd
duetexpertd
bluetoothd
MacinTalkAUSP
ThemeWidgetControlViewService
CursorUIViewService
voicebankingd
sysmond
mediaremoted
EOF
  list="$(cat "$tfile")"; #echo "$list";  ### Establish the in-memory "list"
cat "$tfile" | cat -n;
rm -f "$tfile";
echo -e "=========\n";

## Functions
function killLoop(){
  while IFS= read -r line;do
    echo -ne "Destroy processes like:\t < $line > ...";
    echo -en "\n$line" | tee | xargs -I{} sudo killall -9 {};
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
      clear
  done;
};

main
exit 98;

ASS
#ViewBridgeAuxiliary
#sociallayerd
  ######################################################################################################################
