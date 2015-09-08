#!/bin/sh

set -x

CPWD=`pwd`
GITHOME=/home/git
function confirm_local_gitlab()
{
    cd /home/git/gitlab
    # sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
    # sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production

    cd -
}

function sync_gitlab()
{
    sudo rsync -vap /home/git  ./home/ --exclude="git/repositories/*" --exclude="git/gitlab-satellites/*" --exclude="git/gitlab/log/*.log"
    sudo rm -f ./home/git/gitlab/log/*.log
    sudo chown gzleo.wheel ./home/git/repositories/ -R
    sudo rm -fr ./home/git/repositories/*
    sudo rm -fr ./home/git/gitlab-satellites/*
    sudo chown git.git -R ./home/git/repositories/
    echo "Syncing git installation done.";
    echo "";
}

function sync_wxagent()
{
    url='https://kitech@git.oschina.net/kitech/mkuse.git'
    if [ -d mkuse ] ; then
        cd mkuse
        git pull
        cd ..
    else
        git clone $url
    fi
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
    #confirm_local_gitlab;
    #sync_gitlab;

    sync_wxagent;
    install_pytox;
    true;
}
pre_build;

# because home/git is not readable for gzleo user
sudo docker build .


