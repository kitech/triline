#!/bin/sh
while true; do
    iptables -L|grep "DROP"
    ip6tables -F && iptables -F
    iptables -L|grep "DROP"
    sleep 30
done
