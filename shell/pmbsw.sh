#!/bin/sh

# postmarketos bootstrap wrapper

pmexe="pmbootstrap -v -m https://mirrors.tuna.tsinghua.edu.cn/alpine/  -mp https://mirror.math.princeton.edu/pub/postmarketos/"
# pmexe="pmbootstrap -v -m https://mirrors.tuna.tsinghua.edu.cn/alpine/  -mp http://postmarketos.brixit.nl/"
# pmexe="pmbootstrap -v -m https://mirrors.tuna.tsinghua.edu.cn/alpine/  -mp http://postmarketos2.brixit.nl/"
workdir=$HOME/.local/var/pmbootstrap
aportsdir=$workdir/cache_git/pmaports

set -x

pip install --user pmbootstrap

#$pmexe init
#if [[ $? != 0 ]]; then
#    exit
#fi

$pmexe config aports $aportsdir
$pmexe config ccache_size  5G
$pmexe config device  xiaomi-aries
$pmexe config extra_packages  vim,file
$pmexe config hostname ""
$pmexe config jobs  3
$pmexe config kernel  stable
$pmexe config keymap ""
$pmexe config nonfree_firmware  True
$pmexe config nonfree_userland  False
$pmexe config qemu_native_mesa_driver  dri-virtio
$pmexe config ssh_keys  False
$pmexe config timezone  Asia/Chongqing
$pmexe config ui weston # none, hildon, mate, weston, xfce4, plasma-mobile, matchbox, i3wm
$pmexe config user $USER
$pmexe config work $workdir
echo -e "\n\n\n\n\n\n\n\n\n\n" | $pmexe init
[[ $? == 0 ]] || exit

while true; do
    chkerr=0
    $pmexe kconfig check
    if [[ $? != 0 ]]; then
        chkerr=1
    fi
    if [[ $chkerr = 1 ]]; then
        break
        # exit
        # $pmexe kconfig edit linux-xiaomi-aries
        # if [[ $? != 0 ]]; then
        #    exit
        # fi
    else
        break
    fi
done

$pmexe checksum linux-xiaomi-aries
[[ $? == 0 ]] || exit

$pmexe build linux-xiaomi-aries
[[ $? == 0 ]] || exit

$pmexe install --no-fde
[[ $? == 0 ]] || exit

fastboot devices
[[ $? == 0 ]] || exit

# $pmexe flasher flash_rootfs # --partition userdata
# $pmexe flasher boot

# unpackbootimg https://github.com/anestisb/android-unpackbootimg


