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


function pre_build()
{
    confirm_local_gitlab;
    sync_gitlab;
}
pre_build;

# because home/git is not readable for gzleo user
sudo docker build .


