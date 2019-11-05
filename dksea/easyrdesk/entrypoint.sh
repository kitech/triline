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
mkdir -p $HOME/.ssh # key login for heroku works
#curl some key > $HOME/.ssh/authorized_keys
echo "meowpc" >/etc/hostname
# hostname还需要在docker启动参数里设置

export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export TERM=xterm
cd /root

# /home是个永久存储卷
mkdir -p /home/$FUSER/
mkdir -p /home/logs/
/gotty --reconnect --max-connection 32 --port 8080 -w --credential "$FUSER:$FPASS" -t --tls-crt /etc/letsencrypt/erdesk/fullchain2.pem --tls-key /etc/letsencrypt/erdesk/privkey2.pem --term xterm /usr/bin/tmux &

export DISPLAY=:0
Xvfb :0 -screen scrn 1024x708x24 &
sleep 1
DISPLAY=:0 openbox --sm-disable &
sleep 1
feh --bg-scale /mac2012wallpaper.jpg &
sleep 3
tint2 &
/usr/bin/xtermc -e "neofetch && bash" &
sleep 3
#x11vnc -forever -nopw -noshm -nodpms -noxfixes -noxdamage -noxrecord -rfbport 5901 -display $DISPLAY &
x11vnc -forever -passwd "$FPASS" -noshm -nodpms -noxfixes -noxdamage -noxrecord -rfbport 5901 -display $DISPLAY &

cd /noVNC/ && python /noVNC/utils/websockify/run --web ./ --cert=/etc/letsencrypt/erdesk/fullchain2.pem --key=/etc/letsencrypt/erdesk/privkey2.pem 5902 127.0.0.1:5901 &

while true; do
    sleep 5;
    #putcvtdat;
    #break;
    true;
done

# -v /path/to/letsencrypt/erdesk:/etc/letsencrypt/erdesk

# TODO
# rfbCheckFds: select: Bad file descriptor

