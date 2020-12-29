#!/bin/sh
#
# 备份系统配置文件，包括系统级配置与用户级配置
# 备份与本程序在同一repo下，triline.git

BAKDIR=~/dotfiles
BAKDIR=$(readlink -f $(dirname $(readlink -f $0))/../dotfiles)

echo $BAKDIR

# 支持 ~/模式的写法，和绝对路径写法
# 不支持通配符形式写法。
# 对于没有权限的文件，程序将忽略，并报告。
# 注意，不要把一些密钥类配置文件放在这。
# 每个文件或者目录一行。
etcfiles="
~/.bashrc
~/.bash_profile
~/.zshrc
~/.emacs
~/.spacemacs
~/.emacs.d/handby
~/.emacs.d/private
~/.vimrc
~/.gtkrc-2.0
~/.xinitrc
~/.Xmodmap
~/.Xresources
~/.gemrc
~/.cargo/config
~/.ssh/config
~/.gitconfig
~/.gitignore
~/.tmux.conf
~/.ngrok
~/.pip/pip.conf
~/.babelrc
~/synergy.conf
~/bin/elimg
~/bin/winerun
~/bin/vxrun
~/bin/qq
~/oss/bin/mparia2c
~/.config/openbox/rc.xml
~/.config/openbox/autostart
~/.config/openbox/environment
~/.config/tint2/tint2rc
~/.config/dunstrc
~/.config/flake8
~/.config/nvchecker/nvchecker.toml
~/.config/nvchecker/new_ver.json
~/.config/nvchecker/new_ver.json
~/.config/systemd/user
~/.config/systemd/user/godoc.service
~/.config/systemd/user/gnatsd.service
~/.config/systemd/user/synergys.service
~/.config/tox/2yatsen21.tox
~/.config/tox/2yatsen21.ini
~/.config/tox/yatsen21.tox
~/.config/tox/yatsen21.ini
~/.config/tox/yatsen31.tox
~/.config/tox/yatsen31.ini
~/.config/powerline/config.json
~/.config/vivaldi-snapshot/Default/Bookmarks
~/.config/vivaldi-snapshot/Default/Notes
~/.zsh
~/.cow/rc
~/.cow/rc.eg
~/.cow/direct
~/.cow/blocked
/etc/profile.d/zzl_gzleo.sh
/etc/pacman.d/mirrorlist
/etc/pacman.conf
/etc/rc.local
/etc/hosts
/etc/resolv.conf
/etc/resolv.conf.head
/etc/resolv.dnsmasq.conf
/etc/dnsmasq.conf
/etc/unbound/unbound.conf
/etc/sudoers
/etc/hostname
/etc/locale.gen
/etc/locale.conf
/etc/privoxy/config
/etc/miredo
/etc/modules-load.d
/etc/systemd/journald.conf
/etc/systemd/system/delegate-tor.service
/etc/supervisord.conf
/etc/supervisor.d
/etc/samba/smb.conf
/etc/conf.d/etcd3
/etc/unrealircd/unrealircd.conf
/var/spool/cron
/opt/psiphon/config.json
"

# echo $etcfiles

private_etcfiles="
/etc/shadowsocks/ss.json
"

######

if [ ! -d $BAKDIR ] ; then
    mkdir -v $BAKDIR
fi

# set -x
echo ""
echo "Begin backup all dot files......"
for ef in $etcfiles ; do
    rawef=$ef

    # echo ${ef:0:2}
    first_char=${ef:0:2}
    in_home=

    if [ x"$first_char" == x"~/" ] ; then
        in_home="yes"
        #ef="$HOME/${ef:2}"
        ef="/home/me/${ef:2}"
    fi

    if [ ! -e $ef ] ; then
        echo "The file not exists: $ef, omited."
        continue;
    fi

    if [ ! -r $ef ] ; then
        echo "The file not readable: $ef, omited."
        continue;
    fi

    # ref=$(readlink -f "$ef")  # 对于symlink来说，这么处理并不是想要的结果
    ref="$ef"  # for link, must keep it there, not realpath
    # echo "$ef => $ref"

    # ef="/home/me/${ef:2}" # TODO 试试这个？
    # ef="/home/`id -u`/${ef:2}" # TODO 试试这个？
    if [ -d $ref ] ; then
        path=$BAKDIR$ref
        if [ ! -e $path ] ; then
            mkdir -pv $path
        fi
        rsync -azp -l --progress $ref/ $path/
    else
        path=$BAKDIR$ref
        bpath=$(dirname $path)
        if [ ! -d $bpath ] ; then
            mkdir -pv $bpath
        fi
        rsync -azp  -l  --progress $ref $path
    fi
done

echo "Finished backup all dot files."
echo ""

### cleanup some tmp files

### show result
echo "Showing backup dot files tree view......"
tree -h -a -I '.git' $BAKDIR

echo "======================"
du -hs $BAKDIR
