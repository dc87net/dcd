#!/usr/bin/env zsh
#
eval "$(dcd colors get)"

log "Auditing perms of User folders@ <${BMAGENTA} $USER ${NC} >...";

#
#yes "will cite" | parallel --citation
##eval "ls -l /Users/" | grep staff | awk '{print $3}' |
#echo "Processing users: "
#(cd ~; grep staff | grep d | awk '{print $3}' | tee /dev/tty | sudo parallel 'echo -ne "\t{} ..."; chmod -R og-rw /Users/{} 2> /dev/null; echo done.') <<< "$(ls -l /Users/)"
#
#echo "Finshed audit! ---- "
#echo
#echo -e "Verify visually:\n"
#ls -laOG /Users/ | grep staff

userC="$(who | grep console | awk '{print $1}')" || exit -100;
userH="$HOME";

log "\tFound <${BCYAN} $userC ${NC}> on console.";
[[ "$HOME" ]]&& log "\tHome is found@ <${BMAGENTA} $userH ${NC}>" || exit -101;

{
   pushd "$userH";
   log "Settings perms ...";
   (chmod -v -R og-rw "$userH" 2>/dev/null) >3;

   log "Attempted concluded with Result: <${YELLOW} $? ${NC}>";
   popd;
}

echo;
exit 0;
