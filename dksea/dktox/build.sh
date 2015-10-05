#!/bin/sh

set -x

CPWD=`pwd`

function sync_wxagent()
{
    url='https://kitech@git.oschina.net/kitech/mkuse.git'
    if [ -d lmkuse ] ; then
        cd lmkuse
        git reset --hard HEAD
        git pull
        cd ..
    else
        git clone $url lmkuse
    fi

    pwd
    cp -v $HOME/opensource/mkuse/lwwx/wxagent/*.py lmkuse/lwwx/wxagent/
}

function install_pytox()
{
    BDIR=`pwd`
    #cd /root
    git clone https://github.com/kitech/PyTox.git
    cd PyTox
    git checkout newapi
    git branch
    python setup.py build
    python setup.py install  -O1 --root "$BDIR"

    cd ..
    # cleanup
    rm -rf PyTox
}

function pre_build()
{
    sync_wxagent;
    install_pytox;
    true;
}
pre_build;

# just non-root user
sudo docker build .


