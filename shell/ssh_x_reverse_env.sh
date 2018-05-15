export LANG=zh_CN.UTF-8
export XIM_PROGRAM=fcitx
export XIM=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DEPENDS=fcitx
export GTK_IM_MODULE=fcitx


export XINPUTRC=$HOME/.config/imsettings/xinputrc

# nohup /usr/libexec/imsettings-daemon > $HOME/imsettings-daemon.log 2>&1 &

# . $HOME/.config/imsettings/xinputrc

#XIM=fcitx
#export XIM_PROGRAM=/usr/bin/fcitx
#export ICON="/usr/share/pixmaps/fcitx.png"
#export XIM_ARGS="-D"
#export PREFERENCE_PROGRAM=/usr/bin/fcitx-configtool
#export SHORT_DESC="FCITX"
#GTK_IM_MODULE=fcitx
#if test -f /usr/lib/qt4/plugins/inputmethods/qtim-fcitx.so || \
#   test -f /usr/lib64/qt4/plugins/inputmethods/qtim-fcitx.so;
#then
#    QT_IM_MODULE=fcitx
#else
#    QT_IM_MODULE=xim
#fi


cip=$(/sbin/ss -ant|grep "10.95.96.86:22"|head -n 1|awk '{print $5}'|awk -F: '{print $1}')
# cip=$(ss -anu|grep "10.95.96.86:2222"|head -n 1|awk '{print $5}'|awk -F: '{print $1}')
# echo $cip  # TODO broken scp when terminal output

if [ -n "$SSH_TTY" ]; then
	echo "Setting reverse proxy to http://$cip:8117 ..."
fi

export http_proxy=http://$cip:8117
export https_proxy=http://$cip:8117
export HTTP_PROXY=http://$cip:8117
export HTTPS_PROXY=http://$cip:8117

export GOPATH=$HOME/work:$HOME/golib
export PATH=$HOME/work/bin:$HOME/golib/bin:$PATH

alias firefox='$HOME/firefox/firefox'
alias goland='$HOME/GoLand-173.3727.79/bin/goland.sh'
alias vscode='$HOME/VSCode-linux-x64/code'
alias eclipse='$HOME/eclipse/eclipse'
alias tb='/usr/bin/thunderbird --new-instance 2>/dev/null'
alias ideaic='$HOME/idea-IC-172.4574.11/bin/idea.sh'
alias ideaiu='$HOME/idea-IU-173.3942.27/bin/idea.sh'
alias davmd='DISPLAY= nohup ./davmail-linux-x86_64-4.8.0-2479/davmail.sh ./.davmail.properties &'
alias andstu='$HOME/android-studio/bin/studio.sh'

if [ -n "$SSH_TTY" ]; then
	env > /tmp/env_ssh.log
	/usr/bin/imsettings-switch fcitx
else
	env > /tmp/env_scp.log
fi
