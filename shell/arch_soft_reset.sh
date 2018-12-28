#!/bin/sh

# 系统使用时间长了之后，有些进程内存占用量变大，可以来个soft reset

# Clear PageCache only.
# sync; echo 1 > /proc/sys/vm/drop_caches
# Clear dentries and inodes.
# sync; echo 2 > /proc/sys/vm/drop_caches
# Clear PageCache, dentries and inodes.
# sync; echo 3 > /proc/sys/vm/drop_caches

# systemctl restart systemd-journald

# 手动重启一些GUI程序，像firefox, emacs, nethogs

# kill 会自动重启的
# /usr/lib/xfce4/panel/wrapper-2.0 /usr/lib/xfce4/panel/plugins/libxfce4powermanager.so
# xfce4-power-manager

