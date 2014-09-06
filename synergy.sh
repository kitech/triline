#!/bin/sh

action=$1

sip=10.207.27.127:24800
if [ x$action == x"server" ] ; then
	/usr/bin/synergys -f --no-tray --debug NOTE --name myarchbox -c ./synergy_server.conf --address :24800
else
	synergyc -f $sip # 10.207.27.146:24800
fi


