#!/usr/bin/env zsh
# Future use: 1) [in prog] parse arguments (b64 encoded)
#             2)  various system commands; currently, disable gatekeepr

eval "$(dcd colors get)"

export cmd='';
export args='';

[[ "$1" ]]&&{
  cmd="$1"; shift;
  args="$*";
  log "${MAGENTA}CMD${NC}: < ${YELLOW}"$cmd"${NC} >";
  [[ "$args" ]]&&{
    log "${MAGENTA}ARGS${NC}: < ${YELLOW}"$args"${NC} >";
    args=$(
     base64 -d "$args" 2>/dev/null || echo "$args";
    )&&{
        log "Error: args: b64 conversion error\n\t<${BRED} "$args" ${NC}>";
        exit $?;
    };
  }||{ log "Error: args: void"; exit 99; }
}||{ echo "Error: cmd: void"; exit 99; }


sudo spctl --master-disable   # disable Gatekeeper
