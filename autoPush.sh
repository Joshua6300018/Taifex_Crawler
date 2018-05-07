#!/bin/bash

git add .
git commit -m "daily update"
git push origin master
#/usr/bin/git fetch --depth=1
#/usr/bin/git reflog expire --expire-unreachable=now --all
#/usr/bin/git gc --aggressive --prune=all

#
#
#

#read -p "Press enter to continue"
