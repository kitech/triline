#!/bin/sh

# 计算浏览器（webkit/blink)多进程占用的内存

proc_name="vivaldi-bin"  # "chromium"

pstxt=`ps aux|awk '{print $2,$6,$11}'|grep "$proc_name"`
SUM=0
MAX=0
MIN=0
CNT=0
for N in `echo -e "$pstxt" | awk '{print $2}'` ; do
    SUM=`expr $SUM + $N`
    CNT=`expr $CNT + 1`
    if [ $N -gt $MAX ] || [ $MAX -eq 0 ] ; then
        MAX=$N
    fi
    if [ $N -lt $MIN ] || [ $MIN -eq 0 ] ; then
        MIN=$N
    fi
done

AVG=`expr $SUM / $CNT`

echo "memtop for $proc_name: (RSS KB)"
echo "CNT: $CNT, SUM: $SUM,  AVG: $AVG, MAX: $MAX, MIN: $MIN"



