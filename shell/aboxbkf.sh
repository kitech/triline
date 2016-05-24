#!/bin/sh

# skiped: /home /opt

rsync -av --delete \
      /etc /var /bin /boot /lib /lib64 /root /sbin /run /tmp /usr \
      --exclude /run/media --exclude /var/lib/docker --exclude /var/lib/mongodb/journal \
      --exclude /var/lib/mysql --exclude /var/spool/postfix \
      /home/archbak/

# cd /home/archbak
# tar zcvp -f - . | split -b 4567M - ../archbak_201605.tar.gz. --verbose

