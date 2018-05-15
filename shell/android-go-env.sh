export CGO_ENABLED=1
export GOOS=android
export GOARCH=arm
export GOARM=7
export CGO_LDFLAGS="$CGO_LDFLAGS -L/androidsys/lib -landroid -lc"
# export CGO_CFLAGS="-D_GNU_SOURCE"
# export CGO_CFLAGS="-std=c99"
export CGO_CFLAGS="-I/androidsys/include  -D__ANDROID_API__=16 -D_FILE_OFFSET_BITS=64"

