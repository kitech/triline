#!/bin/sh

# usage:
# vdmnt.sh <m|u|r>

vdi_disk_path=/mnt/sda6/vms/datastore.vdi
qcow2_disk_path=/mnt/sda6/vms/datastore.qcow2

set -x
function vdfuse_mount()
{
    vdfuse -v -w -a -f /mnt/sda6/vms/datastore.vdi /mnt/vdfuse/
    ntfs-3g -o ro /mnt/vdfuse/Partition1 /mnt/vsd1
}

function vdfuse_umount()
{
    sudo umount /mnt/vsd1
    ret=$?
    if [ x"$ret" != x"0" ] ; then
        echo "umount error: $ret";
        exit;
    fi

    sleep 1;
    sudo umount /mnt/vdfuse
}


function vdfuse_remount()
{
    sudo umount /mnt/vsd1
    ret=$?
    if [ x"$ret" != x"0" ] ; then
        echo "umount error: $ret";
        exit;
    fi

    sleep 1;
    ntfs-3g -o ro /mnt/vdfuse/Partition1 /mnt/vsd1
    # ls -lh -colors /mnt/vsd1/ | head -n 5
    echo -e "________________________________________________________";
    tree -L 2  /mnt/vsd1/
}


if [ x"$1" == x"m" ] ; then
    vdfuse_mount;
elif [ x"$1" == x"u" ] ; then
    vdfuse_umount;
elif [ x"$1" == x"r" ] ; then
    vdfuse_remount;
else
    echo "vdmnt.sh <m|u|r>";
fi




