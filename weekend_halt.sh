#!/bin/sh

wday=$(date +"%w")
fday=$(date +"%Y%m%d")
hcfile=/var/local/weeked_halt_$fday.txt
#hcfile=/tmp/weekend_halt.txt

should_halt=no
if [[ $wday == 6 || $wday == 0 ]] ; then
    if [[ ! -f $hcfile ]] ; then
        #should halt
        echo 1 > $hcfile
        echo "real halt for no file";
        should_halt=yes
    else
        mtime=$(stat -c %y $hcfile)
        mdtime=$(echo $mtime | awk '{print $1}')
        ntime=$(date +"%Y-%m-%d")

        if [[ $ntime == $mdtime ]] ; then
            # not halt，当天已经关机一次了
            hcnow=$(cat $hcfile)
            hcnext=$(expr $hcnow + 1)
            echo "not need halt, file $hcnow";
            echo $hcnext > $hcfile
        else
            # should halt
            echo 1 > $hcfile
            echo "really need halt";
            should_halt=yes
        fi
    fi
else
    echo "Not need wday=$wday";
fi

if [[ $should_halt == "yes" ]] ; then
    echo "ready for halting, wait 20 sec" > $hcfile;
    sleep 60;
    shutdown -h now;
	echo "shut result: $? ";
fi
