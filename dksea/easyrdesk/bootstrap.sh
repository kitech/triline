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
pacman -S --noconfirm openssh nginx iproute2 privoxy #supervisor
pacman -S --noconfirm tmux nano sudo mosh # some tools
pacman -S --noconfirm libx11 libxcb libxdmcp libxau libxfixes
pacman -S --noconfirm libvpx libsodium opus
pacman -S --noconfirm xorg-server-xvfb tint2 openbox xterm awk net-tools x11vnc wqy-zenhei wqy-microhei
pacman -S --noconfirm python python-numpy # noVNC need
#pacman -S --noconfirm firefox
rddpkgs="libpcap iptables libnetfilter_conntrack libnfnetlink systemd"
for p in $rddpkgs; do
    pacman -Rdd --noconfirm $p
done
r1pkgs=" icu libxml2 libcroco gettext"
for p in $r1pkgs; do
    pacman -R --noconfirm $p
done

rm -f /var/cache/pacman/pkg/*
rm -rf /usr/share/{man,doc,info,i18n,zoneinfo}/*
/usr/bin/deepclean.sh
echo "%dyno ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

/usr/bin/ssh-keygen -A
chmod +x /entrypoint.sh
mv /sshd_config /etc/ssh/
cp -v /etc/hosts{.bak,}
rm -f /etc/hosts.bak


