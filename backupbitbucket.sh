#!/bin/sh

projs="
    admin.news.house
    admin.photo.house
    admtools
    android-mplayer2
    asae
    clearloc
    css_parser
    ftsearch
    gearman-go
    gearmanmanager
    golib
    iamplayer
    karia2
    kitphone
    lightphone
    msnbot
    newbbs.house
    news.house
    nullfxp
    nullget
    phash
    photo.house
    ppshare
    qalife
    qffmpeg
    sina.leju.framework
    sina.leju.works
    sky-asterisk
    skypepopad
    slae.house
    snsnotify
    soserver
    tomtiny
    wcached
    work.docs
";

set -x;
for p in $projs ; do
    echo "proj: $p";
    git_url="git@bitbucket.org:drswinghead/$p.git";
    bname="$p.git";
    if [ ! -d $bname ] ; then
        git clone --bare $git_url $bname;
    else
        cd $bname && git fetch --all
        cd -;
    fi

    tar jcvfp $bname.tar.gz $bname;
done



