#!/bin/bash

# github-release -v upload -s xxx  -u qtchina -r testpkgsz -t 111 -n qrcode--.jpg -R -f /archrepo/packages/crossover-16.2.0-2-x86_64.pkg.tar.xz

sup=$1
if [ x"$sup" != x"" ];then
    if [ -f "$sup" ]; then
        bname=$(basename $sup)
        sz=$(ls -l "$sup" | awk '{print $5}')
        echo "upload supply... $sz, $sup"
        github-release upload -s "$GITHUB_TOKEN"  -u qtchina -r testpkgsz -t 111 -n "$bname" -R -f "$sup"
    else
        echo "not a file: $sup"
    fi
    exit 0
fi

REPODIR=/archrepo/packages

#set -x
cd $REPODIR

for f in `ls`; do
    if [ -f $f ]; then
        #md5sum=$(md5sum "$f" | awk '{print $1}')
        # echo "$f"
        sz=$(ls -l "$f" | awk '{print $5}')
        #echo $sz
        res=$(expr "$sz" \> "50000000")
        #echo $res
        if [ x"$res" == x"1" ]; then
            echo "big file, upload... $sz, $f"
            github-release upload -s "$GITHUB_TOKEN"  -u qtchina -r testpkgsz -t 111 -n "$f" -R -f "$f"
        fi
    else
        echo "not file"
    fi
done

