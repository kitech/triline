#!/bin/sh

# Server sshd simple, no more hard config
# All out/err show console
# Generate temp config and rsa key file in current directory

# Usage: no args now
# todo more args, like port, log

# script args
DFTPORT=2222
PORT=$DFTPORT
DFTLOGLVL=VERBOSE
LOGLVL=$DFTLOGLVL
DFTROOT=yes
ROOT=$DFTROOT

#####
# -d for debug, but only one connection
# -D for foreground
# -E /dev/stderr == -e
# /usr/bin/sshd -p 2222 -E /dev/stderr

ISDROID=$(env|grep "USER=u0_"|wc -l)

echo "Remember set password on termux!!!"
echo "Use anyuser@ip for termux, it don't care!!!"

if [ ! -f sshdez.cfg ]; then
    touch sshdez.cfg
    # termux not support
    if [ x"$ISDROID" == x"0" ]; then
        echo 'UsePAM yes' >> sshdez.cfg
        echo 'Subsystem	sftp /usr/lib/ssh/sftp-server' >> sshdez.cfg
    else
        echo 'Subsystem	sftp $HOME/../usr/libexec/sftp-server' >> sshdez.cfg
    fi
    echo 'LogLevel $LOGLVL' >> sshdez.cfg
    echo 'PermitRootLogin prohibit-password' >> sshdez.cfg
    echo 'PasswordAuthentication no' >> sshdez.cfg
    # it default, omit
    #echo "AuthorizedKeysFile $HOME/.ssh/authorized_keys2" >> sshdez.cfg
    echo 'KbdInteractiveAuthentication yes' >> sshdez.cfg
    echo 'X11Forwarding yes' >> sshdez.cfg
    echo 'PidFile none' >> sshdez.cfg
fi

if [ ! -d ./sshdezkeys ]; then
    mkdir sshdezkeys/
    chmod 0700 sshdezkeys
    if [ x"$ISDROID" == x"1" ]; then
        # error on termux: <<<y
        ssh-keygen -q -t rsa -N '' -f ./sshdezkeys/id_rsa # <<<y
    else
        ssh-keygen -q -t rsa -N '' -f ./sshdezkeys/id_rsa <<<y
        # ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
    fi
    # for system wide, ssh-keygen -A
    chmod 0600 sshdezkeys/*
fi
ssh-keygen -E md5 -lf ./sshdezkeys/id_rsa

set -x
if [ x"$ISDROID" == x"1" ]; then
    # error on termux: -E /dev/stderr
    # but -d will exit after one connection
    # so need a forever while here
    while true; do
        /usr/bin/sshd -Dd -e -p $PORT -f ./sshdez.cfg -h $PWD/sshdezkeys/id_rsa
        sleep 1
    done
else
    /usr/bin/sshd -D -E /dev/stdout -p $PORT -f $PWD/sshdez.cfg -h $PWD/sshdezkeys/id_rsa
fi

# todo
# Failed to allocate internet-domain X11 display socket.
# filezilla sftp error:
# FATAL ERROR: Received unexpected end-of-file from SFTP server
