#!/bin/sh

### Usage:
# alias git=$HOME/myscripts/egit.sh
#
# git config --get custom.private
# git config --set custom.private false|true
#

###
# 自动检测git项目路径，动态智能设置提交用户名与邮件
# TODO 支持同步提交到github,bitbucket,oschina,gitcafe
# TODO 其中bitbucket和gitcafe只提交公开项目。
# TODO 把托管分为两个功能，一个是私有项目类型，只提交到bitbucket和oschina
# TODO 另一个公开项目，把项目提交到全部4个托管站点上。
# TODO 使用异步方式，push到向多个repo。

### ChangeLog
# 2015-05-07 支持不同站点间的仓库镜像提交


GIT=/usr/bin/git
subcmd=$1
ARGV=$@
ARGC=$#

function run_with_mine()
{
    echo "Note: run with mine...";

    rdn=$RANDOM # bash builtin variable
    idx=$(expr $RANDOM % 5)

    email=
    if [ x"$idx" == x"4" ] ; then
        email=kitech@users.sf.net
    elif [ x"$idx" == x"3" ] ; then
        email=drswinghead@gmail.com
    elif [ x"$idx" == x"2" ] ; then
        email=yatsen3@gmail.com
    elif [ x"$idx" == x"1" ] ; then
        email=drswinghead@163.com
    else
        email=yatseni@163.com
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
    $GIT config --global user.email liuguangzhao@didichuxing.com
    $GIT config --global user.name gzleo
}

function cleanup_with_user()
{
    $GIT config --global --unset user.email
    $GIT config --global --unset user.name
    $GIT config --global --remove-section user
}

function rewrite_args()
{
    true;
}

if [ x"$subcmd" == x"commit" ] || [ x"$subcmd" == x"pull" ] ||  [ x"$subcmd" == x"merge" ] \
       || [ x"$subcmd" == x"rebase" ] || [ x"$subcmd" == x"tag" ] || [ x"$subcmd" == x"subtree" ] ; then
    cleanup_with_user;

    origin=$($GIT remote -v|grep origin|grep push|awk '{print $2}')
    # git repo url
    # echo $origin

    [ x"$origin" == x"" ] && run_with_mine;
    ### fix just local git storage file:///some/path
    a=$(echo $origin | grep "^/home/") && run_with_mine;
    a=$(echo $origin | grep "git.xiaojukeji.com") && run_with_didi;
    a=$(echo $origin | grep "git.leju.com") && run_with_leju;
    a=$(echo $origin | grep "github.com") && run_with_mine;
    a=$(echo $origin | grep "bitbucket.org")  && run_with_mine;
    a=$(echo $origin | grep "gitlab.com")  && run_with_mine;
    a=$(echo $origin | grep "git.oschina.net")  && run_with_mine;
    a=$(echo $origin | grep "kde.org")  && run_with_mine;

    user_name=$($GIT config --global user.name);
    user_email=$($GIT config --global user.email);
    echo "Using author: ${user_name} <${user_email}>...";
    
    # set -x
    # run real git command now.
    $GIT "$@"
    # echo "dryrun... $GIT $@";

    cleanup_with_user;
elif [ x"$subcmd" == x"push" ] ; then
    # 自动镜像提交
    true;

    priv=$(git config --get custom.private)
    echo "is priv: $priv";
    brch=$(git branch)
    echo "cur branch: $brch"
    a3="ffffff"
    echo "$@, $1 $2 $3 $4"
    echo "============"

    # origin push
    $GIT "$@"
    # others push
    for rs in `git remote` ; do
        true;
        echo "process remote: $rs ...";

        if [ x"$priv" == x"true" ] ; then
            true;
            if [ x"$rs" == x"bitbucket" ] || [ x"$rs" == x"oschina" ] ; then
                true;
                newargs=
                for arg in "$@" ; do
                    # echo "argx: $arg";
                    if [ x"$arg" == x"origin" ] ; then
                        arg=$rs
                    fi
                    newargs="$newargs $arg"
                done
                echo "Runing $GIT $newargs"
                $GIT $newargs
            fi
        elif [ x"$priv" == x"false" ] || [ x"$priv" == x"" ] ; then
            true;
            if [ x"$rs" == x"github" ] || [ x"$rs" == x"gitcafe" ] \
                   || [ x"$rs" == x"bitbucket" ] || [ x"$rs" == x"oschina" ] ; then
                newargs=
                for arg in "$@" ; do
                    # echo "argx: $arg";
                    if [ x"$arg" == x"origin" ] ; then
                        arg=$rs
                    fi
                    newargs="$newargs $arg"
                done
                echo "Runing $GIT $newargs"
                $GIT $newargs
                true;
            fi
        else
            echo "check the priv option."
        fi
    done
else
    $GIT "$@"
fi

