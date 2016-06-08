
if [ "$EUID" = "0" ] || [ "USER" = "root" ] ; then
   echo "%e.%t.P%p.core" > /proc/sys/kernel/core_pattern
fi

#export LS_COLORS="--color"
# why this alias usable for root
alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias dir='dir --color=auto'
export EDITOR=/usr/bin/vim

export XMODIFIERS="@im=fcitx"
export XIM="fcitx"
export XIM_PROGRAM="fcitx"
export XIM_ARGS=""
#export GTK_IM_MODULE=XIM
#export QT_IM_MODULE=XIM
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export DEPENDS="fcitx"


# export XAUTHORITY=/tmp/.Xauthority-r
if [ "$EUID" = "0" ] || [ "USER" = "root" ] ; then
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        export LC_CTYPE=en_US.UTF-8
	#export XAUTHORITY=/tmp/.Xauthority-r0
else
        export LANG=zh_CN.UTF-8
        export LC_ALL=zh_CN.UTF-8
        export LC_CTYPE=zh_CN.UTF-8
	#export XAUTHORITY=/tmp/.Xauthority-r
fi
#export LDFLAGS=-lgomp


export ORACLE_HOME=/opt/instantclient
export TNS_ADMIN=/home/gzleo/

#ulimit -n 20000
ulimit -c unlimited
# ulimit -p 32
