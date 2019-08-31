#!/bin/sh

# hook.sh <GID> <FILE COUNt> <PATH PATH>

gid=$1
fcnt=$2
fpath=$3

echo "ALL ARGS: $@"

if [[ ! -d $HOME/TDDOWNLOAD ]]; then
    exit 0
fi

fname=$(basename "$fpath")
cp -v "$fpath" "$HOME/TDDOWNLOAD/$fname"
ret=$?
if [[ $ret == 0 ]]; then
    rm -fv "$fpath"
    rm -fv "$fpath.aria2"
fi

