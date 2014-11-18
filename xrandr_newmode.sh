#!/bin/sh
 
#xrandr --newmode "1680x1050" 147.1 1680 1784 1968 2256 1050 1051 1054 1087 +Hsync -Vsync
xrandr --newmode "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
xrandr --addmode LVDS1 "1680x1050_60.00"
xrandr --output LVDS1 --mode "1680x1050_60.00"
# xrandr --output LVDS1 --mode "1920x1200"

#sudo cpupower frequency-set --min 800MHz --max 800MHz

