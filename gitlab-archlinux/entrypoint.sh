#!/bin/sh

set -e

if [ "$1" = 'gitlab-server' ]; then
	# chown -R redis .
	# exec gosu redis "$@"
    /etc/init.d/gitlab restart
fi

exec "$@"

