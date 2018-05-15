pacman -Scc
pacman -Syy
pacman -S archlinux-keyring archlinuxcn-keyring
pacman-key --init
pacman-key --populate archlinux archlinuxcn-keyring
pacman-key --refresh-keys
pacman -Syu

# nano /etc/pacman.d/gnupg/gpg.conf
# change hkp://pool.sks-keyservers.net => http://pool.sks-keyservers.net
