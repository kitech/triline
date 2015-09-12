#!/bin/sh

set -x

pwd

# 把这些函数分为需要下载的部分和本地设置的部分。

function install_deps()
{
    # pacman-key --init
    # pacman-key --populate archlinux
    # pacman-key --populate manjaro
    # pacman-key --refresh-keys
    # pacman -Syy
    # pacman -S --noconfirm sudo ruby mariadb-clients nginx git postfix nodejs redis vim cronie openssh
    pacman -S --noconfirm toxcore
    # pacman -Su --noconfirm
    # pacman -U --noconfirm /var/cache/pacman/pkg/*.xz
    # ret=$?
    # if [ x"$ret" != x"0" ] ; then
    #    exit $ret;
    # fi

    # /usr/bin/ssh-keygen -A
    true
}


###

function cleanup_env()
{
    true;
    # pacman -R --no-confirm vim vim-runtime
    # pacman -R --no-confirm sudo gcc
    # rm -f /var/cache/pacman/pkg/*.xz
    find /var/cache/pacman/pkg/ -name "*.xz" | xargs rm -f
    rm -fr /usr/share/doc/postfix/
    find /usr/share/man/ -name "*.gz" | xargs rm -f
}
# cleanup_env;


function install_all()
{
    install_deps;

    # install_extra_post;
    cleanup_env;
}

function make_sslkeys()
{
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -out server.csr -sha256
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

    # openssl req -newkey rsa:2048 -x509 -nodes -days 3560 -out gitlab.crt -keyout gitlab.key
    true;
}

install_all;
echo "Install ndtox done.";

