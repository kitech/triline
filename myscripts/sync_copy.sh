#!/bin/sh

# usage:
# cd $DEST_DIR/gentoo_install_cd
# ../sync_copy.sh

###############
DEST_BASE=/media/hda5/myos
DEST_DIR=$DEST_BASE/gentoo_install_cd/
GB_TREE=$DEST_BASE/gentoo-box-tree/
KDE_TREE=$DEST_BASE/kneworld/
#GB_TREE=`realpath $GB_TREE`
CREATE_DATE=`date +'%Y%m%d'`

mkdir -pv $DEST_DIR
cp -v $DEST_BASE/sync_copy.sh $DEST_DIR/

# cd $KDE_TREE
# cp -vp /media/hda8/boot/grub/grub.conf /boot/grub/
# mkdir -p kde
#mv -v home/kneworld ../
# rsync -av -AH --progress --delete-during  /media/hda8/home/kneworld/kde/ kde/
# cp -v /home/kneworld/.bashrc $KDE_TREE/
# cp -v /home/gzl/Downloads/install_kde4beta_i18n.sh $KDE_TREE/
# cp -v /home/gzl/kde4_rcfile $KDE_TREE/

mkdir -pv $GB_TREE
cd $GB_TREE
rsync  -av  -AH --progress --delete-during --include=/opt/opera/ --include=/opt/Adobe/ --include=/opt/intel/ --include=/opt/netscape/  --exclude=/proc/* --exclude=/sys/*  --exclude=/data/* --exclude=/data1 --exclude=/serv/* --exclude=/swapfile.raw --exclude=/lost+found/* --exclude=/dev/* --exclude=/mnt/* --exclude=/media/* --exclude=/tmp/* --exclude=/var/tmp/* --exclude=/var/cache/*  --exclude=/home/* --exclude=/root/* --exclude=/opt/* --exclude=/usr/src/* --exclude=/usr/doc/* --exclude=/usr/examples/*  --exclude=/usr/demos/* --exclude=/usr/portage/* --exclude=/usr/local/portage/* --exclude=/usr/local/stow/* --exclude=/usr/local/Zend --exclude=/usr/kde/4.1/*   / .

#mv -v ../kneworld home/

cp -Rvp /dev/null ./dev/
cp -Rvp /dev/zero ./dev/
cp -Rvp /dev/ram* ./dev/
cp -Rvp /dev/loop* ./dev/
cp -Rvp /dev/tty* ./dev/
cp -Rvp /dev/console ./dev/


cp -Rvp /dev/hd* ./dev/
cp -Rvp /dev/shm ./dev/
cp -Rvp /dev/fd* ./dev/
cp -Rvp /dev/std* ./dev/
cp -Rvp /dev/*random ./dev/
cp -Rvp /dev/d* ./dev/
cp -Rvp /dev .

cp -v /home/gzleo/.viminfo ./root/
cp -v /home/gzleo/.emacs ./root/
cp -Rv /home/gzleo/.emacs.d ./root/
cp -v /home/gzleo/.Xresources ./root/
cp -v /home/gzleo/zh.reg ./root/
cp -v /home/gzleo/.bash_profile ./root/
# cp -Rv /root/.vmware ./root/
# cp -Rv /root/bin ./root/

tar zcvfp $DEST_DIR/gentoo_stage-$CREATE_DATE.tar.gz .

# cd $KDE_TREE/../
# tar zcvfp $DEST_DIR/kde4_svn_bin.tar.gz ./kneworld/

cd $DEST_DIR
#mv -v $GB_TREE/home/kneworld ../
mkisofs -JRTv -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 8 -boot-info-table  -o  $DEST_BASE/mygentoo-$CREATE_DATE.iso .
#mv -v ../kneworld  $GB_TREE/home/

