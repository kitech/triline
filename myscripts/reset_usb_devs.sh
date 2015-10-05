#!/bin/bash

set -x
function f2014()
{
    # 2014
    SYSXHCI=/sys/bus/pci/drivers/xhci_hcd
    SYSXHCI=/sys/bus/pci/drivers/snd_hda_intel/

    if [ "$(id -u)" != 0 ] ; then
        echo This must be run as root!
        exit 1
    fi

    if ! cd $SYSXHCI ; then
        echo Weird error. Failed to change directory to $SYSXHCI
        exit 1
    fi

    for dev_id in ????:??:??.? ; do
        #cat unbind  # can not cat, but can echo to
        printf "${dev_id}" > unbind
        #cat unbind
        #cat bind
        printf "${dev_id}" > bind
        #cat bind
    done
}

### funct
function f2013()
{
    # 2013
    SYSEHCI=/sys/bus/pci/drivers/ehci_hcd
    SYSUHCI=/sys/bus/pci/drivers/uhci_hcd

    if [[ $EUID != 0 ]] ; then
        echo This must be run as root!
        exit 1
    fi

    if ! cd $SYSUHCI ; then
        echo Weird error. Failed to change directory to $SYSUHCI
        exit 1
    fi

    for i in ????:??:??.? ; do
        echo -n "$i" > unbind
        echo -n "$i" > bind
    done

    if ! cd $SYSEHCI ; then
        echo Weird error. Failed to change directory to $SYSEHCI
        exit 1
    fi

    for i in ????:??:??.? ; do
        echo -n "$i" > unbind
        echo -n "$i" > bind
    done
}


######## main
f2014;
