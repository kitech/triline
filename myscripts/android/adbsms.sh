#!/bin/sh

set -x;

#Backup:
#adb remount
#adb pull /data/data/com.android.providers.telephony/databases/mmssms.db mmssms.db
 
#Restore:
#adb remount
#adb push mmssms.db /data/data/com.android.providers.telephony/databases/mmssms.db

#Bakcup;
#adb remount
#adb pull /data/data/com.android.providers.telephony/databases/telephony.db telephony.db

#Restore:
adb remount
adb push telephony.db /data/data/com.android.providers.telephony/databases/telephony.db

#/sdcard/*.vcf

