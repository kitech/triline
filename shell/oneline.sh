#!/bin/sh

# 查找linux系统中的循环链接
# find . -follow -printf ""
# centos默认coredump文件名格式
# find -name "core.[0-9]*"
# 改过的coredump文件名格式
# find -name "*.P[0-9]*.core"
# find -name "*.png" -exec cp -v "{}" ../images/ \;
# echo $(head -n1 /var/log/pacman.log | cut -d " " -f 1,2) 以来一共滚了 $(grep -c "full system upgrade" /var/log/pacman.log)
# echo udp server with nc
# ncat -e /bin/cat -k -u -l 127.0.0.1 13389 -vvv
# client: nc -u 127.0.0.1 13389 -v
# used in cross evn, suck as .so is arm elf, ldd can do that
# objdump -x libQt5Inline.so | grep NEEDED
# pv my_big_file > backup/my_big_file
# alias cp="rsync -avz"
# curl -C - -O "file:///media/CORSAIR/somefile.dat"

