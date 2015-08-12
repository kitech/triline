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
    # pacman -Syy
    pacman -S --noconfirm ruby mariadb-clients nginx git postfix nodejs redis
    # pacman -U --noconfirm /var/cache/pacman/pkg/*.xz

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
    cp -va /home/git/gitlab/lib/support/init.d /etc/
    ln -sv /home/git/.gem/ruby/2.2.0/bin/bundle /usr/bin/

    echo "" >> /etc/hosts
    echo "10.97.198.249  gitlab-redis-n" >> /etc/hosts
    echo "10.97.198.249  gitlab-mysql-n" >> /etc/hosts

}

function cleanup_env()
{
    true;
    pacman -R --no-confirm sudo vim vim-runtime gcc
    rm -f /var/cache/pacman/pkg/*.xz
}
# cleanup_env;


function install_all()
{
    install_user;
    install_deps;
    
    install_extra_post;
    cleanup_env;
}

install_all;
echo "Install gitlab done.";



