#!/bin/sh

# usage: scrcpy.sh <id>

sidxp=$1
sidfld=$(adb devices -l 2>&1 | grep "$sidxp:" | awk '{print $1}')
echo $sidfld
if [[ $sidfld = "" ]]; then
    sidfld=$(adb devices -l 2>&1 | grep "$sidxp" | awk '{print $1}')
    echo $sidfld
    if [[ $sidfld = "" ]]; then
        # mayb ip mode
        sidfld=10.0.0.$sidxp
        echo "try connect $sidfld ..."
        adb connect $sidfld
        scrcpy -s $sidfld -m 800 -b 1m
    else
        echo "usb mode $sidfld ..."
        scrcpy -s $sidfld -m 800 -b 1m
    fi
else
    echo "ip mode $sidfld ..."
    scrcpy -s $sidfld -m 800 -b 1m
fi
