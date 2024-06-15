#!/usr/bin/env python3
## Allows User to write Python code into a file-like object and run the same in-place at the Terminal.

# System imports
import sys
from io import StringIO

# Custom imports
import colors
from colors import log
#log=f"{colors.BYELLOW}==>{colors.NC} {colors.BBLUE}"

def main():
    log(f"{colors.BCYAN}python3{colors.CYAN} - [{colors.RED}Ctrl+D{colors.CYAN} to run{colors.CYAN}]{colors.BCYAN}"
        f"  >>>{colors.NC} ")

    # Capture the input code from the user
    input_code = sys.stdin.read()

    # Create a temporary StringIO object to execute the input code
    output = StringIO()
    sys.stdout = output
    sys.stderr = output

    try:
        # Execute the input code
        log(f"\n{colors.BMAGENTA}Sending to interpreter... {colors.BGREEN}RUN{colors.NC}!")
        exec(input_code)
    except Exception as e:
        print(f"\n{colors.BRED}Error{colors.NC}:{colors.RED} {e}{colors.NC}")

    # Reset stdout and stderr
    sys.stdout = sys.__stdout__
    sys.stderr = sys.__stderr__

    # Print the output of the executed code
    log(f"\n{colors.BMAGENTA}OUTPUT{colors.NC}:")
    print(output.getvalue())

if __name__ == "__main__":
    main()