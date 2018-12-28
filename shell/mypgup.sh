#!/bin/sh

OLDVER=10
NEWVER=11

# start old postgresql

pg_dumpall -f pg${OLDVER}.dmp

LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 initdb -D PGDB${NEWVER}

echo "host    all             all             10.0.0.1/16          md5" >> PGDB${NEWVER}/pg_hba.conf
echo "host    all             all             127.0.0.1/32          md5" >> PGDB${NEWVER}/pg_hba.conf

# postgresql.conf
# listen_addresses = '*'
# max_connections = 10
# max_wal_senders

# stop old postgresql
# start new postgresql
psql -d postgres -f pg${OLDVER}.dmp

