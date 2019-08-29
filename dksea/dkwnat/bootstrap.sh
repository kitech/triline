#!/bin/sh

#set -x
#set -e

env > env.txt
env
cat /etc/resolv.conf
echo "nameserver 1.1.1.1" >/etc/resolv.conf.new
cat /etc/resolv.conf >>/etc/resolv.conf.new
cp -v /etc/resolv.conf{.new,}
rm -f /etc/resolv.conf.new

##########
cp /etc/hosts{,.bak}
echo "101.6.8.193 mirrors.tuna.tsinghua.edu.cn" >> /etc/hosts
echo "202.141.176.110 mirrors.ustc.edu.cn" >> /etc/hosts
echo "59.111.0.251 mirrors.163.com" >> /etc/hosts

pacman -Sy
pacman -S --noconfirm openssh iproute2 openvpn
pacman -S --noconfirm tmux # some tools
pacman -S --noconfirm aria2 wxgtk-common transmission-cli
rddpkgs="libpcap iptables libnetfilter_conntrack libnfnetlink systemd dbus"
for p in $rddpkgs; do
    pacman -Rdd --noconfirm $p
done
r1pkgs="perl icu libxml2 libcroco gettext"
for p in $r1pkgs; do
    pacman -R --noconfirm $p
done

rm -f /var/cache/pacman/pkg/*
rm -rf /usr/share/{man,doc,info,i18n,zoneinfo}/*
/usr/bin/deepclean.sh

/usr/bin/ssh-keygen -A
chmod +x /entrypoint.sh
mv /sshd_config /etc/ssh/
cp -v /etc/hosts{.bak,}
rm -f /etc/hosts.bak
rm -f ovpki.tar


