#!/bin/sh

set -x

pwd
# ls -lh /tmp/buildroot/

# 把这些函数分为需要下载的部分和本地设置的部分。

function install_user()
{
    # deps: ruby, python2.7, mysql-client, nginx, redis, git, openssh, patch, make, gcc
    groupadd -g 997 git
    # useradd -g 997 -d /home/git -m git
    useradd -g 997 -u 997 -d /home/git -m git
    passwd -d git
    id git
    chown git.git -R /home/git
}
# install_user;

# cp -va /tmp/buildroot/rootfs/etc/pacman.d/mirrorlist /etc/pacman.d/

function install_deps()
{
    # pacman-key --init
    # pacman-key --populate archlinux
    # pacman-key --populate manjaro
    # pacman-key --refresh-keys
    pacman -Syy
    pacman -S --noconfirm sudo ruby mariadb-clients nginx git postfix nodejs redis vim cronie openssh
    pacman -Su --noconfirm
    # pacman -U --noconfirm /var/cache/pacman/pkg/*.xz
    ret=$?
    if [ x"$ret" != x"0" ] ; then
        exit $ret;
    fi

    /usr/bin/ssh-keygen -A
}
# install_deps;

###
GITHOME=/home/git
cd /home/git
function install_gitlab()
{
    cd /home/git/gitlab
    sudo -u git -H git checkout -b 7-13-stable
    
    chown -R git log/
    chown -R git tmp/
    chmod -R u+rwX,go-w log/
    chmod -R u+rwX tmp/

    sudo -u git -H mkdir /home/git/gitlab-satellites
    chmod u+rwx,g=rx,o-rwx /home/git/gitlab-satellites
    
    chmod -R u+rwX tmp/pids/
    chmod -R u+rwX tmp/sockets/
    chmod -R u+rwX  public/uploads

    sudo -u git -H git config --global core.autocrlf input

    true;
}
# install_gitlab;

function install_gems()
{
    cd /home/git/gitlab
    gem install bundler --no-ri --no-rdoc
    # bundle config mirror.https://rubygems.org https://ruby.taobao.org
    sudo -u git -H bundle install --deployment --without development test postgres aws kerberos
    true;
}
# install_gems;

function install_gitlab_shell()
{
    cd /home/git/gitlab
    sudo -u git -H bundle exec rake gitlab:shell:install[v2.6.3] REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production
    true;
}
# install_gitlab_shell;

function install_extra_post()
{
    true;
    # sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production GITLAB_ROOT_PASSWORD=yourpassword
    # sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
    # sudo -u git -H bundle exec rake assets:precompile RAILS_ENV=production
    cp -va /home/git/gitlab/lib/support/init.d /etc/
    ln -sv /home/git/.gem/ruby/2.2.0/bin/bundle /usr/bin/
    cp -va /etc/ssh/sshd_config.pacorig /etc/ssh/sshd_config
    cp -va /etc/nginx/nginx.conf.pacorig /etc/nginx/nginx.conf
    cp -va /etc/pam.d/crond{.pacorig,}
    cp -va /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

    # move to /entrypoint.sh
    # echo "" >> /etc/hosts
    # echo "10.97.198.249  gitlab-redis-n" >> /etc/hosts
    # echo "10.97.198.249  gitlab-mysql-n" >> /etc/hosts

}

function cleanup_env()
{
    true;
    # pacman -R --no-confirm vim vim-runtime
    # pacman -R --no-confirm sudo gcc
    # rm -f /var/cache/pacman/pkg/*.xz
    find /var/cache/pacman/pkg/ -name "*.xz" | xargs rm -f
    rm -fr /usr/share/doc/postfix/
    # rm -f  /usr/share/man/man{1,5,8}/*.gz
    find /usr/share/man/ -name "*.gz" | xargs rm -f
}
# cleanup_env;


function install_all()
{
    install_user;
    install_deps;
    
    install_extra_post;
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
echo "Install gitlab done.";



