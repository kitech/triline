#!/bin/sh

set -e
set -x

export LANG=en_US.UTF-8

function show_banner()
{
    echo "====================........ndtox"
    echo "$(hostname) started at $(date)"
    env
    locale
    pwd
    echo "====================........"
}

function start_pubsvc()
{
    true
}
# start_pubsvc;


function relax_tail_sleep()
{
    echo "====================........"
    # waitup for every 3 secs
    /usr/bin/timeout --preserve-status -s TERM 30 tail -f /tox-bootstrapd.conf || true
    echo "====================........"
    exists_wxagent=$(ps axu | grep tox-bootstrapd | grep -v grep | wc -l)
    if [ x"$exists_wxagent" == x"0" ] ; then
        echo "restart wxagent.........."
        /tox-bootstrapd /tox-bootstrapd.conf
    fi
}

######
show_banner;

if [ "$1" = 'ndtox' ]; then
    ######################

    /tox-bootstrapd /tox-bootstrapd.conf
    # looping
    # while true; do sleep 9876543210; done;
    while true; do relax_tail_sleep; done;
else
    exec "$@"
fi


