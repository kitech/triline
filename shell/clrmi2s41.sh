#!/bin/sh

# clear mi2s miui os

devname=61b941b
set -x
adb -s $devname shell 'su -c "mount -o remount,rw /system"'
adb -s $devname shell 'su -c "mount"' | grep "/system"
adb -s $devname shell 'su -c "rm /system/app/42*.apk"'
adb -s $devname shell 'su -c "rm /system/app/XiaomiServiceFramework.apk"'
adb -s $devname shell 'su -c "rm /system/app/CloudService.apk"'
adb -s $devname shell 'su -c "rm /system/app/MiLinkService.apk"'
adb -s $devname shell 'su -c "rm /system/app/Mipay.apk"'
adb -s $devname shell 'su -c "rm /system/app/PaymentService.apk"'
adb -s $devname shell 'su -c "rm /system/app/KeyChain.apk"'
adb -s $devname shell 'su -c "rm /system/app/YellowPage.apk"'
adb -s $devname shell 'su -c "rm /system/app/BugReport.apk"'
adb -s $devname shell 'su -c "rm /system/app/AntiSpam.apk"'
adb -s $devname shell 'su -c "rm /system/app/LBESEC_MIUI.apk"'
adb -s $devname shell 'su -c "rm /system/app/ThemeManager.apk"'
adb -s $devname shell 'su -c "rm /system/app/Updater.apk"'
adb -s $devname shell 'su -c "rm /system/app/Music.apk"'
adb -s $devname shell 'su -c "rm /system/app/MiuiVideo.apk"'
adb -s $devname shell 'su -c "rm /system/app/CalendarProvider.apk"'
adb -s $devname shell 'su -c "rm /system/app/Calendar.apk"'
adb -s $devname shell 'su -c "rm /system/app/KingSoftCleaner.apk"'
adb -s $devname shell 'su -c "rm /system/app/ChromeBookmarksSyncAdapter.apk"'
adb -s $devname shell 'su -c "rm /system/app/VoiceAssist.apk"'
adb -s $devname shell 'su -c "rm /system/app/GuardProvider.apk"'
adb -s $devname shell 'su -c "rm /system/app/NetworkAssistant2.apk"'
# adb -s $devname shell 'su -c "rm /system/app/MiuiGallery.apk"'
adb -s $devname shell 'su -c "rm /system/app/MiuiCompass.apk"'
adb -s $devname shell 'su -c "rm /system/app/*Wallpaper*.apk"'
adb -s $devname shell 'su -c "rm /system/app/Wfd*.apk"'
adb -s $devname shell 'su -c "rm /system/app/Whetstone.apk"'
adb -s $devname shell 'su -c "rm /system/app/Wiper.apk"'
adb -s $devname shell 'su -c "rm /system/app/Stk.apk"'
adb -s $devname shell 'su -c "rm /system/app/Superuser.apk"'
adb -s $devname shell 'su -c "rm /system/app/Ds.apk"'
adb -s $devname shell 'su -c "rm /system/app/PackageInstaller.apk"'
adb -s $devname shell 'su -c "rm /system/app/WifiSetting*.apk"'
adb -s $devname shell 'su -c "rm /data/app/42*.apk"'
adb -s $devname shell 'su -c "rm /data/app/partner-XunfeiSpeechService3.apk"'

# https://forum.xda-developers.com/poco-f1/how-to/debloating-xiaomi-poco-f1-safe-to-t3836119

# adb shell 'input text aaa'
