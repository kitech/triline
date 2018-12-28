#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. $HOME/.bash_profile

export WINEARCH=win32
export WINEPREFIX=$HOME/.wine32

eval $(thefuck --alias ohfuck)

unset http_proxy https_proxy ftp_proxy socks_proxy
export http_proxy_=''
export https_proxy_=''
export ftp_proxy_=''
export socks_proxy_=''
