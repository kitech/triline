#!/bin/sh

# suffix with .f, response to .sh
# categories: network, os, dev, misc

########## os
# run a X11 command in docker image ub16tinyx
# usage: xdkrun <cmd>
function xdkrun.f() {
    # set -x
    ucmd="$@"
    echo "$ucmd"

    xhost +
    docker run --rm -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ~/.Xauthority:/.Xauthority \
           --env DISPLAY=$DISPLAY --env XAUTHORITY=/.Xauthority ub16tinyx "$ucmd"

    xhost
}

function elegant_halt.f() {
    # acer+xfce+netctl+sddm often can not shutdown/reboot after use several days.
    # run by root: haltful.sh [reboot]
    # default is shutdown

    netctl stop wlp4s0-god
    sleep 3
    systemctl stop sddm
    sleep 3

    a1="$1"
    if [ x"$a1" == x"reboot" ]; then
        reboot
    else
        shutdown -h now
    fi
}

function archmin.f() {
    # 清理arch linux 减小空间使用。
    rm -rf /usr/share/{doc,man,info,perl5}
}

function homecleaner.f() {
    echo "TODO..."
    true;
}

function core-files-delete.f() { rm -fv *P*.core ;}

######### network
# usage: pxyrun <cmd>
function pxyrun.f() {
    export https_proxy=$DTPXY
    export http_proxy=$DTPXY

    "$@"

    unset https_proxy
    unset http_proxy
}

function ipcn.f() { curl "http://ip.cn/index.php?ip=$@" ;}
function geoip.f() { geoiplookup "$@" ;}
# nc port check for localhost
function ncpc.f() { nc -v localhost "$@" ;}
function pingu.f() { while true; do nc -v -u -z -w 3 "$1" "$2"; sleep 2 ; done;}

# current connection's ip
function ccip.f() {
    # 当前的连接ip的地理位置批量查询
    ips=$(ss -ant|grep 33445|grep ESTAB|awk '{print $5}'|awk -F: '{print $1}')
    for ip in $ips; do
        # echo "$ip"
        CTLINE=$(geoiplookup "$ip"|head -n 1|awk '{print $4}')
        echo "$CTLINE $ip"
    done
}

######### dev
function ipowerline.f() {
    kn=$(uname -s)
    . /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
}

### go version select
function gover_help.f() {
    echo "gover <list | select | download | remove | unset>"
    echo "   select <git | x.y.z>"
}

ORIGPATH=
function gover.f() {
    VERDIR=$HOME/govers
    cmd=$1
    arg0=$2
    if [ x"$ORIGPATH" == x"" ] ; then
        ORIGPATH=$PATH
    fi

    case $cmd in
        l|list)
            selected=
            for d in `ls $VERDIR/`; do
                if [ x"$d" == x"go" ]; then
                    echo "selected: $(basename $(realpath $VERDIR/$d))"
                else
                    echo "$d"
                fi
            done
            ;;
        s|select)
                    d=$VERDIR/go-$arg0
                    unlink $VERDIR/go
                    ln -sv go-$arg0 $VERDIR/go
                    export GOROOT=$VERDIR/go
                    export PATH=$VERDIR/go/bin:$PATH
                    ;;
                unset)
                    unset GOROOT
                    export PATH=$ORIGPATH
                    ;;
        *)
            echo 'what?'
            ;;
    esac
}


####### misc
function you-get-p.f() { you-get -p smplayer "$@";}
function otterbrs2.f() { otter-browser --profile $HOME/.config/otter2;}

