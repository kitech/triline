
nosseavx="-no-sse3 -no-ssse3 -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 -no-avx512"

# qt4 static, only core/gui/network
# mkspec/common/gcc-base.conf: -O2 => -Os
export QMAKE_DEFAULT_LIBDIRS=/usr/lib32
export LDFLAGS="-m32"
../qt-everywhere-opensource-src-4.8.7/configure -platform linux-g++-32 -static -prefix /opt/qt4stmin -release -fast -opensource -confirm-license -v -no-glib -no-opengl -no-dbus -no-cups -no-webkit -no-declarative -no-scripttools -no-script -no-javascript-jit -no-svg -no-phonon -no-multimedia -no-audio-backend -no-sql-psql -no-sql-mysql -no-sql-odbc -no-openssl -no-qt3support -no-xmlpatterns -no-openvg -no-sm -no-exceptions -no-stl -no-mitshm -qt-zlib -qt-libjpeg -qt-libpng -qt-libmng -qt-libtiff -make "libs"

exit

# qt5.9 static, only core/gui/widgets/network
skips=$(ls -l ../qt-everywhere-src-5.12.3/|grep "^d"|grep -v coin | grep -v gnuwin32 | grep -v qtbase | grep -v qtdoc | grep -v qttranslations | awk '{print "-skip " $9}')
nofeats="accessibility concurrent calendarwidget datawidgetmapper filesystemiterator filesystemwatcher fscompleter http ftp printdialog printpreviewwidget colordialog printpreviewdialog  mdiarea wizard statemachine gestures regularexpression whatsthis dirmodel filesystemmodel settings sqlmodel splashscreen tuiotouch"
strnofeats=""
for feat in $nofeats; do strnofeats="$strnofeats -no-feature-$feat"; done

#  -recheck-all
# -ltcg seem have some problem
export PKG_CONFIG_PATH=/usr/lib32/pkgconfig
export QMAKE_DEFAULT_LIBDIRS=/usr/lib32
../qt-everywhere-src-5.12.3/configure -recheck-all -platform linux-g++-32 -pkg-config -prefix /opt/qt512stmin -static -optimize-size -release -strip -reduce-relocations -opensource -confirm-license -v -c++std c++11 -no-glib -no-linuxfb -no-openssl -no-dbus -no-cups -no-xcb -no-sm -no-opengl -no-sql-psql -no-sql-mysql -no-sql-odbc -no-sql-ibase -no-sql-tds -nomake tools -nomake tests -nomake examples -qt-zlib -qt-libjpeg -qt-libpng -qt-xcb -qt-pcre -qt-harfbuzz $skips $strnofeats

# qt static build can reduce memory usage? yes
# reduce file size: -Os -mpreferred-stack-boundary=2 -finline-small-functions -momit-leaf-frame-pointer
# http://web.archive.org/web/20161222125623/http://www.formortals.com/build-qt-static-small-microsoft-intel-gcc-compiler/
# https://blog.qt.io/blog/2019/01/02/qt-applications-lto/

