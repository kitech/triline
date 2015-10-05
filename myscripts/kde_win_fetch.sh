#!/bin/sh

# set -x

KDE_VER=4.8.0
KDE_ARCH=win32
BUILD_TYPE=release
ROOT_URI=http://winkde.org/pub/kde/ports/win32/releases/stable/${KDE_VER}/
# ROOT_URI=http://212.219.56.134/sites/ftp.kde.org/pub/kde/stable/${KDE_VER}/win32/
# ROOT_URI=http://ftp.nluug.nl/pub/windowing/kde/stable/${KDE_VER}/win32/
# ROOT_URI=http://ring.u-toyama.ac.jp/archives/X/kde/stable/${KDE_VER}/win32/
# ROOT_URI=http://ftp.ntu.edu.tw/pub/kde/stable/${KDE_VER}/win32/

PKG_STORE_PATH=$HOME/kde_win_archive

mkdir -pv $PKG_STORE_PATH

# wget -c -O $PKG_STORE_PATH/pkg.html $ROOT_URI

PKG_NAMES=`cat $PKG_STORE_PATH/pkg.html | grep href | grep -v mingw4  | grep -v "Parent Directory" | grep -v "C=M;O=A" | awk -F"\"" '{print $8}' | grep -v "src"|grep -v aspell`

function sig_handle
{
    killall -9 aria2c
    echo "Recieve int sig, exit"
    exit
}

trap  sig_handle INT

echo "Parsing pkg urls...";
# sleep 100000
total_seq=1
PKG_NAMES_NEW=
for p in $PKG_NAMES
do
    IS_FETCH=
    IS_DBG=`echo $p | grep dbg | grep -v grep`
    if [ x"$IS_DBG" = x"" ]; then
        IS_LOCALE=`echo $p | grep l10n | grep -v grep`
        if [ x"$IS_LOCALE" = x"" ] ; then
            IS_FETCH=1
        else
            IS_ZHX=`echo $p | grep zh_ | grep -v grep`
            if [ x"$IS_ZHX" = x"" ] ; then
                false;
            else
                IS_FETCH=1
            fi
        fi
    else
        false;
    fi
    
    if [ x"$IS_FETCH" = x"" ] ; then
        false;
    else
        total_seq=`expr $total_seq + 1`
        PKG_NAMES_NEW="$PKG_NAMES_NEW $p"
    fi
done

echo "Got $total_seq pkgs.";

seq=1
for p in $PKG_NAMES_NEW
do
    PKG_URI=$ROOT_URI/$p
    echo "[$seq/$total_seq] Fetching $PKG_URI"
    aria2c -c -x5 -k 1M -d $PKG_STORE_PATH/  $PKG_URI
    seq=`expr $seq + 1`
done



