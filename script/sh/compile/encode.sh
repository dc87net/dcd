#!/usr/bin/env zsh

# Some globals
export args;
export t1='/Users/Shared/script/script/sh/compile/getLines.sh';
[[ "$1" ]]&&{ t1="$*"; export args=1; }; # temp file for plaintext PRN
export t2="$(mktemp)"; # temp file for encoded text
export t3="$(mktemp)"; # temp file for output


[[ "$1"  ]]||{
  export t1="$(mktemp)";
  export cleanup=0;
  echo "Set to t1 to temp file";
};
echo -e "t1:\t$t1";

source /Users/Shared/script/script/sh/compile/libexec/kill-cycle.sh # Script string

##TODO:[[ "$args" ]] && rm -f "$1";  # remove t1 if created as temp
echo "Encoding ...">/dev/stderr;      # ENCODE
base64 -i "$t1" -o "$t2"; # ENCODE to b64
echo "---">/dev/stderr && cat "$t2" && echo "---">/dev/stderr;  # display the ENCODEed (on stdout) cleanly
base64 -d -i "$t2" -o "$t3" | tee /dev/tty | pbcopy; #show the ENCODEed script on console and COPY to the Pasteboard
echo -e "\t 📋  Copied encoded text to clipboard!!">/dev/stderr;
echo "Decoding ...">/dev/stderr;
cat "$t3">/dev/stderr; # Output the DECODEed script to STDERR for clean output (verification step)


export sn=$(uuidgen);
cp "$t2" "$(pwd)/encoded-$sn.b64"

cat "$t2" | pbcopy # copy the encoded data to the clipboard
echo -ne "\nCleaning up ...\t "$(rm -f "$t1" "$t2" "$t3")"">/dev/stderr;
[[ -f "$t3" ]] && echo "\n⚠️\t failed to delete t3:\t < $t3 >" || echo "\t✅">/dev/stderr;

echo; echo "Run the following command to execute:\n\t zsh <<< \"\$(pbpaste | base64 -d)\"";

eval 'zsh <<< "$(pbpaste | base64 -d)"';
exit $? # fin
