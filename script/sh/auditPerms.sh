#!/usr/bin/env zsh

echo "Auditing perms of User folders ...";

yes "will cite" | parallel --citation
#eval "ls -l /Users/" | grep staff | awk '{print $3}' |
echo "Processing users: "
(grep staff | grep d | awk '{print $3}' | tee /dev/tty | sudo parallel 'echo -ne "\t{} ..."; chmod -R og-rw /Users/{} 2> /dev/null; echo done.') <<< "$(ls -l /Users/)"

echo "Finshed audit! ---- "
echo
echo -e "Verify visually:\n"
ls -laOG /Users/ | grep staff
