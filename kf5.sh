
### note: https://bbs.archlinux.org/viewtopic.php?id=164647

export KF5=/opt/kf5
export QTDIR=/opt/qt-git
export XDG_DATA_DIRS=$KF5/share:$XDG_DATA_DIRS
export XDG_CONFIG_DIRS=$KF5/etc/xdg
export PATH=$KF5/bin:$QTDIR/bin:$PATH
export LD_LIBRARY_PATH=$KF5/lib:$QTDIR/lib
export QT_PLUGIN_PATH=$KF5/lib/plugins:$QTDIR/plugins
export QML2_IMPORT_PATH=$KF5/lib/qml:$QTDIR/qml
export XDG_DATA_HOME=$HOME/.local5
export XDG_CONFIG_HOME=$HOME/.config5
export XDG_CACHE_HOME=$HOME/.cache5
kdeinit5
plasma-shell


