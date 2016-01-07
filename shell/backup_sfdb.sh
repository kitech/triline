#!/bin/sh

# 备份在sf.net上的数据库脚本，backupsf函数在shell.sf.net上执行
# backupsf函数下面的部分在本地执行
# 还不能做到完全自动化

set -x
## 
function backonsf()
{
    echo "backing drupal..."
    ls -lh n186258_drupal_ok.sql.gz
    mysqldump --add-drop-database -hmysql-n -un186258admin -padminxxx n186258_drupal >n186258_drupal_ok.sql
    gzip n186258_drupal_ok.sql
    ls -lh n186258_drupal_ok.sql.gz

    echo "backing mantis..."
    ls -lh n186258_mantis_utf8.sql.gz
    mysqldump --add-drop-database -h mysql-n  -u n186258admin -padminxxx n186258_mantis_utf8 >n186258_mantis_utf8.sql
    gzip n186258_mantis_utf8.sql
    ls -lh n186258_mantis_utf8.sql.gz

    echo "all done"

}

ssh -t liuguangzhao,nullget@shell.sf.net create

# exit

echo "fetch drupal db..."
# scp.orig liuguangzhao,nullget@shell.sf.net:/home/groups/n/nu/nullget/temp/n186258_drupal_ok.sql.gz   .
scp -C liuguangzhao,nullget@shell.sf.net:/home/users/l/li/liuguangzhao/n186258_drupal_ok.sql.gz   .
# scp.orig liuguangzhao,nullget@shell.sf.net:/home/users/l/li/liuguangzhao/nullget/temp/n186258_drupal_ok.sql.gz   .

echo "fetch mantis db..."
scp -C liuguangzhao,nullget@shell.sf.net:/home/users/l/li/liuguangzhao/n186258_mantis_utf8.sql.gz	.
# scp.orig liuguangzhao,nullget@shell.sf.net:/home/users/l/li/liuguangzhao/nullget/temp/n186258_mantis_utf8.sql.gz	.


# mysqldump --host=mysql-{LETTER}.sourceforge.net \
#--user={LETTER}{GROUP ID}admin -p --opt \
#    {LETTER}{GROUP ID}_{DATABASENAME} | gzip --fast > dumpfile.mysql.gz
