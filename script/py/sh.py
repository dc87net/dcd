#!/usr/bin/env python3
## Allows User to write shell (bash) code into a file-like object and run the same in-place at the Terminal.

import subprocess
import sys

# Custom imports
import colors
# log = f"{colors.BYELLOW}==>{colors.NC} {colors.BBLUE}"

def main():
    colors.log(f"{colors.BCYAN}bash{colors.CYAN} - [{colors.RED}Ctrl+D{colors.CYAN} to run{colors.CYAN}]{colors.BCYAN}"
        f"  >>>{colors.NC} ")

    # Capture the input Bash code from the user
    input_code = sys.stdin.read()

    try:
        # Execute the captured Bash code using subprocess
        result = subprocess.run(input_code, shell=True, text=True, capture_output=True)

        # Print the output of the executed code
        print(result.stdout)
        if result.stderr:
            print(f"Error: {result.stderr}", file=sys.stderr)

    except Exception as e:
        print(f"An error occurred: {e}", file=sys.stderr)

if __name__ == "__main__":
    main()