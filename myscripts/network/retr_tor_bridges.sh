#!/bin/sh

# retr_tor_bridges.sh --- 
# 
# Author: liuguangzhao
# Copyright (C) 2007-2010 liuguangzhao@users.sf.net
# URL: 
# Created: 2010-03-18 11:36:34 +0800
# Version: $Id: retr_tor_bridges.sh 454 2010-03-18 03:38:27Z drswinghead $
# 

#############
##
####################

MY_NAME=`basename $0`
MY_PID=$$
pid_file=/tmp/retr_tor_bridges.pid
if [ -f $pid_file ] ; then
    echo "maybe exists, checking in depth";
    LAST_PID=`cat $pid_file`
    HAS_PROC=`ps ax | grep $MY_NAME | grep $LAST_PID | grep -v grep`
    echo $HAS_PROC
    if [ x"$HAS_PROC" = x"" ] ; then
        echo "maybe mixed, goon";
    else
        echo "process exists, omited";
        exit;
    fi
fi
echo $MY_PID > $pid_file

###########
tor_bridges_dir=/home/gzleo/documents/tor_bridges
export proxy=on
export https_proxy=http://127.0.0.1:8118/
export http_proxy=http://127.0.0.1:8118/
export ftp_proxy=http://127.0.0.1:8118/

#############
function sigint_handler()
{
    echo "sigint";
    rm -vf $pid_file;
    exit;
}

trap sigint_handler SIGINT;

############
while true
do

    GOT_BRIDGES=n
    CURTIME=`date +%Y%m%d%H`
    CURHOUR=`date +%H`
    
    for itor in 00 03 06 09 12 15 18 21 
    do
        if [ x"$CURHOUR" = x"$itor" ] ; then
            echo "OK $CURHOUR"
            if [ -f $tor_bridges_dir/tor_bridge_$CURTIME.txt ] ; then
                break;
            fi
            
            TMPFILE=`tempfile`
            rm -vf $TMPFILE
            
            wget -S https://bridges.torproject.org/ -O $TMPFILE
            
            if [ -f $TMPFILE ] ; then
                cat $TMPFILE | grep "^bridge "|tee $tor_bridges_dir/tor_bridge_$CURTIME.txt
                BRIDGES=`cat $tor_bridges_dir/tor_bridge_$CURTIME.txt`
                if [ x"$BRIDGES" = x"" ] ; then
                    true
                    echo "get no bridges, maybe network blocked";
                    rm -vf $tor_bridges_dir/tor_bridge_$CURTIME.txt
                else
                    GOT_BRIDGES=y
                fi
            else
                echo "Can not retr bridge info."
            fi
            
            rm -vf $TMPFILE
            
            break;
        fi
    done

    ###
    if [ x"$GOT_BRIDGES" = x"y" ] ; then # if can not get new bridges, can not delete any bridges
        tor_bridges_file_count=`ls -l $tor_bridges_dir/|wc -l`
        if [ $tor_bridges_file_count -gt 10 ] ; then
            rm_count=`expr $tor_bridges_file_count - 10`
            rm_files=`ls $tor_bridges_dir/|head -n $rm_count`
            rm -vf $rm_files;
        else 
        # echo "no file deleted"
            true
        fi
    fi
sleep 500
done
exit;

wget -S https://bridges.torproject.org/ -O $TMPFILE

if [ -f $TMPFILE ] ; then
    BRIDGES=`cat $TMPFILE | grep "^bridge "`
    echo $BRIDGES
else
    echo "Can not retr bridge info."
fi

rm -vf $TMPFILE
