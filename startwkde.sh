#!/usr/bin/sh

#sudo ln -sv /home/gzleo/myscripts/startkde-wayland /usr/bin/

export DISPLAY=:99
export WAYLAND_DISPLAY=wayland-system-0
export KWIN_OPENGL_INTERFACE=egl_wayland

weston-launch -- --socket=wayland-system-0 &
Xvfb -screen 0 1440x900x24 :99 &

startkde-wayland &
