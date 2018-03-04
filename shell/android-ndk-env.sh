export PATH=/opt/andndk16/bin/:$PATH
export CC=/opt/andndk16/bin/arm-linux-androideabi-clang
export CXX=/opt/andndk16/bin/arm-linux-androideabi-clang++
export CPP=/opt/andndk16/bin/arm-linux-androideabi-cpp
export CXXCPP=$CPP
export AR=/opt/andndk16/bin/arm-linux-androideabi-ar
export LD=/opt/andndk16/bin/arm-linux-androideabi-ld
export RANLIB=/opt/andndk16/bin/arm-linux-androideabi-ranlib
export SYSROOT=/opt/andndk16/sysroot
export CFLAGS="-isystem ${SYSROOT}/usr/include -isystem ${SYSROOT}/usr/include/arm-linux-androideabi/ -fPIE -DANDROID -Wno-multichar -D__ANDROID_API__=16"
export CXXFLAGS=$CFLAGS
export LDFLAGS="--sysroot=${SYSROOT} -llog"
export ARCH=arm

export CGO_CFLAGS=$CFLAGS
export CGO_CXXFLAGS=$CXXFLAGS
export CGO_LDFLAGS=$LDFLAGS

# misc
# /opt/android-ndk/build/tools/make_standalone_toolchain.py --api 16 --install-dir /opt/andndk16
# ./configure --prefix=/androidsys --host=arm-linux-androideabi
