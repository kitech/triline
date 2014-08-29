#!/bin/sh


cd $HOME
source $HOME/.bash_profile


sudo swapon /mnt/sda2/ntlnx/disks/swap.disk

sleep 2

#sh -c X &
X &
sleep 2


export DISPLAY=:0.0
openbox &
fcitx &
lxterminal &

#google-chrome &
#chromium &
firefox &

pulseaudio --start --disallow-exit=true --exit-idle-time=3600000 &

sleep 5

#razor-panel &
lxqt-panel &

#vboxmanage startvm winxp32full &



