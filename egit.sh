#!/bin/sh

### Usage:
# alias git=$HOME/myscripts/egit.sh

GIT=/usr/bin/git
subcmd=$1
ARGV=$@
ARGC=$#

function run_with_mine()
{
    echo "Note: run with mine...";

    rdn=$RANDOM # bash builtin variable
    idx=$(expr $RANDOM % 3)

    email=
    if [ x"$idx" == x"2" ] ; then
        email=liuguangzhao@users.sf.net
    elif [ x"$idx" == x"1" ] ; then
        email=drswinghead@163.com
    else
        email=drswinghead@gmail.com
    fi

    if [ x"$email" == x"" ] ; then
        echo "Empty email.";
        exit;
    fi

    name=$(echo $email|awk -F@ '{print $1}');
    if [ x"$name" == x"" ] ; then
        echo "Empty user.name."
        exit;
    fi

    $GIT config --global user.email $email
    rete=$?
    $GIT config --global user.name $name
    retn=$?

    if [ x"$rete" != x"0" ] || [ x"$retn" != x"0" ] ; then
        echo "git config --global error.";
        exit;
    fi
}

function run_with_leju()
{
    echo "Note: run with leju...";
    $GIT config --global user.email guangzhao1@leju.com
    $GIT config --global user.name gzleo
}

function run_with_didi()
{
    echo "Note: run with didi...";
    $GIT config --global user.email liuguangzhao@diditaxi.com.cn
    $GIT config --global user.name gzleo
}

function cleanup_with_user()
{
    $GIT config --global --unset user.email
    $GIT config --global --unset user.name
    $GIT config --global --remove-section user
}

if [ x"$subcmd" == x"commit" ] ; then
    cleanup_with_user;
    
    origin=$($GIT remote -v|grep origin|grep push|awk '{print $2}')
    # git repo url
    # echo $origin

    [ x"$origin" == x"" ] && run_with_mine;    
    a=$(echo $origin | grep "git.xiaojukeji.com") && run_with_didi;
    a=$(echo $origin | grep "git.leju.com") && run_with_leju;
    a=$(echo $origin | grep "github.com") && run_with_mine;
    a=$(echo $origin | grep "bitbucket.org")  && run_with_mine;
    a=$(echo $origin | grep "git.oschina.net")  && run_with_mine;

    user_name=$($GIT config --global user.name);
    user_email=$($GIT config --global user.email);
    echo "Using author: ${user_name} <${user_email}>...";
    
    # set -x
    # run real git command now.
    $GIT "$@"
    # echo "dryrun... $GIT $@";

    cleanup_with_user;
else
    $GIT "$@"
fi

