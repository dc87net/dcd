#!/usr/bin/env zsh
## do something line by line

# Check if there is input from a pipe
#if [ -p /dev/stdin ]; then
#    # Read from the pipe (or stdin)
#    input=$(cat)
##    echo "Received input: $input"
#    echo "$input" | xargs -I{} "$* {}"
#    exit 0
#else
#    exit 5
#fi

export cmd="$*";
echo -e "cmd:\t $cmd"

if [ -p /dev/stdin ]; then
  while IFS= read -r path; do
      echo "Processing line: $1"; shift;
      eval "$cmd \"$line\""f
      echo;
  done
  exit 0
fi || exit 10;
