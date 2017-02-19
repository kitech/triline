#!/bin/sh

# https://wiki.archlinux.org/index.php/kexec

kexec -l /boot/vmlinuz-linux-macbook --initrd=/boot/initramfs-linux-macbook.img --reuse-cmdline
systemctl kexec
