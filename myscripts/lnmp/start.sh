#!/bin/sh


set -x

RUSER=$SUDO_USER
/serv/stow/nginx/sbin/nginx -c /home/$RUSER/myscripts/lnmp/nginx.conf $@


### start php-fpm
/serv/stow/php-5.5.x/sbin/php-fpm --fpm-config /home/$RUSER/myscripts/lnmp/php-fpm.ini


