#!/usr=/bin/env python3
##

# Color Constants
BLACK   = '\033[0;30m'
BLUE    = '\033[0;34m'
CYAN    = '\033[0;36m'
GREEN   = '\033[0;32m'
MAGENTA = '\033[0;35m'
RED     = '\033[0;31m'
WHITE   = '\033[0;37m'
YELLOW  = '\033[0;33m'

# Bright Colors
BBLACK   = '\033[0;90m'
BBLUE    = '\033[0;94m'
BCYAN    = '\033[0;96m'
BGREEN   = '\033[0;92m'
BMAGENTA = '\033[0;95m'
BRED     = '\033[0;91m'
BWHITE   = '\033[0;97m'
BYELLOW  = '\033[0;93m'

# Text styling
BOLD     = '\033[1m'
UNDERLINE= '\033[4m'
REVERSED = '\033[7m'

# Reset
NC     = '\033[0m'  # No Color
NORMAL = NC         # Reset all styles to normal (equivalent to NC)
'''##################################################################################################################'''


HEAD=f"{BYELLOW}==>{NC} "    # << Prompt header for the log entry (one space included after the prompt)
def log(TEXT=''):                   # << write the User-specified string to the console
    print(f"{HEAD}{TEXT}")


def test():
    # Demonstrating colored output
    print(f"{RED}This is red text{NC}")
    print(f"{GREEN}This is green text{NC}")
    print(f"{BLUE}This is blue text{NC}")
    print(f"{YELLOW}This is yellow text{NC}")
    print(f"{MAGENTA}This is magenta text{NC}")
    print(f"{CYAN}This is cyan text{NC}")
    print(f"{WHITE}This is white text{NC}")

    print(f"{BRED}This is bright red text{NC}")
    print(f"{BGREEN}This is bright green text{NC}")
    print(f"{BBLUE}This is bright blue text{NC}")
    print(f"{BYELLOW}This is bright yellow text{NC}")
    print(f"{BMAGENTA}This is bright magenta text{NC}")
    print(f"{BCYAN}This is bright cyan text{NC}")
    print(f"{BWHITE}This is bright white text{NC}")
    print(f"{BBLACK}This is bright black (gray) text{NC}")

    # Demonstrating colored and styled output
    print(f"{RED}{BOLD}This is bold red text{NORMAL}")
    print(f"{GREEN}{UNDERLINE}This is underlined green text{NORMAL}")
    print(f"{BLUE}{REVERSED}This is reversed blue text{NORMAL}")
    print(f"{YELLOW}{BOLD}{UNDERLINE}This is bold and underlined yellow text{NORMAL}")
    print(f"{MAGENTA}This is magenta text{NORMAL}")
    print(f"{CYAN}This is cyan text{NORMAL}")
    print(f"{WHITE}This is white text{NORMAL}")

    print(f"{BRED}This is bright red text{NORMAL}")
    print(f"{BGREEN}This is bright green text{NORMAL}")
    print(f"{BBLUE}This is bright blue text{NORMAL}")
    print(f"{BYELLOW}This is bright yellow text{NORMAL}")
    print(f"{BMAGENTA}This is bright magenta text{NORMAL}")
    print(f"{BCYAN}This is bright cyan text{NORMAL}")
    print(f"{BWHITE}This is bright white text{NORMAL}")
    print(f"{BBLACK}This is bright black (gray) text{NORMAL}")
    print(f"{REVERSED}This is reversed text{NORMAL}")

if __name__ == "__main__":
    test()