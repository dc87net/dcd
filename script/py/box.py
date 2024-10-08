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

    print(f"{outStr}\t{len(outStr)}")
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

    print(f"{outStr}\t{len(outStr)}")
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

    print(f"{outStr}\t{len(outStr)}")
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

def main(argv):
    offsetLeftLine(argv[1], '┄', 65, 4)
    pass

if __name__ == "__main__":
    if (len(sys.argv) <= 0):
        print(f"{colors.BRED}Required{colors.NC}: message")
        exit(-1)
    main(sys.argv)
    exit(0)
    pass


print('Why are we here?!');