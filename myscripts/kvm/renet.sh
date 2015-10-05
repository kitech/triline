#!/bin/sh

























phy_if=eth0
# phy_if=wlan0

# maybe useful
sudo brctl show
sudo ip link set br0 down
sudo brctl delif br0 $phy_if
sudo brctl delbr br0

sudo brctl show
sudo brctl delif br1 $phy_if
sudo brctl delbr br1


sudo brctl addbr br0
sudo brctl addif br0 $phy_if

if [ x"$phy_if" = x"wlan0" ] ; then
    true
else
    sudo ifconfig $phy_if 0.0.0.0
    sudo dhcpcd br0
fi

#Changelog
# 2011-01-04  test wlan0 bridge
