#!/bin/bash

REV=51480
REV=52990
REV=52995
SVN_BASE=http://svn.enlightenment.org/svn/e/trunk
PROJECTS="e=0.16.999 eina=0.9.9 evas=0.9.9 ecore=0.9.9 embryo=0.9.9 edje=0.9.99 e_dbus=0.5.0 efreet=0.5.0 eet=1.3.9.99"
# PROJECTS="eet=1.3.9.99"

mkdir -pv $HOME/e17
cd $HOME/e17

for PROJ in $PROJECTS; do
    PR_NAME=`echo $PROJ | awk -F"=" '{print $1}'`
    PR_VP=`echo $PROJ | awk -F"=" '{print $2}'`
    PKG_NAME=$PR_NAME-$PR_VP.$REV    
    if [ x"$PR_NAME" = x"e" ] ; then
        PKG_NAME=enlightenment-0.16.999.$REV        
    fi

    rm -rvf $PKG_NAME
    svn export -r $REV $SVN_BASE/$PR_NAME $PKG_NAME
    cd $PKG_NAME
    ./autogen.sh
    cd ..
    tar jcvf ${PKG_NAME}.tar.bz2 $PKG_NAME
    
done

for PROJ in $PROJECTS; do
    PR_NAME=`echo $PROJ | awk -F"=" '{print $1}'`
    PR_VP=`echo $PROJ | awk -F"=" '{print $2}'`
    PKG_NAME=$PR_NAME-$PR_VP.$REV    
    if [ x"$PR_NAME" = x"e" ] ; then
        PKG_NAME=enlightenment-0.16.999.$REV        
    fi

    
done


#