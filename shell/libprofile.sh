### support bash/zsh

### ref this file
### add line to $HOME/.bash_profile
### [[ -f ~/myscripts/mybash_profile ]] && . ~/myscripts/mybash_profile

alias ls='ls --color=auto'
alias ll='ls --color=auto -l --time-style="+%Y/%m/%d %H:%I:%S"'
alias llh='ls --color=auto -lh --time-style="+%Y/%m/%d %H:%I:%S"'
alias lla='ls -a --color=auto -lh --time-style="+%Y/%m/%d %H:%I:%S"'
alias rm='rm -i'
alias ssh='ssh -CXY'
alias scu='systemctl --user'
#alias ssh=$HOME/myscripts/assh.sh
alias aria2c='aria2c -x 5 -k 1M'
alias ec='emacsclient -n'
alias ecv='emacsclient -t -c -q'    # 用于简单编辑配置文件，轻量级命令行emacs view
alias eml='emacs -nw -Q'     # 非常轻量级新的emacs实例
alias git=$HOME/triline/myscripts/egit.sh
# about X selection
alias pwdxs='pwd | xsel -p -b'
# alias pip='pip --user'   # 以普通用户安装pip包

march=$(uname -s)
mbp=$(lspci | grep FaceTime)

export PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin:$HOME/bin:$HOME/.local/bin
export PATH=$PATH:$HOME/triline/aurcare:$HOME/triline/shell:$HOME/triline/myscripts:$HOME/triline/python
export PATH=$PATH:$HOME/golib/bin:$HOME/work/bin:$HOME/oss/bin  # for other compiled go bin

if [ x"$march" == x"Darwin" ] ; then
    export PATH=$HOME/.nix-profile/bin:$PATH
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:$PATH
    export PATH=/usr/local/Cellar/binutils/2.26/x86_64-apple-darwin15.4.0/bin:$PATH
    export PATH=$(brew --prefix homebrew/php/php56)/bin:$PATH
    # export PATH=$(brew --prefix homebrew/php/php70)/bin:$PATH
    export PATH=$(brew --prefix protobuf3)/bin:$PATH
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:/usr/local/opt/findutils/libexec/gnuman:$MANPATH
    # export PYTHONPATH=$PYTHONPATH:.:/usr/local/lib/python2.7/site-packages
    # 每次重启电脑都会改变xquartz的这个环境变量
    # export DISPLAY=/private/tmp/com.apple.launchd.dmd4ii1CgP/org.macosforge.xquartz:0
    export X11_PREFS_DOMAIN=org.macosforge.xquartz.X11
    # export XAUTHORITY=$HOME/.Xauthority_share_non_lock
fi

# HiDPI
function hidpi_mode() {
    # GTK3
    export GDK_SCALE=2
    # GTK2
    # export GDK_DPI_SCALE=0.5
    # QT5
    # export QT_AUTO_SCREEN_SCALE_FACTOR=1
}

# HiDPI vars
if [ x"$mbp" != x"" ] && [ x"$march" == x"Linux" ] ; then
    hidpi_mode
fi

export GOPATH=$HOME/golib:$HOME/work:$HOME/oss
export LD_LIBRARY_PATH=$HOME/mylib:$LD_LIBRARY_PATH
export PYTHONDONTWRITEBYTECODE=1  #禁止生成.pyc

export RUBYLIB=.:$HOME/opensource/rubyjitqt/lib
export RUST_SRC_PATH=/usr/src/rust/src   # for rust-racer

export DTPXY=127.0.0.1:8117
export GIT_SSH=$HOME/triline/myscripts/socks5proxyssh
export GIT_TRACE=0
export GIT_CURL_VERBOSE=0
export HOMEBREW_GITHUB_API_TOKEN=08e4846ae157896fd404c81396af3e6a4256477a

export WINEARCH=win32
export WINEPREFIX=$HOME/.wine32
export LIBGUESTFS_PATH=$HOME/vms/appliance

JAVA_OPTS="-Xmx128M -Xms16M -Xss2M"
JAVA_HOME=/usr/lib/jvm/default
AKKA_LIB=$HOME/jars/akka-2.3.8/lib/akka
#export CLASSPATH=$AKKA_LIB/akka-actor_2.11-2.3.8.jar:$AKKA_LIB/akka-actor_2.11-2.3.8.jar:$AKKA_LIB/config-1.2.1.jar
# use -Djava.ext.dirs=...替代
JAR_EXTS=$JAVA_HOME/jre/lib/ext:$AKKA_LIB

# queueit变量
export QUEUEIT_HOST=127.0.0.1
export QUEUEIT_PORT=11300
export QUEUEIT_TIMEOUT=100
export QUEUEIT_TTR=5000


#######shity
alias youtube-dl='youtube-dl --proxy 127.0.0.1:8117'
# alias go='http_proxy=127.0.0.1:8080 go'
# 显示go get的网络流量进度
# strace -f -e trace=network go get github.com/divan/gofresh 2>&1 | pv -i 0.05 > /dev/null

function ipowerline() {
    kn=$(uname -s)
    . /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
}

### go version select
function gover_help() {
    echo "gover <list | select | download | remove | unset>"
    echo "   select <git | x.y.z>"
}

ORIGPATH=
function gover() {
    VERDIR=$HOME/govers
    cmd=$1
    arg0=$2
    if [ x"$ORIGPATH" == x"" ] ; then
        ORIGPATH=$PATH
    fi

    case $cmd in
        l|list)
            selected=
            for d in `ls $VERDIR/`; do
                if [ x"$d" == x"go" ]; then
                    echo "selected: $(basename $(realpath $VERDIR/$d))"
                else
                    echo "$d"
                fi
            done
            ;;
        s|select)
                    d=$VERDIR/go-$arg0
                    unlink $VERDIR/go
                    ln -sv go-$arg0 $VERDIR/go
                    export GOROOT=$VERDIR/go
                    export PATH=$VERDIR/go/bin:$PATH
                    ;;
                unset)
                    unset GOROOT
                    export PATH=$ORIGPATH
                    ;;
        *)
            echo 'what?'
            ;;
    esac
}
