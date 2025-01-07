#!/usr/bin/env bash
## This script uses `ifconfig` to set some strange adapters present to DOWN



echo -e "════ Network Control  ═════════════════════════════════════════════════════════"
export tf=$(mktemp);
#export tf='';


echo -e "Disabling superfluous network interfaces ...";
{
 cat << "EOF" | xargs -I{} echo {} >> "$tf"
llw0
awdl0
ap1
bridge0
en2
en3
en4
anpi0
stf0
gif0
EOF
};
echo "asdf";
cat "$tf"

echo -e "\t Process completes < $? >";
