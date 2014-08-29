#!/bin/sh
#
# 

set -x

nip=10.207.27.117
nip=$(ip addr|grep 10.207|awk '{print $2}'|awk -F/ '{print $1}');


function init_dirs()
{
    mkdir -p secsrv/logs
}
init_dirs;

function start_dnscrypt()
{
    /usr/bin/dnscrypt-proxy  --local-address=${nip}:53535 \
        --resolver-address=208.67.220.220:443  \
        --provider-name=2.dnscrypt-cert.opendns.com \
        --provider-key=B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79 \
        --user=nobody --loglevel=9  \
        > secsrv/logs/dnscrypt.log 2>&1 \
        &
    # exit;
}

function stop_dnscrypt()
{
    killall -9 dnscrypt-proxy
}

function start_dnsmasq()
{
    /usr/bin/dnsmasq -d -k --enable-dbus --user=dnsmasq --pid-file \
        --listen-address=$nip --bind-interfaces \
        --log-queries --no-hosts --no-resolv \
        --conf-file=secsrv/dnsmasq.conf  \
        --server=${nip}#53535     \
        > secsrv/logs/dnsmasq.log 2>&1 \
        &
}

function stop_dnsmasq()
{
    killall -9 dnsmasq
}

function start_kdns()
{
    ../opensource/toxsh/kdns/kdns \
        > secsrv/logs/kdns.log 2>&1 \
        &
}

function stop_kdns()
{
    killall -9 kdns
}


cmd=$1
if [ x"$cmd" = x"" ] ; then
    echo "./secsrv.sh <start|stop|status|restart>"
    exit;
fi

case $cmd in
    start)
        start_dnscrypt;
        start_dnsmasq;
        start_kdns;
        ;;
    stop)
        stop_dnsmasq;
        stop_dnscrypt;
        stop_kdns;
        ;;
    restart)
        stop_kdns;
        stop_dnsmasq;
        stop_dnscrypt;
        
        start_dnscrypt;
        start_dnsmasq;
        start_kdns;
        ;;
    status)
        ps axu|grep dnscrypt
        ps axu|grep dnsmasq
        ps axu|grep kdns
        ;;
    *)
        echo "unknown cmd: ${cmd}"
        ;;
esac

# readme
# dnscrypt:ip:53535 <== dnsmasq:*:5353 <== kdns:*:53
