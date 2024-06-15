#!/usr/bin/env python3
## Allows User to write shell (bash) code into a file-like object and run the same in-place at the Terminal.

# System imports
import subprocess
import sys

# Custom imports
import colors
from colors import log
# log = f"{colors.BYELLOW}==>{colors.NC} {colors.BBLUE}"

def main():
    colors.log(f"{colors.BCYAN}bash{colors.CYAN} - [{colors.RED}Ctrl+D{colors.CYAN} to run{colors.CYAN}]{colors.BCYAN}"
        f"  >>>{colors.NC} ")

    # Capture the input Bash code from the user
    input_code = sys.stdin.read()

    try:
        # Execute the captured Bash code using subprocess
        log(f"\n\n{colors.BMAGENTA}Sending to interpreter... {colors.BGREEN}RUN{colors.NC}!")
        log(f"\n{log}OUTPUT{colors.NC}:\n")
        result = subprocess.run(input_code, shell=True, text=True, capture_output=True)

        # Print the output of the executed code
        log(f"\n\n{colors.BMAGENTA}OUTPUT{colors.NC}:")
        print(result.stdout)
        if result.stderr:
            print(f"Error: {result.stderr}", file=sys.stderr)


    except Exception as e:
        log(f"\n{colors.BRED}Error{colors.NC}:{colors.RED} {e}{colors.NC}", file=sys.stderr)
        # print(f"An error occurred: {e}", file=sys.stderr)

if __name__ == "__main__":
    main()