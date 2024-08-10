#!/usr/bin/env zsh










#╰─ export tval='./testA.txt'; (echo 'testing1,2') | tee -a "$(mkdir -p $(dirname $tval/$(basename $tval)))"

#export tval='./testA.txt'; (echo 'testing1,2') | tee -a "$(mkdir -p "$(realpath "$(dirname "${tval}")") /$(basename "$tval")")"


export tval='./testA.txt'; (echo 'testing1,2') | \
  tee -a $(eval "echo $(mkdir -p "$(realpath "$(dirname "${tval}")"/"$(basename \"${tval}\")")")")



export tval='./testA.txt'; echo 'testing1,2' | tee -a "$(mkdir -p "$("$(realpath "$(dirname "${tval}")")" && realpath "${tval}")"

#"$(realpath "$(dirname "${tval}")")/$(basename "$tval")")"



###
############ dirname $(realpath $(dirname "$tval"))
echo "$(realpath "$(dirname "${tval}")")"


export tval='./testA.txt';
echo test123| tee -a "$(mktemp -p "$(dirname "$(realpath "${tval}")")/$(basename "$tval")")"


#####

╭─    /var/folders/n6/kfmnqby12xgfdsmvq3sbkyy40000gp/T/tmp.MCQE41KsR3/testA.txt ▓▒░········································░▒▓ ✔  at 21:35:23  ─╮
╰─ dirname "$(realpath "${tval}")"
                                                                                                                   ─╯
/private/var/folders/n6/kfmnqby12xgfdsmvq3sbkyy40000gp/T/tmp.MCQE41KsR3/testA.txt

╭─    /var/folders/n6/kfmnqby12xgfdsmvq3sbkyy40000gp/T/tmp.MCQE41KsR3/testA.txt ▓▒░········································░▒▓ ✔  at 21:35:33  ─╮
╰─ basename $(realpath $(dirname "${tval}"))                                                                                                          ─╯
testA.txt




realpath "$(dirname "${tval}")"                                                               ─╯
/private/var/folders/n6/kfmnqby12xgfdsmvq3sbkyy40000gp/T/tmp.PlF3L7vOnM