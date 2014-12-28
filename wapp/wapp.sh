#!/bin/sh

# usage:
# ln -sv wapp.sh /usr/bin/weixin
# ln -sv wapp.sh /usr/bin/nitro

USER_DATA_DIR_BASE=$HOME/.config/wapp

function init()
{
    mkdir -p $USER_DATA_DIR_BASE    
}

# @param app, web application name
function main()
{
    app=$(basename $0)
    echo "running app: $app"
    APP_DIR="${USER_DATA_DIR_BASE}/${app}";
    # echo $APP_DIR;
    mkdir -p $APP_DIR;
    
    if [ x"$app" == x"nitro" ] ; then
        APP_URL=http://beta.nitrotasks.com/
    elif [ x"$app" == x"weixin" ] ; then
        APP_URL=https://wx.qq.com/
    else
        echo "Unknown app:$app";
        exit 1;
    fi
    
    chromium --user-data-dir=$APP_DIR --app=$APP_URL #--incognito
}

init && main


