#!/bin/sh

#not work!!!

logfile=/tmp/tcc4cgo.log
cgofiles=/tmp/tcc4cgo/
mkdir -p $cgofiles

echo "#################" >> $logfile
echo "### PWD=$PWD" >> $logfile

echo "### origin" >> $logfile
echo "$@" >> $logfile


modcmdline=
lastarg=
for arg in "$@"; do
	if [ x"$arg" == x"-Qunused-arguments" ]; then
		true
	elif [ x"$arg" == x"-fno-caret-diagnostics" ]; then
		true
	elif [ x"$arg" == x"--no-gc-sections" ]; then
		true
	else
		modcmdline=" $modcmdline $arg"
		lastarg=$arg
	fi
done
echo "### moded" >> $logfile
echo $modcmdline >> $logfile

if [ -f _cgo_export.h ];then
	sed -i 's/#ifdef _MSC_VER/#define _Complex\n#ifdef _MSC_VER/' _cgo_export.h
fi
if [ -f _cgo_export.c ];then
	sed -i 's/#pragma GCC/\/\/ #pragma GCC/g' _cgo_export.c
fi
if [ -f cgo.cgo2.c ];then
	sed -i 's/#pragma GCC/\/\/ #pragma GCC/g' cgo.cgo2.c
fi
if [ -f $lastarg ]; then
	cp $lastarg $cgofiles/
	true
fi
lastarglen=${#lastarg}
lastargext=${lastarg:$lastarglen-3:3}
echo "$lastargext" >> $logfile

# it works with filter bloating arguemtn,
# but still not work for: error: _Complex is not yet supported
tccexe=`which tcc.exe`
gccexe=`which gcc`
if [ x"$lastarg" == x"gcc_libinit.c" ]; then
	$gccexe $modcmdline
	true
elif [ x"$lastarg" == x"gcc_setenv.c" ]; then
	$tccexe $modcmdline
	true
else
	echo "Running tccxxx... " >> $logfile
	# $tccexe $modcmdline
	$gccexe $modcmdline
fi
bkdret=$?
echo "$bkdret" >> $logfile
exit $bkdret
