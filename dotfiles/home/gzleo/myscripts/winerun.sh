#!/bin/sh

# manager wine's programs, like qq, IE, etc...
# for wine programs which installed by winetricks-zh/winetricks.
# usage:
#     winerun.sh <clean|verbname>
#     verbnames:qqintl,TM2013P2,qqlight,qq...
#     more verb names: $HOME/opensource/winetricks-zh/verb/

### env
export WINEARCH=win32
export WINEPREFIX=$HOME/.wine32

### confgs
WTPREFIX=$HOME/.local/share/wineprefixes

### cmd arguments
act=$1

### simple wrapper functions
function cleanup_wine_programs()
{
    ### sufix .exe process
    ### like qq, meitu, etc...
    true

    pids=$(ps axu|grep "\.exe"|grep "C:"|awk '{print $2}')
    echo $pids
    if [ x"$pids" != x"" ] ; then
        for pid in $pids ; do
            true;
            kill -9 $pid;
            kill -9 $pid;
            kill -9 $pid;
        done
    fi

    pids=$(ps aux|grep "defunct"|grep -v grep|awk '{print $2}')
    echo $pids
    if [ x"$pids" != x"" ] ; then
        for pid in $pids ; do
            true;
            kill -9 $pid;
            kill -9 $pid;
            kill -9 $pid;
        done
    fi
}

function cleanup_wine_process()
{
    set -x;
    cleanup_wine_programs;

    ########
    killall -9 TXPlatform.exe
    killall -9 QQ.exe
    killall -9 MLogin

    killall -9 winedevice.exe
    killall -9 services.exe
    killall -9 msiexec.exe
    killall -9 plugplay.exe
    killall -9 explorer.exe
    killall -9 rpcss.exe
    killall rundll32.exe
    killall RunDll32.exe

    killall -9 wineserver
    set +x;
}


function runverb_qqintl()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/qqintl
    wine "C:/Program Files/Tencent/QQIntl/Bin/QQ.exe"
}

function runverb_TM2013P2()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/TM2013P2
    wine "C:/Program Files/Tencent/TM/Bin/TM.exe"
}

function runverb_qqlight()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/qqlight
    wine "C:/Program Files/Tencent/QQ/Bin/QQ.exe"
}

function runverb_qq()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/qq
    wine "C:/Program Files/Tencent/QQ/Bin/QQ.exe"
}

function runverb_weixin()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/qq
    wine "C:/Program Files/Tencent/WeChat/WeChat.exe"
}

function runverb_meitu()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/meitu
    wine "C:/Program Files/Meitu/XiuXiu/XiuXiu.exe"
}

function runverb_edraw()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/meitu
    wine "C:/abc/edraw.exe"
}

function runverb_THS()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/THS
    wine "C:/Program Files/Meitu/XiuXiu/XiuXiu.exe"
}

function runverb_QQGame()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/QQGame
    wine "C:/Program Files/Tencent/QQGame/QQGame.exe"
}

function runverb_evernote()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/evernote
    wine "C:/Program Files/Evernote/Evernote/Evernote.exe"
}

function runverb_ynote()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/ynote
    wine "C:/Program Files/Youdao/YoudaoNote/YoudaoNote.exe"
}

### main
if [ x"$act" == x"" ] ; then
    echo "Need least one argument";
elif [ x"$act" == x"clean" ] ; then
    cleanup_wine_process;
else
    fn="runverb_${act}";
    echo $fn;
    
    if [ x"$act" == x"qqintl" ] ; then
        runverb_qqintl;
    elif [ x"$act" == x"TM2013P2" ] ; then
        runverb_TM2013P2;
    elif [ x"$act" == x"qqlight" ] ; then
        runverb_qqlight;
    elif [ x"$act" == x"qq" ] ; then
        runverb_qq;
    elif [ x"$act" == x"weixin" ] ; then
        runverb_weixin;
    elif [ x"$act" == x"meitu" ] ; then
        runverb_meitu;
    elif [ x"$act" == x"edraw" ] ; then
        runverb_edraw;
    elif [ x"$act" == x"THS" ] ; then
        runverb_THS;
    elif [ x"$act" == x"QQGame" ] ; then
        runverb_QQGame;
    elif [ x"$act" == x"evernote" ] ; then
        runverb_evernote;
    elif [ x"$act" == x"ynote" ] ; then
        runverb_ynote;
    else
        echo "Not impled: $act";
    fi
fi

exit;




