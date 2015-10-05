#!/bin/sh

#http://magnet.vuze.com/magnetLookup?hash=ANRBNFHQ5CZM5BZBNSM4WXFDV4RQFHRX

CDIR=$(dirname $(readlink -f $0));
echo $CDIR;

MAGNAT_URI="$1"
#MAGNAT_URI="magnet:?xt=urn:btih:ebbe0d58ac8aeb32c154c39c45a17bb70e0f443b&dn=%E5%86%B0%E4%B8%8E%E7%81%AB%E4%B9%8B%E6%AD%8C%EF%BC%9A%E6%9D%83%E5%8A%9B%E6%B8%B8%E6%88%8F%28%E7%AC%AC%E4%B8%80%E5%AD%A3%20%E5%85%A810%E9%9B%86%29%EF%BF%A1%E5%9C%A3%E5%9F%8E%E5%BD%92%E6%9D%A5";
infohash=$(echo $MAGNAT_URI | awk -F\& '{print $1}'| awk -F\: '{print $4}');
echo $infohash;
fname=$(echo $MAGNAT_URI | awk -F\= '{print $3}');
echo $fname;
dfname=$(php -r "echo urldecode('${fname}');");
echo $dfname;

SHASH=$(echo -n $infohash | xxd -r -p|$CDIR/perl_32.pl);
echo $SHASH;

BTURL=http://magnet.vuze.com/magnetLookup?hash=$SHASH
echo $BTURL;
BTURL_ZOINK=http://zoink.it/torrent/$infohash.torrent
echo $BTURL_ZOINK;
BTURL_TORCACHE=http://torcache.net/torrent/$infohash.torrent
echo $BTURL_TORCACHE;
str_p1=${infohash:0:2};
str_p2=${infohash:2:2};
str_p3=${infohash:4:2};
echo $str_p1/$str_p2/$str_p3;
BTURL_MAG2TOR=http://mag2tor.com/static/torrents/$str_p1/$str_p2/$str_p3/$infohash.torrent
echo $BTURL_MAG2TOR;
BTURL_210=http://178.73.198.210/torrent/$infohash.torrent
echo $BTURL_210;
BTURL_TORRAGE=http://torrage.com/torrent/$infohash.torrent 

set -x;
while true ; do
    wget -d --timeout=20 -c "$BTURL" -O "${dfname}.torrent";
    ret=$?
    if [ $ret -gt 0 ] ; then
        wget -d --timeout=20 -c "$BTURL_ZOINK" -O "${dfname}.torrent";
        ret=$?
        if [ $ret -gt 0 ] ; then
            wget -d --timeout=20 -c "$BTURL_TORCACHE" -O "${dfname}.torrent";
            ret=$?
            if [ $ret -gt 0 ] ; then
                wget -d --timeout=20 -c "$BTURL_MAG2TOR" -O "${dfname}.torrent";
                ret=$?
                if [ $ret -gt 0 ] ; then                
                    continue;
                fi
            fi
        fi
    fi
    if [ -f "${dfname}.torrent" ] ; then
        break;
    fi
    sleep 1;
done


# http://magnet.vuze.com/magnetLookup?hash=ANRBNFHQ5CZM5BZBNSM4WXFDV4RQFHRX
# http://magnet.vuze.com/magnetLookup?hash=ANRBNFHQ5CZM5BZBNSM4WXFDV4RQFHRX
# http://magnet.vuze.com/magnetLookup?hash=ANRBNFHQ5CZM5BZBNSM4WXFDV4RQFHRX

# http://blog.csdn.net/xxxxxx91116/article/details/7971134
