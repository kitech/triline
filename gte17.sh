#!/bin/sh

set -x
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# e17 snap 77927
PKGS="
eeze.77927
e_dbus.77927
"
# PKGS="
# e.72693
# eeze.72008
# e_dbus.71548
# efreet.72387
# edje.72679
# embryo.72112
# ecore.72684
# evas.72604
# eet.72253
# eina.72252
# eio.72607
# emotion.72440
# "

E17SVN=http://svn.enlightenment.org/svn/e/trunk/
E17tmp="e17tmp"
mkdir -pv $E17tmp

for p in $PKGS
do
    echo $p;
    pname=`echo $p | awk -F"." '{print $1}'`
    pver=`echo $p | awk -F"."  '{print $2}'`
    echo $pname $pver;
    if [ -d $E17tmp/${pname}-svn ] ; then
        retry_times=0
        while true
        do
            svn cleanup $E17tmp/${pname}-svn
            svn cleanup $E17tmp/${pname}-svn
            sleep 1
            svn up $E17tmp/${pname}-svn/ -r $pver
            if [ x"$?" = x"0" ] ; then
                echo "svn update ok.";
                break;
            else
                retry_times=`expr $retry_times + 1`
                echo "svn update error, retry ${retry_times} ...";
            fi
        done
    else
        svn co -r $pver $E17SVN/${pname} $E17tmp/${pname}-svn
    fi
    
    ebuild_pname="${pname}-${pver}";
    if [ $pname = "e" ] ; then
        ebuild_pname="enlightenment-0.16.999.${pver}";
    fi
    
    if [ -d $E17tmp/${ebuild_pname} ] ; then
        rm -rf $E17tmp/${ebuild_pname}
    fi

    # svn export $E17tmp/${pname}-svn $E17tmp/${ebuild_pname}
    cp -a $E17tmp/${pname}-svn $E17tmp/${ebuild_pname}

    if [ -d $E17tmp/${ebuild_pname} ] ; then
        cd $E17tmp/${ebuild_pname}
        NOCONFIGURE=1 ./autogen.sh
        find -name .svn | xargs rm -rf
        cd ..
        tar jcvf ${ebuild_pname}.tar.bz2 ${ebuild_pname}
        cp -v ${ebuild_pname}.tar.bz2 /usr/portage/distfiles/
        # top 
        cd ..
    fi

    # for test, one package per time
    # exit;
done
