#!/usr/bin/env python3
## Provides some useful string manipulation tools for the CLI

import sys

def find(str1, str2, pos=0):#{
    # using string.find(value, start, end)
    if (str1 == '' or str2==''):
        sys.stderr.write("invalid or missing argument")
        exit(1)
    else:
        return str2.find(str1, pos)
    #}
#}

def findAll(str1, str2, pos=0): # recursive search for a term in a string
    cursor=pos
    while (pos <= len(str2)):
        loc=find(str1, str2, pos)
        if (loc == -1): exit(0)
        pos+=1
        print(loc)
        pos += loc
    #}
#}

def usage():#{
    pass
#}

#"THIS IS THIS IS IT ON IS THIS"
#"01234567890123456789012345678"
#"0         1         2
if __name__ == "__main__":
    usage()
    # test line
    term=sys.argv[1]
    findAll(term, "THIS IS THIS IS IT ON IS THIS", 0)