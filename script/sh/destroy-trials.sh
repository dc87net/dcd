#!/usr/bin/env  zsh

eval "$(dcd colors get)"

logerr(){
    log "${BRED}Error${YELLOW} -->${RED} ${*}${NC}"
}

#sudo zsh <<< cat - <<<
#    echo -ne "{
#            export target="$(eval echo "~/Library/Trial/Treatments")";
#            chown -R root:wheel "$target"; || { log "Error: " };
#            rm -rf "$target";
#        }";
#    };


### Cool.  Uses herestring to run arbitrary string
##export CMDs='echo one; echo 2'
#
#export CMDs='cat aa | '
#sudo zsh <<< "$(echo -ne "$(eval echo -ne "echo -ne \"{ ${CMDs}; }\"ls l-a;")";)";



 sudo rm -rf /Users//Library/Trial/ && sudo mkdir -p /Users/douglas/Library/Trial/ && sudo chown douglas /Users/douglas/Library/Trial/ && sudo chflags schg /Users/douglas/Library/Trial/
