#!/bin/sh


























DESTDIR=/mnt/sda1/usr/portage
if [ ! -d $DESTDIR ] ; then
    DESTDIR=/usr/portage
fi

echo "rsyncing to $DESTDIR ..."

rsync --recursive --links --safe-links --perms --times --force --whole-file \
    --delete --stats --timeout=180 --verbose -al --progress -h \
    gzleo@192.168.1.103:/mnt/sda1/usr/portage/packages $DESTDIR/


# source gentoo box
#  emerge -uDNva --buildpkg=y --keep-going world
#
#  dest gentoo box
#   emerge -uDNva --usepkgonly  world
#
