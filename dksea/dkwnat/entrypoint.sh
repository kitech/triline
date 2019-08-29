#!/bin/sh

#
ip a
env

# 500M swap
fallocate -v -l 500000000 /swap.img
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

echo "$PEMKEY" > ovpassfile
sed -i "s/SRVPROTO/$WNAT_SRVPROTO/g" wnatcli.ovpn
sed -i "s/SRVIP/$WNAT_SRVIP/g" wnatcli.ovpn
sed -i "s/SRVPORT/$WNAT_SRVPORT/g" wnatcli.ovpn
AMECPass=$(echo -n "$PEMKEY"|md5sum|cut -b '1-32')
sed -i "s/AMECPass/$AMECPass/g" amule.conf
grep EC amule.conf
mkdir -p $HOME/.aMule
mv -v amule.conf $HOME/.aMule/

PHYGW=172.17.0.1
VPNGW=10.8.0.9
ip route add $WNAT_SRVIP/32 via 172.17.0.1
openvpn --config wnatcli.ovpn --askpass ovpassfile >ovpn.log 2>&1 &

sleep 5;
ip route del default
ip route add default via 10.8.0.9
ip route add 101.6.8.193/32 via 172.17.0.1
ip route add 202.141.176.110/32 via 172.17.0.1
ip route add 59.111.0.251/32 via 172.17.0.1

sleep 5;
ss -ant|grep LISTEN
ss -anu

while true; do
    sleep 5;
    #break;
    true;
done

