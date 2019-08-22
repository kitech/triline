#!/bin/sh

#
ip a
env

# 1G swap
fallocate -v -l 1000000000 /swap.img
mkswap /swap.img
chown 0600 /swap.img
swapon /swap.img # fail in docker

if [[ $USERPASS != "" ]]; then
    echo -e "${USERPASS}\n${USERPASS}" | passwd root > /dev/null 2>&1
else
    echo "No password mode"
fi

if [[ $NOSSHD == "" ]]; then
    /usr/bin/sshd -p 2222 -p 22 -E /dev/stdout
fi
if [[ $NONGINX == "" ]]; then
    /usr/bin/nginx -t
    /usr/bin/nginx
fi

/peeretcd >peeretcd.log 2>&1 &

sleep 5;
ss -ant|grep LISTEN

while true; do
    sleep 5;
    #break;
    true;
done

