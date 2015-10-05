#!/bin/sh

echo "`date` $@" >> /tmp/ffaria2.log

xterm -e aria2c -x 5 -k 1M --load-cookies="$1"  "$2"

sleep 5
