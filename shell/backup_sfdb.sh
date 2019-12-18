#!/bin/sh

# 备份在sf.net上的数据库脚本，backupsf函数在shell.sf.net上执行
# backupsf函数下面的部分在本地执行
# 还不能做到完全自动化
# usage: cmd [remote|nocreate|login]

sfuser=$sfuser
passwd=$passwd # from env
sfdir=/home/users/l/li/$sfuser
subcmd=$1

set -x
###
function backonsf()
{
    echo "backing drupal..."
    ls -lh n186258_drupal_ok.sql.gz
    mysqldump --add-drop-database -hmysql-n -un186258admin -pxxx n186258_drupal >n186258_drupal_ok.sql
    gzip -vf n186258_drupal_ok.sql
    ls -lh n186258_drupal_ok.sql.gz

    echo "backing mantis..."
    ls -lh n186258_mantis_utf8.sql.gz
    mysqldump --add-drop-database -h mysql-n  -u n186258admin -pxxx n186258_mantis_utf8 >n186258_mantis_utf8.sql
    gzip -vf n186258_mantis_utf8.sql
    ls -lh n186258_mantis_utf8.sql.gz

    echo "backing on remote done"
}
function creatersh()
{
    echo "create temp shell ..."
    #ssh -t $sfuser,nullget@shell.sf.net create
    plink -pw "$passwd" -ssh -t -l "$sfuser,nullget" shell.sf.net create
    # exit on remote host
}

function backonloc()
{
    echo "put backcmd ..."
    pscp -pw "$passwd" -C ./backup_sfdb.sh $sfuser,nullget@shell.sf.net:$sfdir/

    plink -pw "$passwd" -ssh -batch -t -l "$sfuser,nullget" shell.sf.net "./backup_sfdb.sh remote"

    echo "fetch drupal db..."
    # scp.orig $user,nullget@shell.sf.net:/home/groups/n/nu/nullget/temp/n186258_drupal_ok.sql.gz   .
    pscp -pw "$passwd" -C $sfuser,nullget@shell.sf.net:/home/users/l/li/$sfuser/n186258_drupal_ok.sql.gz   .
    # scp.orig $user,nullget@shell.sf.net:/home/users/l/li/$user/nullget/temp/n186258_drupal_ok.sql.gz   .

    echo "fetch mantis db..."
    pscp -pw "$passwd" -C $sfuser,nullget@shell.sf.net:/home/users/l/li/$sfuser/n186258_mantis_utf8.sql.gz	.
    # scp.orig $user,nullget@shell.sf.net:/home/users/l/li/$user/nullget/temp/n186258_mantis_utf8.sql.gz	.
}

if [ x"$1" == x"remote" ]; then
    backonsf;
    exit;
fi

if [ x"$sfuser" == x"" ] || [ x"$passwd" == x"" ]; then
    echo "no sfuser and/or passwd"
    exit -1;
fi

if [ ! x"$subcmd" == x"nocreate" ]; then
    creatersh;
else
    backonloc;
fi

# mysqldump --host=mysql-{LETTER}.sourceforge.net \
#--user={LETTER}{GROUP ID}admin -p --opt \
#    {LETTER}{GROUP ID}_{DATABASENAME} | gzip --fast > dumpfile.mysql.gz
