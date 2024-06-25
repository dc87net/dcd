#!/bin/zsh
## File: real.sh
## Sends to stderr {the *path* of the argument}, if it exits, and returns 0;
## Otherwise, returns 1 (abnormal exit status).

# We the coders, in order to form a more perfect script,
# establish this command-checking script, ensure functionality,
# provide for the common codebase, promote the general usability,
# and secure the blessings of shell scripting to ourselves and our posterity,
# do ordain and establish this example for the Shell of ZSH.

(command -v "$*" 2> /dev/null) >/dev/stderr || exit 1