#!/bin/sh

set -e
set -x

export LANG=en_US.UTF-8

function show_banner()
{
    echo "====================........dktox"
    echo "$(hostname) started at $(date)"
    env
    locale
    pwd
    echo "====================........"
}

function start_pubsvc()
{
    mkdir -p /run/dbus
    /usr/bin/dbus-daemon --system --print-address || true
    /usr/bin/nginx  || true
}
# start_pubsvc;


function relax_tail_sleep()
{
    echo "====================........"
    # waitup for every 3 secs
    /usr/bin/timeout --preserve-status -s TERM 3 tail -f /var/log/wxagent.log /var/log/wx2tox.log || true
    echo "====================........"
    exists_wxagent=$(ps axu | grep wxagent.wxagent | grep -v grep | wc -l)
    if [ x"$exists_wxagent" == x"0" ] ; then
        echo "restart wxagent.........."
        /usr/bin/python3 -m wxagent.wxagent > /var/log/wxagent.log 2>&1 &
        return
    fi

    exists_wx2tox=$(ps axu | grep wxagent.wx2tox | grep -v grep|wc -l)
    if [ x"$exists_wx2tox" == x"0" ] ; then
        echo "restart wxagent.........."
        /usr/bin/python3 -m wxagent.wx2tox > /var/log/wx2tox.log 2>&1 &
        return
    fi
}

######
show_banner;

if [ "$1" = 'dktoxsrv' ]; then
    ######################
    #/usr/bin/ssh-keygen -A
    #/usr/bin/sshd
    #/usr/bin/crond  # -i -n -s
    #/usr/bin/postfix start   # stop|reload
    # /usr/bin/nginx

    start_pubsvc;
    ########
    mkdir -p $HOME/.config
    cd /mkuse/lwwx
    cp -a archlinux/wxagent.conf /etc/dbus-1/system.d/

    /usr/bin/python -m wxagent.wxagent > /var/log/wxagent.log 2>&1 &
    sleep 1
    /usr/bin/python -m wxagent.wx2tox > /var/log/wx2tox.log 2>&1 &

    # looping
    # while true; do sleep 9876543210; done;
    while true; do relax_tail_sleep; done;
else
    exec "$@"
fi


