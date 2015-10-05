#!/bin/sh

##### 常用的发行版本安装CD/liveCD打包到USB/CD，用于系统的恢复与演示和备份

# 可以考虑的发行版本：
# systemrescuecd
# arch-core
# arch-live
# grub.exe
# Super Grub2 Disk
# linux-mint
# slax
# puppy/macup

# 共2G
# 生成的USB 使用USB HDD启动。

### 主脚本使用的MultiCD实现
# git://github.com/IsaacSchemm/MultiCD.git
# multicd使用的syslinux启动的，要是能使用grub2启动就好了，还能做个好些的grub2 theme

aria2c -c -x 5 -k 1M http://jaist.dl.sourceforge.net/project/supergrub.berlios/super_grub2_disk_hybrid_2.00s1-beta1.iso

#aria2c -c -x 5 -k 1M http://pritcms.com/downloads/macpup_529.iso
aria2c -c -x 5 -k 1M http://distro.ibiblio.org/puppylinux/puppy-5.5/slacko-5.5-PAE.iso

aria2c -c -x 5 -k 1M http://www.slax.org/download/7.0.5/slax-Chinese-Simplified-7.0.5-x86_64.iso
