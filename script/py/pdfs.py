#!/usr/bin/env python3
# Find all pdf documenets in the user-specified directory
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
import sys

from sympy.logic.inference import valid

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

def validatePrompt(sPath=None, sRec=False, sTerms=None):
    if (sTerms == None):
        if (sPath == None):
            sPath = input(f"Search path [cwd]]\n >>>  ")
        print(f"Enter search terms. [One term or string per line] [enter only `˜` (Opt+n) when done]")
        i=-1
        while (True):
            i = i + 1
            sTerms[i]=input(f" >>> ")
            if (sTerms=='˜'):
                break;

        sRec = input(f"Search recursively? [y] >>>  ")

    return sPath, sRec, sTerms


def enumFiles(sPath, sRec):
    # Find all pdf files in the current folder; if sRec, breadth-first search
    filesList = [""]

    ##TODO: logic here

    return filesList

def searchPdfs(files, sTerms):
    ##TODO: Search the pdf for the terms
    results = (None, [None])
    for pdf in files:
        for term in sTerms:
            # search pdfFile for all instances of `term`
            # append to the dictionary `results` [ of form `(term, [locations of term])`
            pass
    return results


def main(sPath, sRec, sTerms):
    sPath, sRec, sTerms = validatePrompt(sPath, sRec, sTerms)
    filesList = enumFiles(sPath, sRec)

    for result in searchPdfs(filesList, sTerms):
        print(result)

    exit(0)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
main(validatePrompt())
print("An internal problem occured."); exit(99) # We shouldn't be able to get here
