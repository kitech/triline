#!/bin/sh

# such as docker push,
while true; do
    "$@"
    if [ "$?" == "0" ]; then
        break;
    fi
    echo
    sleep 5;
done

