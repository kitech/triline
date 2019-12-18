#!/bin/sh

#
ip a
env

# 500M swap
fallocate -v -l 500000000 /swap.img
mkswap /swap.img
chown 0600 /swap.img
swapon /swap.img # fail in docker

if [[ $USERPASSENC != "" ]]; then
    # for heroku, 该值可以先在其他系统生成，再配置到docker环境
    uid=$(id -u)
    gid=$(id -g)
    sed -i 's/root/rootdep/' /etc/shadow
    echo "root1:x:$uid:$gid:root1:/root1:/bin/bash" >> /etc/passwd
    echo "root1:$USERPASSENC" >> /etc/shadow
    echo "u$uid:$USERPASSENC" >> /etc/shadow
    echo "dyno:$USERPASSENC" >> /etc/shadow
    echo "root:$USERPASSENC" >> /etc/shadow
elif [[ $USERPASS != "" ]]; then
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
    # fix heroku
    if [[ $PORT != "" ]] && [[ $DYNO != "" ]]; then
        sed -i 's/80;/'"$PORT"';/' /etc/nginx/nginx.conf
    fi
    /usr/bin/nginx -t
    /usr/bin/nginx
fi
/usr/bin/privoxy --config-test /etc/privoxy/config
/usr/bin/privoxy /etc/privoxy/config
mkdir -p $HOME/.ssh # key login for heroku works
#curl some key > $HOME/.ssh/authorized_keys

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
# cd /cvtier && ./start.sh
# run p2pvm
export LIBP2P_ALLOW_WEAK_RSA_KEYS=1
cd /p2pvm && ./p2vmnode --vms syth --ipfs-core-loglvl warn --syth-relays 160.16.88.249:22067 >p2.log 2>&1 &

# so it is the name
/looprun.sh /n163imtun -uid u2 -fuid u1 >n2.log 2>&1 &

while true; do
    sleep 5;
    #putcvtdat;
    #break;
    true;
done

