#!/bin/bash

export app1='TextEdit'
export app="/System/Applications/$app1.app/Contents/MacOS/$app1"
export appbase="/System/Applications/$app1.app"
export dest='/Users/douglas/Desktop'

echo -e "Copy: <$appbase> to <$dest>"
cp -r "$appbase" "$dest" || exit 5

echo -e "Set ownership ..."
chown -R douglas "$dest/$app1" || exit 1


echo -e "pre-removal of signature ..."
codesign -d -v "$dest/$app1" || exit 2

echo -e "removing signature ..."
sudo codesign --remove-signature "$dest/$app1" || exit 3

echo -e "post-removal of signature ..."
codesign -d -v "$dest/$app1" || exit 4

env | bash -c '( "$dest/$app1" )'