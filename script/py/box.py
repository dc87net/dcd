#!/usr/bin/env  python3

import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir)))
import colors

# colorsFile=f"{os.path.pardir}/colors.py"
# import
def centerLine(text=' SECTION ', pad='-', lineWidth=80):
    lText = len(text)       # Length of the text
    lTWidth = lineWidth     # Length of the entire line

    # Calculations
    lTPadding = lTWidth - lText
    lLPadding = lTPadding // 2
    lRPadding = lTPadding - lLPadding

    # Create the output string
    outStr = f"{pad * lLPadding}{text}{pad * lRPadding}"

    # print(f"{outStr}\t{len(outStr)}")
    print(f"{outStr}")
    return 0

def offsetLeftLine(text=' SECTIoON ', pad='-', lineWidth=80, offset=5):
    lText = len(text)   # Length of the text
    lTWidth = lineWidth # Length of the entire line

    # Calculations
    lTPadding = lTWidth - lText
    lLPadding = -(offset) + (lTPadding // 2)
    lRPadding = (lTPadding - lLPadding)

    # Create the output string
    outStr = f"{pad * offset}{text}{pad * (lLPadding - offset)}{pad * (lRPadding)}"

    # print(f"{outStr}\t{len(outStr)}")
    return outStr


def offsetRightLine(text=' SECTIoON ', pad='-', lineWidth=80, offset=5):
    lText = len(text)   # Length of the text
    lTWidth = lineWidth # Length of the entire line

    # Calculations
    lTPadding = lTWidth - lText
    lLPadding = -(offset) + (lTPadding // 2)
    lRPadding = (lTPadding - lLPadding)

    # Create the output string
    outStr = f"{pad * (lRPadding)}{pad * (lLPadding - offset)}{text}{pad * offset}"

    # print(f"{outStr}\t{len(outStr)}")
    return outStr

def topBoxLine(text=' BOX ', lineWidth=80, align=1, box=(('╔','║','╙',),
                                                         ('╗' ,'║','╜'),
                                                         ('═','─'))
               , pad=''):
  # lineWidthNew = lineWidth - Σ{(length of edge characters)[R,L]}; as below,
    lineWidthNew = lineWidth - (len(box[1][1]) + len(box[2][1]))

    match (align):
        case 0: pass;   # unassigned
        case 1:         # align left
            textLine = offsetLeftLine(text, pad, lineWidthNew);
            pass
        case 2: pass;   # align right
        case 3:         # align center
            pass;
        case 4: pass;   # unassigned
        # [..]
    pass

    return 0
pass


def stdLine():  ##TODO: future work
    return
pass


def demo():
    # -- Example Usage --
    print(f"CONTROL:")
    centerLine()

    print('')
    offsetLeftLine(' SECTION ', '-', 80)
    offsetLeftLine(' SECTIO ', '-', 80)
    offsetLeftLine(' SECTI ', '-', 80)

    print('')
    offsetRightLine(' SECTION ', '-', 80)
    offsetRightLine(' SECTIO ', '-', 80)
    offsetRightLine(' SECTI ', '-', 80)

    print('')
    centerLine(' SECTI ', '-', 80)
    centerLine(' SECTIO ', '-', 80)
    centerLine(' SECTION ', '-', 80)
    pass

def main(arg1, pad='═', width=80, offset=4):
    print(offsetLeftLine(arg1, pad, width, offset))
    pass

if __name__ == "__main__":
    # print(f"length: {len(sys.argv)}")
    if (not (len(sys.argv) > 1)):
        print(f"{colors.BRED}Required{colors.NC}: text")
        exit(-1)
    if (len(sys.argv)>=4):
        main(f" {sys.argv[1]} ", f"{sys.argv[2]}")
        exit(0)
    if (len(sys.argv)==5):
        main(f" {sys.argv[1]} ", f"{sys.argv[2]}", int(sys.argv[3]))
        exit(0)
    else:
        main(f" {sys.argv[1]} ")
        exit(0)

print(f"Why are we here? {exit(99)}")
