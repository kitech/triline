
# c preprocess, macro expend

if [ x"$CC" == x"" ]; then
    export CC=tcc.exe
fi

set -x
VROOT=$(dirname $(realpath $(which v)))
TCCDIR=$VROOT/thirdparty/tcc/lib/tcc
# exit
$CC -E $1 -I ~/aprog/cygo/corona-c -I ~/aprog/cygo/src -I ~/aprog/cygo/3rdparty -I ~/aprog/cygo/3rdparty/cltc/src -I ~/aprog/cygo/3rdparty/cltc/src/include  -I /opt/vcpkg/installed/x64-linux/include -I $TCCDIR/include
