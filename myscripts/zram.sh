#!/bin/sh

# doc: https://wiki.archlinux.org/title/Zram

ison="$1"
curfile=$(readlink -f $0)
if [ $USER != "root" ]; then
	echo "need auto sudo..."
	sudo "$curfile" "$@"
	exit;
fi

set -x

if [ x"$ison" == x"on" ]; then
	modprobe zram
	# default 50% of phyiscal memory
	zramctl /dev/zram0 --algorithm zstd --size "$(($(grep -Po 'MemTotal:\s*\K\d+' /proc/meminfo)*9/5))KiB"
	mkswap -U clear /dev/zram0
	swapon --discard --priority 100 /dev/zram0
elif [ x"$ison" == x"off" ]; then
	zramctl
	swapoff /dev/zram0
	#modprobe -r zram
	echo 1 > /sys/module/zswap/parameters/enabled
else
	echo "zram info: (cmds: [on|off|other]"
	zramctl --output-all
fi
