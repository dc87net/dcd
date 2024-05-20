#!/bin/bash

# lauch a sudo `screen` session with Netgate router, using the usb serial tty
eval "sudo screen /dev/$(ls /dev | grep usb | grep tty)" 115200

