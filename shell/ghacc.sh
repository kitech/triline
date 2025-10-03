#!/bin/sh

# Usage: exe [index] <git clone ghurl/curl ghurl>
# 识别参数列表中的URL并替换，只支持http协议
# https://gh-proxy.com/https://github.com/...

if [ "${#@}" == "0" ]; then
    echo "Usage: exe [index] <git clone ghurl/curl ghurl>"
    exit
fi

ACCURLS=(https://gh-proxy.com https://gh-proxy.com1 https://gh-proxy.com2)
DFTNO=0
CUSTOM=$DFTNO

# check arg1 num
numre='^[0-9]+$'
if ! [[ $1 =~ $numre ]] ; then
    #echo "error: Not a number, $1"
    true
else
    CUSTOM=$1
    shift
fi
ACCURL=${ACCURLS[$CUSTOM]}
if [ x"$ACCURL" == x"" ]; then
    echo "Invalid index, $CUSTOM NOTIN ${#ACCURLS[@]}"
    exit
fi

targs=()
for ax in $@; do
    #echo "${#@}: $@"
    # shift
    tx="$ax"
    # bash startswith syntax
    if [[ $ax == http* ]]; then
        tx="$ACCURL/$ax"
        #echo "MODED $tx"
    fi
    targs+=($tx)
    #echo "$tx, targs: ${targs[@]}"
done

#echo "cnt: ${#targs[@]}, val: ${targs[@]}"
#echo "args: ${#@}: $@"

set -x
exec "${targs[@]}"


