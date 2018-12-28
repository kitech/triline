#!/bin/sh

# inotify 查看目录变化

while true; do
    tail -f /opt/mxe/log/*/* &
    tailpid=$!
    inotifywait -r -e create /opt/mxe/log/
    if [[ $tailpid != "" ]]; then
        kill -9 $tailpid
        tailpid=
        pidof tail
    fi
done

# when stop, need pkill -9 tail
# TODO trap INT

