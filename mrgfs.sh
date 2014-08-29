#!/bin/sh

set -x;


function mrgfs()
{
    ntfs-3g /dev/sda1 /mnt/winc
    ntfs-3g /dev/sda5 /mnt/wind

    losetup -v /dev/loop6 /mnt/winc/btrfs_mrg_part.img
    losetup -v /dev/loop7 /mnt/wind/btrfs_mrg_part.img

    # mkfs.btrfs /dev/loop6 /dev/loop7

    mount /dev/loop6 /mnt/mrgfs

    losetup -a -v
}

function unmrgfs()
{
    umount /mnt/mrgfs
    losetup -v -d /dev/loop7
    losetup -v -d /dev/loop6

    losetup -a -v
}


# unmrgfs;
mrgfs;


