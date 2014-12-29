#!/bin/sh

# usage:
# ln -sv `readlink -f wapp.sh` /usr/bin/weixin
# ln -sv `readlink -f wapp.sh` /usr/bin/nitro
# ...

USER_DATA_DIR_BASE=$HOME/.config/wapp

function help()
{
    echo "Usage:";
    echo "    First, link to app name:"
    echo "        ln -sv `readlink -f $0` /usr/bin/nitro";
    echo "    Second, run it:"
    echo "        nitro"
}

function init()
{
    mkdir -p $USER_DATA_DIR_BASE    
}

# @param app, web application name
function main()
{
    app=$(basename $0)
    rname=$(basename $(readlink -f $0))
    if [ x"$app" == x"$rname" ] ; then
        help && exit 1;
    fi
    
    echo "running app: $app"
    APP_DIR="${USER_DATA_DIR_BASE}/${app}";
    # echo $APP_DIR;
    mkdir -p $APP_DIR;
    
    if [ x"$app" == x"nitro" ] ; then
        APP_URL=http://beta.nitrotasks.com/
    elif [ x"$app" == x"weixin" ] ; then
        APP_URL=https://wx.qq.com/
    else
        help
        echo "Unknown app:$app";
        exit 1;
    fi

    # clean and mini env
    EXTRA_ARGS="--no-sandbox"
    chromium --user-data-dir=$APP_DIR --app=$APP_URL $EXTRA_ARGS #--incognito
}

init && main

# List of Chromium Command Line Switches
# http://peter.sh/experiments/chromium-command-line-switches/
