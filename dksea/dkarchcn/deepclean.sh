### deep cleanup, deep minimize it
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
rm -rf /usr/share/info/*
rm -rf /usr/share/i18n/*
rm -rf /usr/{share,lib}/perl5/*
rm -rf /usr/bin/core_perl/*
rm -rf /usr/share/zoneinfo/*
rm -rf /usr/share/iana-etc/*
rm -rf /usr/share/gtk-doc/*
#rm -rf /usr/lib/locale
rm -rf /usr/lib/udev
rm -rf /usr/lib/libasan.so*
rm -rf /usr/lib/libtsan.so*
rm -rf /usr/lib/libgo.so*
rm -rf /usr/include/*
# Keep only xterm related profiles in terminfo.
find /usr/share/terminfo/. ! -name "*xterm*" ! -name "*screen*" ! -name "*screen*" -type f -delete
find /usr/lib/. -name "*.a" -type f -delete
if [ -d /usr/share/texinfo ]; then
    find /usr/share/texinfo/. -name "*.pm" -type f -delete
fi
# rm -f /var/lib/pacman/sync/*
