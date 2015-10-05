#!/bin/sh

#set -x

ADIR=/usr/local/portage/layman/kde/kde-base

cd $ADIR

KWP=`grep "DIST kde-workspace-4.7.80.tar.bz2" * -R|awk -F"/" '{print $1}'`

for p in $KWP
do
    mnf=$p/Manifest
    cat $mnf | grep -v "DIST kde-workspace-4.7.80.tar.bz2"|grep -v grep > /tmp/mnf.txt
    cp -v /tmp/mnf.txt $mnf
    ebuild $p/$p-4.7.80.ebuild digest
done


cd -
