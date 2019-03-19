#!/bin/sh


echo "The rexec is: $@"
#set -x
pwdfile=/tmp/adbshrpwd
if [[ ! -f $pwdfile ]]; then
    touch $pwdfile
fi

#set -x
adbpwd=$(cat $pwdfile|head -n 1)
iscd=$(echo "$@" | head -c 3)
if [[ $iscd = "cd " ]];then
    echo "cd to `echo $@ | awk '{print $2}'`"
    pwd=`echo $@ | awk '{print $2}'`
    if [[ $(echo $pwd | head -c 1) == "/" ]];then
        true
    elif [[ $pwd == ".." ]];then
        pwd=$(dirname $adbpwd)
    else
        pwd=$adbpwd/$pwd
    fi
    echo $pwd > $pwdfile
    exit
fi

adbpwd=$(cat $pwdfile|head -n 1)
echo "The rpwd is: $adbpwd"

termuxpfx=/data/data/com.termux/files
adb shell su --preserve-environment -s $termuxpfx/usr/bin/bash -c "\"export PATH=$termuxpfx/usr/bin:\$PATH; export LD_LIBRARY_PATH=$termuxpfx/usr/lib; cd $adbpwd; $@\""

