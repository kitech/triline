#!/bin/sh

set -x
# sudo rsync -aAXvzp --progress --devices --delete /dev gzleo@10.0.0.6:/mnt/sda5/ossetup/oarch_rsync_rootfs/
sudo rsync -aAXv --delete --delete-excluded --progress --bwlimit=7M --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","var/lib/docker/devicemapper/devicemapper","/var/cache/pacman/pkg","/home/gzleo/VirtualBox VMs","/home/gzleo/.Genymobile/Genymotion","/home/gzleo/aur/aurcare"} / root@10.0.0.7:/mnt/sda5/ossetup/oarch_rsync_rootfs/

# restore

