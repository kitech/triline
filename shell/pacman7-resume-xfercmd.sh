#!/bin/sh

# /usr/bin/wget --passive-ftp -c -O %o %u
echo ">>> $@"

dltmpfile=$4
dlurl=$5

fixtmpdir=$(dirname $(dirname $dltmpfile))
fixtmpfile=$fixtmpdir/$(basename $dltmpfile)
if [ x"$fixtmpdir" == x"/var/lib/pacman/sync" ]; then
    exec wget --passive-ftp -c -O "$dltmpfile" "$dlurl"
    exit $?
fi

echo "Hotfix shit tmpdir to $fixtmpfile"

if [ -f "$fixtmpfile" ]; then
    ls -lh "$fixtmpfile"
    cp -va "$fixtmpfile" "$dltmpfile"
fi

set -x
# --limit-rate=123K
wget --passive-ftp --limit-rate=123k -c -O "$dltmpfile" "$dlurl"
dler_exit_code=$?
if [ -f "$dltmpfile" ]; then
    cp -va "$dltmpfile" "$fixtmpfile"
    ls -lh "$fixtmpfile"
fi
if [ x"$dler_exit_code" = x"0" ]; then
    rm -fv "$fixtmpfile"
fi

exit $dler_exit_code
