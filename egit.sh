#!/bin/sh

### Usage:
# alias git=$HOME/myscripts/egit.sh

GIT=/usr/bin/git
subcmd=$1
ARGV=$@
ARGC=$#

STR_ARGV=""
for arg in "$@" ; do
    STR_ARGV="${STR_ARGV} \"${arg}\""
done
#echo $STR_ARGV
#exit;


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

if [ x"$subcmd" == x"commit" ] ; then
    origin=$($GIT remote -v|grep origin|grep push|awk '{print $2}')
    # git repo url
    # echo $origin
    (echo $origin | grep "git.xiaojukeju.com") && run_with_work;
    (echo $origin | grep "git.leju.com") && run_with_sina;

    (echo $origin | grep "github.com") && run_with_mine;
    (echo $origin | grep "bitbucket.com")  && run_with_mine;
    (echo $origin | grep "git.oschina.net")  && run_with_mine;

    set -x
    # run real git command now.
    # $GIT $STR_ARGV
    $GIT "$@"
else
    $GIT "$@"
fi

