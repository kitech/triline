
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
