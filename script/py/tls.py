#!/usr/bin/env python3
# coding=utf-8
# Copyright 2021, 2024 -- DC87 Solutions.
## Gets the SSL/TLS certificate(s) for a specified remote host.

import os
import sys
from time import sleep
# import math

import colors
from colors import log

def genHeader(text):
    padChar = '*'
    padCount= 24

    # calculate text for the main line with remote server name
    introText = f"CERT INFO FOR "
    mainLine  = f"{colors.RED}{introText}{colors.BMAGENTA}{text}{colors.NC}"
    mainLine  = f"{colors.BBLUE}{padChar * padCount} {mainLine} {colors.BBLUE}{colors.BBLUE}{padChar * padCount}{colors.NC}"
        # 2 spaces added to mainLine

    # calculate text for the other header lines
    equalLen = (2 * padCount) + (len(introText) + len(text)) + 2  # account for extra spaces in mainLine
    equalLine= f"{'=' * equalLen}"

    # print the header
    print(f"{colors.BLUE}{equalLine}{colors.NC}")
    print(f"{mainLine}")
    print(f"{colors.BLUE}{equalLine}{colors.NC}")

    sleep(0.1)
    return 0

# Press the green button in the gutter to run the script.
def main():
    if len(sys.argv) > 1:
        server = sys.argv[1]
    else:
        server = input(f"{colors.GREEN}Server to probe{colors.NC}: ")

    genHeader(server)
    print("")
    print(f"{colors.YELLOW}"
          f"{os.system('openssl s_client -servername ' + server + ' -connect ' + server + ':443 < /dev/null | openssl x509 -text')}"
          f"{colors.NC}")

if __name__ == "__main__":
    main()

# EOF