export PATH=/opt/andndk16/bin/:$PATH
function andclang()
{
    export CC=/opt/andndk16/bin/arm-linux-androideabi-clang
    export CXX=/opt/andndk16/bin/arm-linux-androideabi-clang++
    export CPP=/opt/andndk16/bin/arm-linux-androideabi-cpp
}

function andgcc()
{
    export CC=/opt/andndk16/bin/arm-linux-androideabi-gcc
    export CXX=/opt/andndk16/bin/arm-linux-androideabi-g++
    export CPP=/opt/andndk16/bin/arm-linux-androideabi-cpp
}

#andgcc;
andclang;

export CXXCPP=$CPP
export AR=/opt/andndk16/bin/arm-linux-androideabi-ar
export LD=/opt/andndk16/bin/arm-linux-androideabi-ld
export RANLIB=/opt/andndk16/bin/arm-linux-androideabi-ranlib
export STRIP=/opt/andndk16/bin/arm-linux-androideabi-strip
export OBJDUMP=/opt/andndk16/bin/arm-linux-androideabi-objdump
export OBJCOPY=/opt/andndk16/bin/arm-linux-androideabi-objcopy

export ANDAPIVER=16
export SYSROOT=/opt/andndk16/sysroot
ltapi16=$(expr $ANDAPIVER '<=' 16)
[[ $ltapi16 = 1 ]] && ANDSTL="gnustl_shared" || ANDSTL="c++_shared"
isgcc=$(echo $CC|grep gcc)
[[ $isgcc = "" ]] && ANDTC=clang || ANDTC=gcc
echo "Using ndk $ANDAPIVER $ANDSTL $ANDTC"

export CFLAGS="-isystem ${SYSROOT}/usr/include -isystem ${SYSROOT}/usr/include/arm-linux-androideabi/ -fPIE -DANDROID -Wno-multichar -D__ANDROID_API__=$ANDAPIVER -DAPP_PLATFORM=$ANDAPIVER -DANDROID_STL=$ANDSTL -DANDROID_TOOLCHAIN=$ANDTC"
# -DANDROID_STL=c++_shared -DANDROID_TOOLCHAIN=gcc
export CXXFLAGS=$CFLAGS
export LDFLAGS="--sysroot=${SYSROOT} -llog"
export ARCH=arm

export CGO_CFLAGS=$CFLAGS
export CGO_CXXFLAGS=$CXXFLAGS
export CGO_LDFLAGS=$LDFLAGS

# misc
# /opt/android-ndk/build/tools/make_standalone_toolchain.py --api 16 --install-dir /opt/andndk16 --arch arm
# ./configure --prefix=/androidsys --host=arm-linux-androideabi
