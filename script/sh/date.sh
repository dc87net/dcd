#!/usr/bin/env bash

## Get the current unix timestamp, and copy it to the clipboard

date "+%s" | tee /dev/tty | pbcopy

