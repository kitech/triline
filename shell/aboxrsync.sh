#!/bin/sh

set -x
# sudo rsync -aAXvzp --progress --devices --delete /dev gzleo@10.0.0.6:/mnt/sda5/ossetup/oarch_rsync_rootfs/
# 注意exclude多项之间不要有空格
sudo rsync -aAXv --compress --delete --delete-excluded --progress --bwlimit=7M --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/var/lib/docker/overlay2","/var/cache/pacman/pkg","/home/gzleo/VirtualBox VMs","/home/gzleo/.cache","/home/gzleo/.gradle","/home/gzleo/.Genymobile/Genymotion","/home/gzleo/aur/aurcare","/home/gzleo/netfs","/home/gzleo/DownloadsBT","/home/gzleo/xware/xwstore","/home/gzleo/xware/xwstore2","/home/gzleo/golib","/home/gzleo/Qt5.9.3.bak","/home/gzleo/Qt5.*","/usr/share/doc","/usr/share/man","/usr/share/gtk-doc","/archrepo","/opt/andndk*","/zhome.img","/homeddd","/leveldrive","/opt","/var/lib/lxc","/var/lib/lxd","/home/gzleo/ownCloud","/home/gzleo/vmos"} / root@10.0.0.33:/mnt/ # sda5/ossetup/oarch_rsync_rootfs/

# rsync -av(z)p -e "ssh -p 2233" "$HOME/VirtualBox VMs/winxp" gzleo@10.0.0.32:/mnt/d/
# curl -C - -O "file:///home/me/VirtualBox VMs/winxp/winxp.vdi"

# restore

# rsync -aAXv --delete --delete-excluded --progress --bwlimit=7M root@10.0.0.7:/mnt/sda5/ossetup/oarch_rsync_rootfs/  /mnt/

