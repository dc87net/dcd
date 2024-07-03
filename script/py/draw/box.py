#!/usr/bin/env  python3

import os

def centerLine(text=' SECTION ', pad='-', lineWidth=80):
    lText   = len(text)      # The text of the line.
    lPad    = len(pad)       # Length of the  input text.
    lTWidth = lineWidth      # Length of entire line

    ## Calculations
    res1   = int((lTWidth - lPad - lText+0.5) / 2)
    mod1   = (lTWidth-lPad-lText) % 2

    lRes2a = res1
    lRes2b = lRes2a + mod1
    if (mod1 == 1):
        # print('true')
        lRes2b = lRes2b + 1 + mod1
        if (lRes2a < lRes2b):
            lRes2b+=-1
    else:
        # print('false')
        lRes2b = lRes2a + 1 + mod1

    # print(f"lRes2a<{lRes2a}>  lRes2b<{lRes2b}>")
    outStr =               \
    f"{pad}"* int(lRes2a) +\
    f"{text}"             +\
    f"{pad}"* int(lRes2b)

    print(f"\nlen: {len(outStr)}")

    print(f"{outStr}")
    return 0


def stdLine():
    pass

# -- Example Usage --
centerLine('  🌕🌗🌘🌚🌒🌓🌑 ','#',120)
centerLine()