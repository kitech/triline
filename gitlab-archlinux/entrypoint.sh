#!/bin/sh

set -e
set -x

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


# TODO need dynamic init database
if [ "$1" = 'gitlab-server' ]; then
    init_gitlab_db;

    /usr/bin/ssh-keygen -A
    /usr/bin/sshd
    /usr/bin/crond  # -i -n -s
    /usr/bin/postfix start   # stop|reload
    /etc/init.d/gitlab restart
    /usr/bin/nginx

    # looping
    echo "$(hostname) started at $(date)"
    while true; do sleep 9876543210; done;
else
    exec "$@"    
fi



