#!/usr/bin/env bash
# Generate a minimal filesystem for archlinux and load it into the local
# docker as "archlinux"
# requires root
set -e

hash pacstrap &>/dev/null || {
	echo "Could not find pacstrap. Run pacman -S arch-install-scripts"
	exit 1
}

hash expect &>/dev/null || {
	echo "Could not find expect. Run pacman -S expect"
	exit 1
}

export LANG="C.UTF-8"

ROOTFS=$(mktemp -d ${TMPDIR:-/var/tmp}/rootfs-archlinux-XXXXXXXXXX)
chmod 755 $ROOTFS

# packages to ignore for space savings
PKGIGNORE=(
    cryptsetup
    device-mapper
    dhcpcd
    iproute2
    jfsutils
    linux
    lvm2
    man-db
    man-pages
    mdadm
    nano
    netctl
    openresolv
    pciutils
    pcmciautils
    reiserfsprogs
    s-nail
    systemd-sysvcompat
    usbutils
    vi
    xfsprogs
)
IFS=','
PKGIGNORE="${PKGIGNORE[*]}"
unset IFS

expect <<EOF
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- \$arg
	}
	set timeout 60

	spawn pacstrap -C ./mkimage-arch-pacman.conf -c -d -G -i $ROOTFS base haveged --ignore $PKGIGNORE
	expect {
		-exact "anyway? \[Y/n\] " { send -- "n\r"; exp_continue }
		-exact "(default=all): " { send -- "\r"; exp_continue }
		-exact "installation? \[Y/n\]" { send -- "y\r"; exp_continue }
	}
EOF

arch-chroot $ROOTFS /bin/sh -c 'rm -r /usr/share/man/*'
arch-chroot $ROOTFS /bin/sh -c "haveged -w 1024; pacman-key --init; pkill haveged; pacman -Rs --noconfirm haveged; pacman-key --populate archlinux; pkill gpg-agent"
arch-chroot $ROOTFS /bin/sh -c "ln -s /usr/share/zoneinfo/UTC /etc/localtime"
echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
arch-chroot $ROOTFS locale-gen
arch-chroot $ROOTFS /bin/sh -c 'echo "Server = https://mirrors.kernel.org/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'

### deep cleanup, deep minimize it
echo 'LANG=en_US.UTF-8' > $ROOTFS/etc/locale.conf
echo 'LANG=en_US.UTF-8' > $ROOTFS/etc/default/locale
echo 'export LANG=en_US.UTF-8' >> $ROOTFS/etc/bash.bashrc
arch-chroot $ROOTFS /bin/sh -c 'echo "Server = http://mirrors.163.com/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist'
arch-chroot $ROOTFS /bin/sh -c 'echo "Server = http://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist'
arch-chroot $ROOTFS /bin/sh -c 'unlink /etc/localtime'
arch-chroot $ROOTFS /bin/sh -c "cp /usr/share/zoneinfo/Asia/Chongqing /etc/localtime"
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/share/man/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/share/doc/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/share/info/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/share/i18n/*'
arch-chroot $ROOTFS /bin/sh -c 'cd /usr/share/locale/ && ls | grep -v en_US| grep -v locale.alias|xargs rm -r'
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/{share,lib}/perl5/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/bin/core_perl/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/share/zoneinfo/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -rf /usr/share/iana-etc/*'
# Keep only xterm related profiles in terminfo.
arch-chroot $ROOTFS /bin/sh -c 'find /usr/share/terminfo/. ! -name "*xterm*" ! -name "*screen*" ! -name "*screen*" -type f -delete'
arch-chroot $ROOTFS /bin/sh -c 'find /usr/share/texinfo/. -name "*.pm" -type f -delete'
arch-chroot $ROOTFS /bin/sh -c 'find /usr/lib/. -name "*.a" -type f -delete'
# arch-chroot $ROOTFS /bin/sh -c 'rm -f /var/lib/pacman/sync/*'


# udev doesn't work in containers, rebuild /dev
DEV=$ROOTFS/dev
rm -rf $DEV
mkdir -p $DEV
mknod -m 666 $DEV/null c 1 3
mknod -m 666 $DEV/zero c 1 5
mknod -m 666 $DEV/random c 1 8
mknod -m 666 $DEV/urandom c 1 9
mkdir -m 755 $DEV/pts
mkdir -m 1777 $DEV/shm
mknod -m 666 $DEV/tty c 5 0
mknod -m 600 $DEV/console c 5 1
mknod -m 666 $DEV/tty0 c 4 0
mknod -m 666 $DEV/full c 1 7
mknod -m 600 $DEV/initctl p
mknod -m 666 $DEV/ptmx c 5 2
ln -sf /proc/self/fd $DEV/fd

tar --numeric-owner --xattrs --acls -C $ROOTFS -c . | docker import - archlinux
docker run -t archlinux echo Success.
rm -rf $ROOTFS