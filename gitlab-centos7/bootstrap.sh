#!/bin/sh

set -x

pwd
ls -lh /tmp/buildroot/

# mv -v /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
mv -v /etc/yum.repos.d /etc/yum.repos.d.backup
cp -va /tmp/buildroot/rootfs/etc/yum.repos.d /etc/

YUM_OPTS="-y --disableplugin=fastestmirror"
# yum clean all
# yum makecache

# yum install $YUM_OPTS epel-release  # ius-release
# yum install $YUM_OPTS https://centos7.iuscommunity.org/ius-release.rpm
# yum install $YUM_OPTS /tmp/buildroot/rootfs/rpms/ius-release.rpm

# compile env
yum install $YUM_OPTS gcc autoconf automake make
# yum remove glibc-devel glibc-headers kernel-headers gcc

# deps: ruby, python2.7, mysql-client, nginx, redis, git
yum install $YUM_OPTS mariadb-libs nginx
groupadd -g 997 git
useradd -g 997 -d /home/git -m git

BRSRC=/tmp/buildroot/src
mkdir $BRSRC

cd $BRSRC
wget https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.6.tar.gz

tar xvf ruby-2.1.6.tar.gz
cd ruby-2.1.6
./configure --prefix=/usr/local/ruby
make && make install





