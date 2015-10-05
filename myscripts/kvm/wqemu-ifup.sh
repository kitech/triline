#!/bin/sh
set -x

switch=br0
WLN=wlan0
WLN=wlp3s0

if [ -n "$1" ];then
    /usr/bin/sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

    /usr/bin/sudo chown gzleo.wheel /dev/net/tun
    # sleep 1s
    /usr/bin/sudo /usr/sbin/tunctl -u `whoami` -t $1
    /usr/bin/sudo /sbin/ip link set $1 up
    sleep 0.5s
    #/usr/bin/sudo /sbin/brctl addif $switch $1
    /usr/bin/sudo ip addr add 192.168.1.201/24 dev $1
    /usr/bin/sudo route add -host 192.168.1.202 dev $1
    
    /usr/bin/sudo /usr/sbin/parprouted -d $WLN $1  &
    exit 0
else
    echo "Error: no interface specified"
    exit 1
fi

#
# sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
# sudo tunctl -t tap0
# sudo ip link set tap0 up
# sudo ip addr add 192.168.1.25/24 dev tap0
# sudo route add -host 192.168.1.30 dev tap0
# sudo parprouted wlan0 tap0
