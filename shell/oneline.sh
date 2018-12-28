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
# readelf -l my-prog | grep -i "file type"
# pv my_big_file > backup/my_big_file
# alias cp="rsync -avz"
# curl -C - -O "file:///media/CORSAIR/somefile.dat"
# patchelf --set-soname libnewname.so.3.4.5 path/to/libmylibrary.so.1.2.3
# sound/audio to pcm (raw audio)
# sox file.mp3 -c 1 -r 44100 -b 16 -e signed-integer --endian little -t raw output.bin
# To tweak the speed, execute the following: ~+30% for old IDE
# hdparm -d1 -c1 -m16 --yes-i-know-what-i-am-doing /dev/sda
# hdparm -Tt /dev/sda
# ssh user@machine-where-precious-data-is "tar czpf - /some/important/data" | tar xzpf - -C /new/root/directory
# sqlite3 test.db .schema > schema.sql
# filter android app log, need app runup
# adb logcat | grep -F "`adb shell ps | grep com.example.package | cut -c10-15`"
# docker run -i -t --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix ubuntu:16.04 /bin/bash
# gdb -p 10029 --batch -ex 'call close(4)'  # close a running process's open file description
# chromium --process-per-site

