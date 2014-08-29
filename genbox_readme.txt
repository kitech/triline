Gentoo 2010.0 release 
(genbox Linux localhost 2.6.31-gentoo #3 SMP Mon Sep 14 10:20:33 CST 2009 i686 Intel(R) Pentium(R) Dual CPU E2160 @ 1.80GHz GenuineIntel GNU/Linux)
(systemrescuecd-x86-1.3.0.iso)

Account:
root/2113, gzl/2113, kneworld/2113, postgres/2113

video card: i195

Main packages:
  gcc-4.4.1
  kernel-2.6.31
  xfce4-4.6.0
  kde-4.4-svn
  xorg-server-1.6.3
  openoffice-3.1
  emacs-23.1

Main config:
  root device /dev/sda6
  grub2 loader
  dhcp of eth0
  user lang env: root/en_US.UTF-8,  other/zh_CN.UTF-8

Install:
  copy gentoo-box-tree/* to root path '/', change /etc/fstab for root device.
  change root fs type, the old is reiserfs 3.6 .
  if you are using ext4, alsa change it.
  grub-install to install grub on MBR or a partition.

