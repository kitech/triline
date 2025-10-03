#!/bin/sh

# Usage: exe [port] comand
# todo socks5???

DFTPORT=8117
CUSTOM=$DFTPORT

# check arg1 num
numre='^[0-9]+$'
if ! [[ $1 =~ $numre ]] ; then
    #echo "error: Not a number, $1"
    true
else
    CUSTOM=$1
    shift
fi


DTPXY=127.0.0.1:$CUSTOM
echo "+ Run cmd via proxy: $DTPXY"
# set -x
https_proxy=http://$DTPXY \
http_proxy=http://$DTPXY \
HTTPS_PROXY=http://$DTPXY \
HTTP_PROXY=http://$DTPXY \
exec "$@"

