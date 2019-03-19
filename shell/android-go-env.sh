export CGO_ENABLED=1
export GOOS=android
export GOARCH=arm
export GOARM=7
export CGO_LDFLAGS="$CGO_LDFLAGS -L/opt/androidsys/lib -landroid -lc"
# export CGO_CFLAGS="-D_GNU_SOURCE"
# export CGO_CFLAGS="-std=c99"
export CGO_CFLAGS="-I/opt/androidsys/include  -D__ANDROID_API__=$ANDAPIVER -D_FILE_OFFSET_BITS=64"

