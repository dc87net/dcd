#!/usr/bin/env zsh

eval "$(dcd colorgs get)"

# Get a list of users, excluding system users
ulist="$(dscl . -list /Users | grep -v _)" || exit 3;

# Read each line from the user list
while IFS= read -r line; do
  uid=$(dscl . -read /Users/"$line" UniqueID | awk '{print $2}') || exit 2;
  echo -e "${MAGENTA}$uid${NC}\t${CYAN}$line ${NC}"
done <<< "$ulist"

exit 0;
