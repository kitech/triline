#!/bin/sh

set -e
set -x

export LANG=en_US.UTF-8

# REDIS_HOST=ip:port, MYSQL_HOST=ip:port, MYSQL_USER=, MYSQL_PASSWORD=
# 如果没有设置REDIS_HOST，则使用本机的？
# 如果没有设置MYSQL_HOST, 则使用本机的？

function smart_hosts()
{
    if [ ! -f "/etc/hosts.orig" ] ; then
        cp -va /etc/hosts{,.orig}
    fi
    
    echo "" >> /etc/hosts
    if [ "$MYSQL_HOST" ] ; then
        echo "$MYSQL_HOST  gitlab-mysql-n" >> /etc/hosts
    else
        echo "10.97.198.249  gitlab-mysql-n" >> /etc/hosts
    fi

    if [ "$REDIS_HOST" ] ; then
        echo "$REDIS_HOST  gitlab-redis-n" >> /etc/hosts
    else
        echo "10.97.198.249  gitlab-redis-n" >> /etc/hosts
    fi

    # for gitlab-shell api call
    echo "127.0.0.1 git.coc.io" >> /etc/hosts
    
    true;
}

function start_gitlab_redis()
{
    true;
}

function start_gitlab_db()
{
    true;
}

function init_gitlab_db()
{
    dbs=$(mysql -h gitlab-mysql-n -u root -p"coc.123" -e "show databases" -N -s | grep gitlabhq_ | wc -l)
    # echo $dbs
    if [ x"$dbs" == x"0" ] ; then
        cd /home/git/gitlab
        # maybe need except yes
        echo "yes" | sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production GITLAB_ROOT_PASSWORD=yourpassword
        cd -
    fi
    true;
}


### all need this
smart_hosts;

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
    tail -s 1.0 -f /var/log/wxagent.log /var/log/wx2tox.log
    echo "====================........"
    env
    locale
    pwd
    echo "====================........"
    exists_wxagent=$(ps axu | grep wxagent.wxagent | grep -v grep)
    if [ x"$exists_wxagent" == x"" ] ; then
        echo "restart wxagent.........."
        /usr/bin/python -m wxagent.wxagent > /var/log/wxagent.log 2>&1 &
        return
    fi

    exists_wx2tox=$(ps axu | grep wxagent.wx2tox | grep -v grep)
    if [ x"$exists_wx2tox" == x"" ] ; then
        echo "restart wxagent.........."
        /usr/bin/python -m wxagent.wx2tox > /var/log/wx2tox.log 2>&1 &
        return
    fi
}

# TODO need dynamic init database
if [ "$1" = 'dktoxsrv' ]; then
    ######################
    # init_gitlab_db;

    #/usr/bin/ssh-keygen -A
    #/usr/bin/sshd
    #/usr/bin/crond  # -i -n -s
    #/usr/bin/postfix start   # stop|reload
    #/etc/init.d/gitlab restart
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
    echo "$(hostname) started at $(date)"
    # while true; do sleep 9876543210; done;
    while true; do relax_tail_sleep; done;
else
    exec "$@"
fi



