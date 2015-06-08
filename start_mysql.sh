#!/bin/sh


echo "127.0.0.1 mysql-n"

# mysql_install_db --user=mysql --basedir=/usr --datadir=/srv/var/mysql


cd '/srv' ; nohup /usr/bin/mysqld_safe --defaults-file=/srv/etc/mysql/my.cnf --datadir='/srv/var/mysql' &

# mysqladmin shutdown

