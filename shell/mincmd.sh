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

# wayland run like Qt/?
function wlrun() {
    QT_QPA_PLATFORM=wayland GDK_BACKEND=wayland CLUTTER_BACKEND=wayland SDL_VIDEODRIVER=wayland WINIT_UNIX_BACKEND=wayland MOZ_ENABLE_WAYLAND=1 "$@"
}

######### network
# usage: pxyrun <cmd>
function pxyrun.f() {
    https_proxy=http://$DTPXY http_proxy=http://$DTPXY \
    HTTPS_PROXY=http://$DTPXY HTTP_PROXY=http://$DTPXY \
    "$@"
}
function pxyrun.f2() {
    https_proxy=http://$DTPXY http_proxy=http://$DTPXY2 \
    HTTPS_PROXY=http://$DTPXY2  HTTP_PROXY=http://$DTPXY2 \
    "$@"
}

#function ipcn.f() { curl "https://ip.cn/index.php?type=1&ip=$@" ;}
function ipcn.f() { curl "https://ip.cn/api/index?type=1&ip=$@" ; echo ; }
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

# for apk install error: INSTALL_FAILED_INSUFFICIENT_STORAGE
# fix_app com.facebook.katana
function fix_app { adb shell "pm uninstall -k ${1}; rm -rf /data/app/${1}-*; su -c 'rm -rf /data/app-lib/${1}-*'";}

function frseup { curl -v -F "c=@$1" "https://fars.ee/"; }
function neimup { curl -v -F "upfile=@$1" "http://127.0.0.1:8066/upload?fmt=plain"; }
# https://g.ioiox.com/https://github.com/user/repo.git
# https://hub.fastgit.org/user/repo.git
function ghpxydl () {
    dlurl=$1
    curl -v "https://g.ioiox.com/$dlurl"
}

function gdbwc.f() {
    exe=$1
    core=$(ls *.*.P*.core|tail -n 1)
    if [[ $core == "" ]]; then
        echo "gdb $exe: no core files"
    else
        gdb $exe $core
    fi
}

# no signal by load .gdbinit
function gdbns.f() {
    exe=$1
    gdb --init-command=$HOME/triline/shell/.gdbinit.nosig $exe
}

# 播放QQ最后一个已缓存的MP4视频
# usage: playqqtv.f [nth]
function playqqtv.f() {
    nth=$1
    if [ -e $nth ] || [ x"$nth" == x"0" ]; then
        nth=1
    fi
    # real: QQLite/drive_c/Program Files/Tencent/QQLite/Users/QQNUM/Video/
    dir=$HOME/Videos/qqvideo
    topfile=$(ls -t $dir/*.mp4|head -n "$nth"|tail -n 1)
    echo "mpv $topfile ... ($nth)"
    #mpv --pause "$topfile"
    mpv --keep-open "$topfile"
}

# check aur git repo is valid
# run in aur repo dir
function aurchk.f()
{
    pkgname=$(basename $(pwd))
    echo "Ifgit: ssh://aur@aur.archlinux.org/$pkgname.git"
    if [ ! -f .SRCINFO ]; then
        echo "Missing .SRCINFO, fix by run 'makepkg --printsrcinfo > .SRCINFO'"
    fi
    echo "Cannot contains subdir(s)"
    echo "How about repo size limit?"
    echo "How about repo file count limit?"
    echo "If maximum blob size (250.00KiB)? 'split -b 200K filename filename."
}

# 调用gdb 并尝试找最新的.core文件
function gdbup.f()
{
    exe=$1
    cores=$(ls -t *.core)
    if [ x"$cores" = x"" ]; then
        gdb "$exe"
    else
        core0=$(echo "$cores"|head -n 1)
        echo "gdb $exe --core $core0"
        gdb "$exe" --core "$core0"
    fi
}

function valgrindvv.f()
{
    echo "valgrind --leak-check=full --show-leak-kinds=all $@"
    valgrind --leak-check=full --show-leak-kinds=all "$@"
    echo "DONE: valgrind --leak-check=full --show-leak-kinds=all $@"
}
