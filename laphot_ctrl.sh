#!/bin/sh

# usage: (start|stop|status|reset)

RTDIR_PREFIX=
PID_FILE=$RTDIR_PREFIX/var/run/laphot.pid
LOG_FILE=$RTDIR_PREFIX/var/log/laphot.log
LAST_SETFREQ_TIME_FILE=$RTDIR_PREFIX/var/tmp/laphot_last_setfreq_time.txt
STOP_FLAG_FILE=$RTDIR_PREFIX/var/tmp/laphot_stop.conf

COOL_HOLL=61000
HOT_HOLL=92000

RT_PID=$$

echo $RT_PID > $PID_FILE || exit 1;
echo "" > $LAST_SETFREQ_TIME_FILE || exit 2;
echo "" > $STOP_FLAG_FILE || exit 3;
echo "I'm ${USER}." | tee  $LOG_FILE || exit 4;

while true
do
    CUR_TIME=$(date)
    echo $CUR_TIME | tee -a $LOG_FILE

    TEMP_INPUT=/sys/devices/virtual/hwmon/hwmon0/temp1_input
    if [ ! -f $TEMP_INPUT ] ; then
        TEMP_INPUT=/sys/devices/virtual/hwmon/hwmon1/temp1_input
    fi
    CUR_TEMP=$(cat $TEMP_INPUT)
    echo $CUR_TEMP | tee -a $LOG_FILE

    if [ $CUR_TEMP -lt $COOL_HOLL ] ; then
        # up
        last_setfreq_time=$(cat $LAST_SETFREQ_TIME_FILE)
        if [ x"$last_setfreq_time" = x"" ] ; then
            echo "Cool state ${CUR_TEMP}, Not need any op" | tee -a $LOG_FILE
            true
        else
            #
            echo "" > $LAST_SETFREQ_TIME_FILE
            # set freq to ondemand
            echo "Set to ondemand mode, go to nice performance mode." | tee -a $LOG_FILE
            cpupower frequency-set --min 800MHz --max 2820MHz | tee -a $LOG_FILE
            cpupower frequency-set --governor ondemand | tee -a $LOG_FILE

            echo "SET ondemangovernor, set max_freq." | tee -a $LOG_FILE
            FREQ_INFO=$(cpupower frequency-info)
            echo $FREQ_INFO | tee -a $LOG_FILE 
            echo "" | tee -a $LOG_FILE
            echo "" | tee -a $LOG_FILE
        fi
    elif [ $CUR_TEMP -gt $HOT_HOLL ] ; then
        last_setfreq_time=$(cat $LAST_SETFREQ_TIME_FILE)
        if [ x"$last_setfreq_time" = x"" ] ; then
            # down
            echo $CUR_TIME > $LAST_SETFREQ_TIME_FILE
            # set freq to usespace
            # set freq to min_freq

            echo "Set to userspace mode, go to cooler mode." | tee -a $LOG_FILE

            #cpupower frequency-set --governor userspace | tee -a $LOG_FILE
            #cpupower frequency-set --min 800MHz --max 800MHz | tee -a $LOG_FILE
            #cpupower frequency-set --freq 800MHz | tee -a $LOG_FILE

            cpupower frequency-set --min 800MHz --max 1600MHz | tee -a $LOG_FILE
            cpupower frequency-set --governor ondemand | tee -a $LOG_FILE

            echo "SET userspace governor, set min_freq." | tee -a $LOG_FILE
            FREQ_INFO=$(cpupower frequency-info)
            echo $FREQ_INFO | tee -a $LOG_FILE
            echo "" | tee -a $LOG_FILE
            echo "" | tee -a $LOG_FILE
        else
            echo "Already set min freq. continue." | tee -a $LOG_FILE
        fi
    else
        echo "Good nice porformane state: ${CUR_TEMP}, Not need any op." | tee -a $LOG_FILE
        true
    fi

    sleep 2;
done

# cat /etc/rc.local
# if [ x"$USER" = x"root" ] ; then
#     /root/bin/laphot_ctrl.sh > /dev/null &
# elif [ x"$USER" = x"" ] ; then
#     /root/bin/laphot_ctrl.sh > /dev/null &
# else
#     true
# fi
