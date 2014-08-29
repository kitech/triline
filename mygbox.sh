#!/bin/sh
set -e
. $MCDDIR/functions.sh

if [ $1 = links ];then
	echo "archlinux-*-netinstall-dual.iso archdual.iso none"
elif [ $1 = scan ];then
	if [ -f vbox ];then
		echo "Myself data"
	fi
elif [ $1 = copy ];then
	if [ -f abcd.7z ];then
		echo "Copying Myself data..."
        mkdir -pv $WORK/mygbox/
        cp -v abcd.7z $WORK/mygbox/
		#mcdmount archdual
		#cp -r $MNT/archdual/arch $WORK/archdual
		#umcdmount archdual
	fi
elif [ $1 = writecfg ];then
    true
	# if [ -f archdual.iso ];then
	# 	echo "label arch
	# 	menu label --> ^Arch Linux ($(getVersion archdual))
	# 	KERNEL /archdual/boot/syslinux/ifcpu64.c32
	# 	APPEND have64 -- nohave64
	
	# 	LABEL have64
	# 	MENU HIDE
	# 	CONFIG /archdual/boot/syslinux/syslinux_both.cfg
	# 	APPEND /archdual/boot/syslinux/
	
	# 	LABEL nohave64
	# 	MENU HIDE
	# 	CONFIG /archdual/boot/syslinux/syslinux_32only.cfg
	# 	APPEND /archdual/boot/syslinux/
	# 	" >> $WORK/boot/isolinux/isolinux.cfg
	# 	for i in 32 64;do
	# 		sed -i -e 's^/arch/boot^/archdual/boot^g' $WORK/archdual/boot/syslinux/syslinux_arch${i}.cfg
	# 		sed -i -e 's^archisobasedir=arch^archisobasedir=archdual^g' $WORK/archdual/boot/syslinux/syslinux_arch${i}.cfg
	# 		sed -i -e "s^archisolabel=ARCH_201108^archisolabel=$CDLABEL^g" $WORK/archdual/boot/syslinux/syslinux_arch${i}.cfg
	# 	done
	# 	sed -i -e 's^/arch/boot/memtest^/boot/memtest^g' $WORK/archdual/boot/syslinux/syslinux_tail.cfg
	# 	sed -i -e 's^MENU ROWS 7^MENU ROWS 8^g' $WORK/archdual/boot/syslinux/syslinux_head.cfg
	# 	echo "
	# 	label back
	# 	menu label ^Back to main menu
	# 	config /boot/isolinux/isolinux.cfg
	# 	append /boot/isolinux
	# 	" >> $WORK/archdual/boot/syslinux/syslinux_tail.cfg
	# fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi
