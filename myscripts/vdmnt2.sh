#!/bin/sh

# usage:
# vdmnt.sh <m|u|r>

vdi_disk_path=/mnt/sda6/vms/datastore.vdi
vdi_disk_path="/home/gzleo/VirtualBox VMs/miniwinxp32/NewVirtualDisk1.vdi"
qcow2_disk_path=/mnt/sda6/vms/datastore.qcow2

set -x
function vdfuse_mount()
{
    vdfuse -v -r -a -f "$vdi_disk_path" /mnt/vdfuse/
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

function vdfuse_ismounted()
{
    mted=$(mount|grep "vsd1"|grep -v grep)
    if [ x"$mted" == x"" ] ; then
        return 0
    else
        return 1
    fi
}

function vdfuse_remount()
{
    sudo umount /mnt/vsd1
    ret=$?
    if [ x"$ret" != x"0" ] ; then
        vdfuse_ismounted
        ret2=$?
        echo "chk mounted:$ret2";

        if [ x"$ret2" == x"1" ] ; then
            echo "umount error: $ret";
            exit;            
        fi
    fi

    sleep 1;
    sleep 5;
    ntfs-3g -o ro /mnt/vdfuse/Partition1 /mnt/vsd1

    sleep 3;
    # ls -lh -colors /mnt/vsd1/ | head -n 5
    echo -e "________________________________________________________";
    tree -L 2  /mnt/vsd1/
}

function vdfuse_show()
{
    # ls -lh -colors /mnt/vsd1/ | head -n 5
    echo -e "________________________________________________________";
    tree -L 2  /mnt/vsd1/
}

arg0=$1
if [ x"$1" == x"m" ] ; then
    vdfuse_mount;
elif [ x"$1" == x"u" ] ; then
    vdfuse_umount;
elif [ x"$1" == x"r" ] ; then
    vdfuse_remount;
elif [ x"$1" == x"s" ] ; then
    vdfuse_show;
else
    echo "vdmnt.sh <m|u|r>";
fi




