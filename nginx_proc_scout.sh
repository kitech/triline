#!/bin/sh
 
# scout the stat server : nginx process 
# when we can not found the process , we restart the server and record this event

SCAN_INTVAL=2M  # 2 minutes

NGINX_SRC_DIR=/home/insenz/sources/nginx-0.5.33
NGINX_RUN_DIR=/home/insenz/nginx0533
NGINX_START_CMD="./update_serv.sh"
NGINX_PID=`ps ax|grep "nginx"|grep "sbin" | awk '{print $1}'`

cd $NGINX_SRC_DIR

VV_TIME=`date +"%Y-%m-%d-%H-%M-%S-%N"`

if [ x"$NGINX_PID" == x"" ] ; then
    echo "nginx process not found. Try start it...... " $VV_TIME
    mv -v $NGINX_RUN_DIR/logs/nginx.error_log $NGINX_RUN_DIR/logs/$VV_TIME.nginx.error_log
    $NGINX_START_CMD
else
    echo $VV_TIME scan done with no error.
fi

