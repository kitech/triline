#!/bin/sh

cmd=$1

sxexe="sshpass -p 3.14 ssh -XY -C 10.95.96.86 source ~/env.sh; "
set -x
case $cmd in
    'env')
        $sxexe "env" ;
     ;;
    'xterm')
        $sxexe /usr/bin/xterm ;
        ;;
    'tb')
        $sxexe /usr/bin/thunderbird ;
        ;;
    'ff')
        $sxexe ~/firefox/firefox ;
        ;;
    'gtk3d')
        $sxexe gtk3-demo ;
        ;;
    'test')
        # $sxexe fcitx-diagnose ;
        $sxexe kwrite ;
        ;;
    *)
     ;;
esac

