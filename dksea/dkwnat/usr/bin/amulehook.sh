#!/bin/sh

function mvfile()
{
    fdir=$1
    fname=$2
    echo "$fdir $fname"
    if [[ -d $HOME/TDDOWNLOAD ]]; then
        cp -v "$fdir/$fname" "$HOME/TDDOWNLOAD/$fname"
        ret=$?
        if [[ $ret == 0 ]]; then
            rm -fv "$fdir/$fname"
        fi
    fi
}

inotifywait -m $HOME/.aMule/Incoming -e create -e moved_to |
    while read path action file; do
        echo "The file '$file' appeared in directory '$path' via '$action'"
        # do something with the file
        mvfile "$path" "$file"
    done
