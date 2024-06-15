#!/usr/bin/env python3
# coding=utf-8
# Copyright 2021 -- DC87 Solutions.
## Gets the SSL/TLS certificate(s) for a specified remote host.

import os
import sys
# import math

import colors
from colors import log

def genHeader(text):
    mainLine_text = f" {colors.RED}CERT INFO FOR {colors.BMAGENTA} {text}{colors.NC} "
    length_mL_text = len(mainLine_text)
    length = 80
    equalLine = "=" * length
    print(f"{colors.BLUE}{equalLine}{colors.NC}")

    mainLine = ""
    left = (length - length_mL_text) // 2
    mainLine = f"{colors.BBLUE}" + '*' * left + f"{mainLine_text}" + '*' * left + f"{colors.NC}"

    print(f"{mainLine}")
    print(f"{colors.BLUE}{equalLine}{colors.NC}")

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