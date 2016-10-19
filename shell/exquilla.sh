#!/bin/sh

# usage:
#    exquilla.sh <yourname@email> <2016-12-18>


email=$1
date=$2

plain="EX1,${email},${date},356B4B5C"
echo $plain
md5=$(echo -n $plain | md5sum | awk '{print $1}')

echo $md5
lic="EX1,${email},${date},${md5}"
echo $lic

