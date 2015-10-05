#!/bin/sh

#mount -t ext4 /dev/sda1 /mnt/sda1
#mount -o bind /dev /mnt/sda1/dev
#mount -o bind /proc /mnt/sda1/proc

EORL=$1
if [ x"$EORL" = x"" ] ; then
    echo "Setting chroot gentoo env..."
    mount -t ext4 /dev/sda9 /data
    if [ ! -d /data/dev ] ; then
        mkdir /data/dev
    fi
    if [ ! -d /data/proc ] ; then
        mkdir /data/proc
    fi
    if [ ! -d /data/sys ] ; then
        mkdir /data/sys
    fi
    if [ ! -d /data/etc ] ; then
       mkdir /data/etc
    fi
    mount -o bind /dev /data/dev
    mount -o bind /proc /data/proc
    mount -o bind /sys /data/sys
    cp -v /etc/resolv.conf /data/etc/
else
    echo "Clear chroot gentoo evn..."
    umount /data/dev
    umount /data/proc
    umount /data/sys
fi


echo "OK"
