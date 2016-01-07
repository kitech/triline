#!/bin/sh

# 手动调整风扇转速，控制/proc/acpi/ibm/fan的命令行工具
# level <level> (<level> is 0-7, auto, disengaged, full-speed)
level=$1
echo "level $level" > /proc/acpi/ibm/fan
ret=$?
if [ x"$ret" != x"0" ] ; then
    exit
fi

cat /proc/acpi/ibm/fan

# 有时间还可以看看lm_sensors中的fancontrol脚本。
# 不过感觉fancontrol这个脚本控制有问题，不灵活，适用性也不好，调整转速值不理想。
# 最近发现电脑休眠唤醒后，风扇不会自动恢复转动。
# 环境thinkpad x240，archlinux，kenerl-4.2/3，kde5.4
