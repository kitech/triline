# a little make lib

TCROOT=/opt/android-ndk/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
SYSROOT=/opt/android-ndk/platforms/android-21/arch-arm

export CC=$(TCROOT)/bin/arm-linux-androideabi-gcc
export CXX=$(TCROOT)/bin/arm-linux-androideabi-g++
export LD=$(TCROOT)/bin/arm-linux-androideabi-ld
export AS=$(TCROOT)/bin/arm-linux-androideabi-as
export AR=$(TCROOT)/bin/arm-linux-androideabi-ar
export RANLIB=$(TCROOT)/bin/arm-linux-androideabi-ranlib

ANDROID_SYSROOT=$(SYSROOT)
export CGO_LDFLAGS=-L$(ANDROID_SYSROOT)/usr/lib --sysroot=$(ANDROID_SYSROOT)
export CGO_CFLAGS=-I$(ANDROID_SYSROOT)/usr/include
export CFLAGS=$(CGO_CFLAGS)
export LDFLAGS=$(CGO_LDFLAGS)

export GOOS=android
export GOARCH=arm
export GOARM=7
export CGO_ENABLED=1

# usage:
# In Makefile header:
# include /path/to/cgodroid.make
# all:
#     go build -v foo.go
# $(CC) --sysroot=$(ANDROID_SYSROOT) -L$(ANDROID_SYSROOT)/usr/lib   -I$(ANDROID_SYSROOT)/usr/include a.c -pie
