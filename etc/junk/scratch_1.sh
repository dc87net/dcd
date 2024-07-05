#!/bin/bash
eval "$(dcd colors get)"
#set -x

#alias cdrp='eval cd \"$(realpath .)\"'
#YWxpYXMgY2RycD0nZXZhbCBjZCBcIiQocmVhbHBhdGggLilcIic=

# BLANK PAD
export CMD='bash'; "$(which "$CMD")" 2>&1 /dev/null && cat - >/dev/stderr || { log "${BRED}Error${NC}: ${RED}Not found: ${YELLOW}$CMD${NC}"; }

exit 0;


## OpenAI:
xargs pip3 install --break-system-packages --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org <<< "openai"

## https://dash.cloudflare.com/profile/api-tokens
## 🚨 https://dc87net.nyc3.digitaloceanspaces.com/pub/tld/Cloudflare_WARP_2024.5.287.1.pkg

## Custom watch
#╰─ eval "$(dcd colors get)" ; while [[ "1" ]]; \
#  do log "${CYAN}$(date)${NC}" ; echo "$(sudo lsof +D "$@" |& tee /dev/null | grep -v lsof|grep -v tee| grep -v grep; sleep 0.2)"; done
# -- AS --
#    #!/usr/bin/env zsh
#    eval "$(dcd colors get)"
#    # Directory to monitor
#    dir="${1:-/}"
#    ## Validate directory (optional)  ## [[ -d "$dir" ]] || { echo "Invalid directory: $dir"; exit 1; }
#    while :; do # Monitor directory
#      log "${CYAN}$(date)${NC}"
#      sudo lsof +D "$dir" |& grep -v -E "lsof|tee|grep" || true
#      sleep 0.2
#    done
######

#
#def centerLine2(text=' SECTIN ', pad='-', lineWidth=80):
#    lText   = len(text)      # The text of the line.
#    lPad    = len(pad)       # Length of the  input text.
#    lTWidth = lineWidth      # Length of entire line
#
#    ## Calculations
#    res1   = int((lTWidth - lPad - lText+0.5) / 2)
#    mod1   = (lTWidth-lPad-lText) % 2
#
#    lRes2a = res1
#    lRes2b = lRes2a + mod1
#    if (mod1 == 1):
#        # print('true')
#        lRes2b = lRes2b + 1 + mod1
#        if (lRes2a < lRes2b):
#            lRes2b+=-1
#    else:
#        # print('false')
#        lRes2b = lRes2a + 1 + mod1
#
#    # print(f"lRes2a<{lRes2a}>  lRes2b<{lRes2b}>")
#    outStr =               \
#    f"{pad}"* int(lRes2a) +\
#    f"{text}"             +\
#    f"{pad}"* int(lRes2b)
#
#    print(f"\nlen: {len(outStr)}")
#
#    print(f"{outStr}")
#    return 0


#-###################################################
cat << eof
      .,cdxxxoc,.               .:kKMMMNWMMMNk:.
    cKMMN0OOOKWMMXo. ;        ;0MWk:.      .:OMMk.
  ;WMK;.       .lKMMNM,     :NMK,             .OMW;
 cMW;            'WMMMN   ,XMK,                 oMM'
.MMc               ..;l. xMN:                    KM0
'MM.                   'NMO                      oMM
.MM,                 .kMMl                       xMN
 KM0               .kMM0. .dl:,..               .WMd
 .XM0.           ,OMMK,    OMMMK.              .XMK
   oWMO:.    .;xNMMk,       NNNMKl.          .xWMx
     :ONMMNXMMMKx;          .  ,xNMWKkxllox0NMWk,
         .....                    .:dOOXXKOxl,
 eof
 #-###################################################