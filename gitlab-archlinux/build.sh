#!/bin/sh

set -x
sudo rsync -vap /home/git  ./home/
echo "Syncing git installation done.";
echo "";

# because home/git is not readable for gzleo user
sudo docker build .


