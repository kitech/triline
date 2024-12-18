#!/bin/sh

ofpath=$0
ofname=$(basename $ofpath)
mydir=$(dirname $(realpath $0))

export GOFLAGS=-buildvcs=false
export CGO_CFLAGS="-g -O0 ${CGO_CFLAGS}"
export CGO_CXXFLAGS="$CGO_CFLAGS ${CGO_CXXFLAGS}"
#export CGO_LDFLAGS="-linkmode external -extld clang -extldflags -fuse-ld=mold"

logfile=/tmp/golog
# clear log
#cp /tmp/golog /tmp/golog.bak
#echo > /tmp/golog

# seperator log
echo >> /tmp/golog
echo "=======================: $ofname $@" >> /tmp/golog

# logging
toolexec="$mydir/gobverbose.sh"
# no linking
if [ x"$ofname" == x"gosyxchk.sh" ]; then
    toolexec="$mydir/gobnold.sh"
    echo "link skipped for $ofname" >> /tmp/golog
fi

# for small project, flags0 = flags2 > flags3 > flags1
goldflags0=""
goldflags1="-linkmode external -extld clang -extldflags -fuse-ld=mold"
goldflags2="-linkmode external -extld clang"
# tcc link works!!!
goldflags3="-linkmode external -extld tcc.exe -extldflags -L/myhome/bprog/vlang/thirdparty/tcc/lib/tcc/"
goldflags=$goldflags0
set -x

go build -debug-actiongraph=compile.json -toolexec=$toolexec -ldflags "$goldflags"  "$@"

# actiongraph top < compile.json

