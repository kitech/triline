#!/bin/sh

# Usage: exe [secs] comand
#   secs must 1+
# fix supervisor not restart wait

DFTWAIT=5 # seconds
USEWAIT=$DFTWAIT

# check arg1 num
numre='^[0-9]+$'
if ! [[ $1 =~ $numre ]] ; then
    #echo "error: Not a number, $1"
    true
else
    USEWAIT=$1
    shift
fi

btime=$(date)
# exec "$@"
$@

# oh, after exec code will not run
etime=$(date)
echo "cmd exited, waiting $USEWAIT ..."
sleep $USEWAIT

