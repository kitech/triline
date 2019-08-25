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
    # 带 -E /dev/stdout参数，导致连接时报错：kex_exchange_identification: read: Connection reset by peer
    #/usr/bin/sshd -p 2222 -p 22 -E /dev/stdout
    /usr/bin/sshd -p 2222 -p 22
fi
if [[ $NONGINX == "" ]]; then
    /usr/bin/nginx -t
    /usr/bin/nginx
fi

/peeretcd >peeretcd.log 2>&1 &
ret=$?
if [[ $ret != 0 ]]; then
    echo "start process failed $ret"
    exit $ret
fi

sleep 5;
ss -ant|grep LISTEN
while true; do
    curl 'http://127.0.0.1:5080/pcapi/waitok'
    ret=$?
    if [[ $ret == 0 ]]; then
        break;
    fi
    sleep 3;
done

# prepare cvtier env
curl 'http://127.0.0.1:5080/pcapi/waitok'
while true; do
    uniqid=$(curl 'http://127.0.0.1:5080/pcapi/uniqid')
    if [[ $uniqid != "" ]]; then
        break;
    fi
    sleep 3;
done
curl -m 20 'http://127.0.0.1:5080/pcapi/getsave/?key=cvtierid&filename=/cvtier/cvtier.ini.data'
echo "[server]" > /cvtier/cvtier.ini
echo "name=${uniqid}" >> /cvtier/cvtier.ini
echo "[client]" >> /cvtier/cvtier.ini
echo "[router]" >> /cvtier/cvtier.ini
cat /cvtier/cvtier.ini

cvtputonce=0
cvtexist=0
if [[ -f /cvtier/cvtier.ini.data ]]; then
    cvtexist=1
fi
function putcvtdat()
{
    if [[ $cvtexist == 0 ]] && [[ $cvtputonce == 0 ]]; then
        cvtkey="cvtierid${uniqid:6:90}"
        curl -X PUT -T "/cvtier/cvtier.ini.data" "http://127.0.0.1:5080/pcapi/setsave/?filename=${cvtkey}"
        cvtputonce=1
    fi
}

# run cvtier
cd /cvtier && ./start.sh

while true; do
    sleep 5;
    putcvtdat;
    #break;
    true;
done

