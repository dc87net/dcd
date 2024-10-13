#!/bin/bash

clear

echo -e "Note:"
echo -e "-----"
echo -e "At the Marvell>> prompt, type the following:"
echo -e "\t usb reset"
echo -e "\t run recovery"
echo -e "\nPress enter to continue ..."
read /dev/null

# lauch a sudo `screen` session with Netgate router, using the usb serial tty
eval "sudo screen /dev/$(ls /dev | grep usb | grep tty)" 115200
