#!/bin/sh



### backup dir $HOME/backup/

set -x 
CPWD=`pwd`
bakdir=$HOME/backup

cd $HOME

tar jcvf office_dot_other.tar.bz2 .xinitrc .gitconfig .subversion .ssh .purple .config .Xmodmap bin .Skype .openfetion
md5=`md5sum office_dot_other.tar.bz2`
echo "tar dot other done: $md5"

# tar jcvf office_dot_kde4.tar.bz2 .kde4
md5=`md5sum office_dot_kde4.tar.bz2`
echo "tar .kde4 done: $md5"

#tar jcvf office_dot_opera_next.tar.bz2 .opera-next --exclude=cache/* --exclude=opcache/* --exclude=icons/* --exclude=thumbnails/*
md5=`md5sum office_dot_opera_next.tar.bz2`
echo "tar .opera-next done: $md5"

# sudo tar jcvf office_var_lib.tar.bz2 /var/lib /etc
md5=`md5sum office_var_lib.tar.bz2`
echo "tar /var/lib done: $md5"

cd $CPWD
