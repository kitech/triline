#!/bin/sh


KDE_VER=4.14.3
KDE_VER=14.12.0
#KDE_VER=4.10.95
LAST_VER=`echo "$KDE_VER" | awk -F. '{print $3}'`

STABLE_DIR=
if [ $LAST_VER -ge 50 ] ; then
    # echo "unstable version detected.";
    STABLE_DIR="unstable"
else
    # echo "stable version detected.";
    STABLE_DIR="stable"
fi

KDE_SRC_LIST_URI=ftp://ftp.kde.org/pub/kde/${STABLE_DIR}/${KDE_VER}/src/
#KDE_SRC_LIST_URI2=http://mirror.bjtu.edu.cn/kde/${STABLE_DIR}/${KDE_VER}/src/
KDE_SRC_LIST_URI2=http://mirror.bjtu.edu.cn/kde/${STABLE_DIR}/${KDE_VER}/src/
KDE_SRC_LIST_URI3=http://mirrors.ustc.edu.cn/kde/${STABLE_DIR}/${KDE_VER}/src/
#KDE_SRC_LIST_URI3=http://ixion.pld-linux.org/~arekm/kde/
KDE_SRC_LIST_URI2=$KDE_SRC_LIST_URI2
KDE_LIST_FNAME=kde-${KDE_VER}-list.html

echo "Fetcing list from ${KDE_SRC_LIST_URI} ..., to ${KDE_LIST_FNAME}..."
wget ${KDE_SRC_LIST_URI} -O ${KDE_LIST_FNAME}

pname=
puri=
psize=

mkdir -pv kdesrc
pidx=0
while read pline
do
    echo $pline
    is_pline=`echo $pline | grep -E '.(bz2|xz)'`
    # echo $is_pline
    if [ x"$is_pline" = x"" ] ; then
        echo "omited line.";
    else
        true
        pname=`echo $pline|awk '{print $7}'|awk -F'>' '{print $2}' | awk -F'<' '{print $1}' `
        puri=`echo $pline|awk '{print $7}'|awk -F'"' '{print $2}' `
        psize=`echo $pline|awk '{print $8}' | awk -F'(' '{print $2}' `
        # echo "pkg name is: $psize";
        pidx=`expr $pidx + 1`
        echo "Feting [$pidx] $pname ($psize) ...";
        # aria2c -x 2 -k 1M -d ./kdesrc/ $puri
        set -x
        aria2c -c -x 5 -k 1M -d ./kdesrc/ $KDE_SRC_LIST_URI2/$pname
        set +x
    fi
done < ${KDE_LIST_FNAME}

cat ${KDE_LIST_FNAME}

aria2c -c -x 5 -k 1M -d ./kdesrc/  $KDE_SRC_LIST_URI2/kde-l10n/kde-l10n-zh_CN-$KDE_VER.tar.xz
aria2c -c -x 5 -k 1M -d ./kdesrc/  $KDE_SRC_LIST_URI2/kde-l10n/kde-l10n-zh_TW-$KDE_VER.tar.xz
