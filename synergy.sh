#!/bin/sh

action=$1

if [ x$action == x"server" ] ; then
	/usr/bin/synergys -f --no-tray --debug NOTE --name myarchbox -c ./synergy_server.conf --address :24800
else
	synergyc -f 10.207.27.146:24800
fi


