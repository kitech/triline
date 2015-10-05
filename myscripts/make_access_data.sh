#!/bin/bash


###########################

SQUID_LOG_PATH=/root/var/var/log/squid/old_logs
MONTH_LOG_PATH=`ls $SQUID_LOG_PATH`

echo $MONTH_LOG_PATH

for month_name in $MONTH_LOG_PATH
do
    SUB_PATH=$SQUID_LOG_PATH/$month_name/logfile
#    echo $SUB_PATH
    AIM_DIR=`ls $SUB_PATH`
    for tmp_name in $AIM_DIR
    do
	AIM_PATH=$SUB_PATH/$tmp_name
	echo "Enter $AIM_PATH"
	cd $AIM_PATH
	cat * | perl -F' ' -anle '$F[6] = ~m/sid=(\d+)/; print $F[2] . " ". $1' | sort | uniq -c | sort -nr | awk '{print $2 "," $3 "," $1}' >>/home/webstat/cross_stat/access_data.txt
    done
done
