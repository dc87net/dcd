#!/usr/bin/env bash

err="echo $($("echo eval "$(pwd)/$*" | tee /dev/tty") 2> /dev/stdout))"
