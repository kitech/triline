#!/bin/sh

# 计算浏览器（webkit/blink)多进程占用的内存

proc_name="vivaldi-bin"  # "chromium"
if [ x"$1" != x"" ]; then
    proc_name="$1"
fi

pstxt=`ps aux|awk '{print $2,$6,$11}'|grep "$proc_name"|grep -v grep`
SUM=0
MAX=0
MIN=0
CNT=0

function calcbyps()
{
    for N in `echo -e "$pstxt" | awk '{print $2}'` ; do
        SUM=`expr $SUM + $N`
        CNT=`expr $CNT + 1`
        if [ $N -gt $MAX ] || [ $MAX -eq 0 ] ; then
            MAX=$N
        fi
        if [ $N -lt $MIN ] || [ $MIN -eq 0 ] ; then
            MIN=$N
        fi
        echo "$CNT $N"
    done

    if [ $CNT -eq 0 ];then
        AVG=0
    else
        AVG=`expr $SUM / $CNT`
    fi
}

# need sudo or root
function calcbypmap()
{
    for line in `echo -e "$pstxt" | awk '{print $1"," $2"," $3}'` ; do
        # echo "$line"
        pid=$(echo "$line" | awk -F, '{print $1}')
        pss=$(sudo pmap -d $pid | tail -n 1 | awk '{print $4}' | awk -FK '{print $1}')
        # echo "pid=$pid, pss=$pss K"
        # continue
        N=$pss
        SUM=`expr $SUM + $N`
        CNT=`expr $CNT + 1`
        if [ $N -gt $MAX ] || [ $MAX -eq 0 ] ; then
            MAX=$N
        fi
        if [ $N -lt $MIN ] || [ $MIN -eq 0 ] ; then
            MIN=$N
        fi
        # echo "$CNT $N"
    done

    if [ $CNT -eq 0 ];then
        AVG=0
    else
        AVG=`expr $SUM / $CNT`
    fi
}

# 这个好像最准确
# need sudo or root
function calcbysmem()
{
    for line in `sudo smem|grep "$proc_name"|grep -v grep|awk '{print $1","$2","$3","$4","$5","$6","$7}'`; do
        # echo "$line 111"
        pid=$(echo "$line" | awk -F, '{print $1}')
        pss=$(echo "$line" | awk -F, '{print $6}')
        # echo "pid=$pid, pss=$pss K"
        # continue
        N=$pss
        SUM=`expr $SUM + $N`
        CNT=`expr $CNT + 1`
        if [ $N -gt $MAX ] || [ $MAX -eq 0 ] ; then
            MAX=$N
        fi
        if [ $N -lt $MIN ] || [ $MIN -eq 0 ] ; then
            MIN=$N
        fi
        # echo "$CNT $N"
    done

    if [ $CNT -eq 0 ];then
        AVG=0
    else
        AVG=`expr $SUM / $CNT`
    fi
}

# calcbyps;
# calcbypmap;
calcbysmem;

echo "pmemtop for $proc_name: (RSS/PSS KB)"
echo "CNT: $CNT, SUM: $SUM,  AVG: $AVG, MAX: $MAX, MIN: $MIN"
# This is the amount of shared memory plus unshared memory used by each process.
# so it's not correct
# see smem command, USS, PSS
# pmap calc

