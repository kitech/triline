#!/bin/sh

VMDIR=/mnt/sda4/vms/kvm
WVIO=/mnt/sda4/vms/virtio-win-1.1.11-0.iso
WVIO=$VMDIR/../virtio-win-0.1-65.iso
LITEXPISO=/mnt/sda4/TDDOWNLOAD/DEEPIN-LITEXP-6.2.iso

macaddr=`./auto-mac.sh`

kvm_modules=`lsmod | grep kvm`
if [ x"$kvm_modules" = x"" ] ; then
    echo "Please load kvm first: modprobe kvm kvm-intel kvm-amd";
    exit;
fi

# cache=writethrought,writeback,none,unsafe
# unsafe's performance is most high, but maybe lost data
# none's performance is worst
# writeback has average performance

# if=virtio/ide need scsi driver, if not like winxp, use if=ide

#ifname=kvmbnet00   full kvm bridge net 00

#soundhw=ac97/es1370/sb16 all ok


# test xp 
# qemu-kvm -m 500 -vnc :0 -enable-kvm -sdl -drive file=xp-kvm.img,cache=unsafe,if=ide -writeconfig xp-kvm.cfg  -drive file=/mnt/sda7/ossetup/virtio-win-1.1.11-0.iso,cache=writeback,media=cdrom -boot order=c -soundhw ac97 -drive file=fake.qcow2,if=virtio,cache=unsafe -net nic,macaddr=DE:AD:BE:EF:F6:68 -net tap,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh -rtc base=localtime

# winxp 32
# ------      -cpu kvm32  -sdl
# old command, no vhost-net, no virtio
# qemu-kvm -m 128 -vnc :0 -enable-kvm -sdl -drive file=winxp32.img,cache=writeback,if=ide -writeconfig winxp32.cfg -drive file=/mnt/sda7/ossetup/Deepin-LiteXP-SP3.ISO,cache=unsafe,media=cdrom -boot order=dc  -net nic,macaddr=DE:AD:BE:EF:F6:68 -net tap,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh -rtc base=localtime

# test using vhost, blue screen???  very good now
# dont use -cpu kvm32 or -cpu kvm64, or blue screen, 
# now vhost-net ok for winxp 32, but the driver should manual install from virtio-win-xxx.iso
# using this new command
qemu-system-i386 -m 128 -vnc :0 -enable-kvm -sdl -soundhw ac97 -drive file=$VMDIR/winxp32.img,cache=writeback -drive file=$VMDIR/fake1.img,cache=unsafe -writeconfig winxp32.cfg -drive file=$LITEXPISO,cache=unsafe,media=cdrom -drive file=$WVIO,cache=unsafe,media=cdrom -boot order=dc  -rtc base=localtime -netdev type=tap,id=kvmbnet00,ifname=kvmbnet00,script=./wqemu-ifup.sh,downscript=./wqemu-ifdown.sh,vhost=on
#  -device virtio-net-pci,netdev=kvmbnet00,mac=DE:AD:BE:EF:F6:68
# -drive file=$WVIO,cache=unsafe,media=cdrom

# winxp 64
# qemu-kvm -m 600 -vnc :0 -enable-kvm -sdl -soundhw ac97 -drive file=winxp64.img,cache=writeback,if=virtio -drive file=fake1.img,cache=unsafe,if=virtio -writeconfig winxp64.cfg -drive file=/mnt/sda7/ossetup/winxp_x64_sp2.iso,cache=unsafe,media=cdrom -drive file=/mnt/sda7/ossetup/virtio-win-1.1.11-0.iso,cache=unsafe,media=cdrom -boot order=dc  -rtc base=localtime -netdev type=tap,id=kvmbnet00,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh,vhost=on -device virtio-net-pci,netdev=kvmbnet00,mac=DE:AD:BE:EF:F6:68


# ubuntu 9.04
# qemu-kvm -cpu kvm32 -m 500 -vnc :0 -enable-kvm -sdl -drive file=ubuntu32.img,cache=unsafe,if=virtio -writeconfig ubuntu32.cfg -drive file=/mnt/sda7/ossetup/ubuntu-8.10-desktop-i386.iso,cache=unsafe,media=cdrom -boot order=cd  -net nic,macaddr=DE:AD:BE:EF:F6:68 -net tap,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh -rtc base=localtime

# this method run ok, this will using kernel accelerate, vhost-net.ko, lsmod | grep vhost-net
# qemu-kvm -cpu kvm32 -m 500 -vnc :0 -enable-kvm -sdl -drive file=ubuntu32.img,cache=unsafe,if=virtio -writeconfig ubuntu32.cfg -drive file=/mnt/sda7/ossetup/ubuntu-8.10-desktop-i386.iso,cache=unsafe,media=cdrom -boot order=cd  -rtc base=localtime -netdev type=tap,id=kvmbnet00,ifname=kvmbnet00,script=./wqemu-ifup.sh,downscript=./wqemu-ifdown.sh,vhost=on -device virtio-net-pci,netdev=kvmbnet00,mac=DE:AD:BE:EF:F6:68

# ubuntu 11.04  natty-desktop-amd64.iso 
# no mouse, mouse can not move
# qemu-kvm -cpu kvm64 -m 500 -vnc :0 -enable-kvm  -sdl    -drive file=ubuntu64.img,cache=unsafe,if=virtio -writeconfig ubuntu64.cfg -drive file=/mnt/sda7/ossetup/natty-desktop-amd64.iso,cache=unsafe,media=cdrom -boot order=cd  -rtc base=localtime -netdev type=tap,id=kvmbnet00,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh,vhost=on -device virtio-net-pci,netdev=kvmbnet00,mac=DE:AD:BE:EF:F6:68

# kvm direct use vbox vdi by vdfuse
# export SDL_VIDEO_X11_DGAMOUSE=0 # no use
#qemu-kvm -cpu kvm64 -m 500 -vnc :0 -enable-kvm  -sdl    -drive file=/mnt/vdi/EntireDisk,cache=unsafe,if=virtio -writeconfig ubuntu64.cfg -drive file=/mnt/sda7/ossetup/natty-desktop-amd64.iso,cache=unsafe,media=cdrom -boot order=cd  -rtc base=localtime -netdev type=tap,id=kvmbnet00,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh,vhost=on -device virtio-net-pci,netdev=kvmbnet00,mac=DE:AD:BE:EF:F6:68 -usb -usbdevice tablet

# test without partition,
# ok, but should change a litte menu.lst
# qemu-kvm -cpu kvm32 -m 500 -vnc :0 -enable-kvm -sdl -drive file=testnop.img,cache=unsafe,if=virtio -writeconfig ubuntu32.cfg -drive file=/mnt/sda7/ossetup/ubuntu-8.10-desktop-i386.iso,cache=unsafe,media=cdrom -boot order=cd  -rtc base=localtime -netdev type=tap,id=kvmbnet00,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh,vhost=on -device virtio-net-pci,netdev=kvmbnet00,mac=DE:AD:BE:EF:F6:68

# freebsd 7
# need sysinstall enable mouse
# qemu-kvm -cpu kvm32 -m 500 -vnc :0 -enable-kvm -sdl -vga std -drive file=freebsd32.img,cache=unsafe,if=ide -writeconfig freebsd32.cfg -drive file=/mnt/sda7/ossetup/7.2-RELEASE-i386-disc1.iso,cache=unsafe,media=cdrom -drive file=/mnt/sda7/ossetup/7.2-RELEASE-i386-disc2.iso,cache=unsafe,media=cdrom -drive file=/mnt/sda7/ossetup/7.2-RELEASE-i386-disc3.iso,cache=unsafe,media=cdrom -boot order=c  -net nic,macaddr=DE:AD:BE:EF:F6:68 -net tap,ifname=kvmbnet00,script=./qemu-ifup.sh,downscript=./qemu-ifdown.sh -rtc base=localtime




