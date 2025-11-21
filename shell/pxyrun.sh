#!/bin/sh

# Usage: exe [port] comand
# todo socks5???

DFTPORT=8117
CUSTOM=$DFTPORT
cmdexe=$(basename $1)

# check arg1 num
numre='^[0-9]+$'
if [[ $1 =~ $numre ]] ; then
    CUSTOM=$1
    cmdexe=$(basename $2)
    shift
else
    #echo "error: Not a number, $1"
    true
fi
DTPXY=127.0.0.1:$CUSTOM
echo "+ Run cmd via proxy: $DTPXY ${@}"

isgitssh=false
# check git+ssh
if [ $cmdexe == "git" ]; then
    # check ssh mode
    byssh=false
    for arg in "$@"; do
        echo $arg
        if [[ $arg == git@* ]]; then
           byssh=true
           break
        fi
    done
    echo $byssh
    isgitssh=$byssh

    if $byssh; then
        #git config --global http.proxy http://$DTPXY
        #newcmdline="$@ -hhhhh"
        echo $newcmdline
        #ssh $SSHIDENT -o ProxyCommand="$HOME/triline/myscripts/socks5proxywrapper %h %p" "$@"
        # see triline/myscript/socks5proxyssh
        # TODO 还是原来那个问题，无法正确读取域名对应的sshkey了
        set -x
        pxycmd=/tmp/pxycmd.$(id -u).sh
        echo "ssh -v -o ProxyCommand=\"connect -H $DTPXY %h %p \"\$@\"\"" > $pxycmd
        #echo "connect -H $DTPXY \"\$@\"" > $pxycmd

        cat $pxycmd
        chmod +x $pxycmd
        GIT_SSH="$pxycmd" exec "$@"

        # cleanup
        #git config --global http.proxy ""
        true
        exit
    else # git+http
        # git --config http.proxy=http://$DTPXY
        reargs=()
        for arg in "$@"; do
            reargs+=($arg)
            if [[ $arg == clone ]] || [[ $arg == pull ]]; then
                reargs+=("--config" "http.proxy=http://$DTPXY")
            fi
        done
        echo "* ${reargs[@]}"
        exec "${reargs[@]}"
        exit
    fi
fi

# set -x
https_proxy=http://$DTPXY \
http_proxy=http://$DTPXY \
HTTPS_PROXY=http://$DTPXY \
HTTP_PROXY=http://$DTPXY \
exec "$@"
