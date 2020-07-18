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

### for confgs
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

function runclean_qq()
{
    killall -9 TXPlatform.exe
    killall -9 QQ.exe
    killall -9 QQApp.exe
    killall -9 QQProtect.exe
    killall -9 Tencentdl.exe
    killall -9 QQExternal.exe
    killall -9 bugreport
}

function runverb_weixin()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/weixin
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
    # wine "C:/users/gzleo/Local Settings/Application Data/Apps/Evernote/Evernote/Evernote.exe"
}

function runclean_evernote()
{
    killall -9 EvernoteClipper.exe
    killall -9 Evernote.exe
    killall -9 EvernoteTray.exe
}

function runverb_ynote()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/youdaonote
    wine "C:/Program Files/Youdao/YoudaoNote/YoudaoNote.exe"
}

function runverb_wechat()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/wechat
    wine "C:/Program Files/Tencent/WeChat/WeChat.exe"
}

function runclean_wechat()
{
    killall -9 WeChat.exe
}

function runverb_dingtalk()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/dingtalk
    wine "C:/Program Files/DingDing/main/current/DingTalk.exe"
}

function runclean_dingtalk()
{
    killall -9 DingTalk.exe
    killall -9 DingTalkHelper.exe
    killall -9 DingTalkUpdater.exe
}

function runverb_youku()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/youku
    wine "C:/Program Files/YouKu/YoukuClient/YoukuDesktop.exe"
}

function runclean_youku()
{
    killall -9 YoukuDesktop.exe
}

function runverb_iqiyi()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/iqiyi
    wine "C:/Program Files/IQIYI Video/PStyle/QiyiClient.exe"
}

function runclean_iqiyi()
{
    killall -9 QyClient.exe
    killall -9 QyService.exe
    killall -9 QyPlayer.exe
    killall -9 QyFragment.exe
    killall -9 QyKernel.exe
    killall -9 mDNSResponder.exe
}

function runverb_hdsql()
{
    export WINEARCH=win64 # for heidisql 10.2+
    export WINEPREFIX=$HOME/.local/share/wineprefixes/heidisql
    #wine "C:/Program Files/HeidiSQL/heidisql.exe"
    /usr/bin/heidisql # from aur heidisql
}

function runclean_hdsql()
{
    killall -9 heidisql.exe
}

function runverb_thunder5()
{
    #/opt/deepinwine/apps/Deepin-ThunderSpeed/run.sh
    export WINEPREFIX=$HOME/.deepinwine/Deepin-ThunderSpeed
    #wine "C:/Program Files/Thunder Network/Thunder/Thunder.exe"
    wine "C:/Program Files/Thunder/Thunder.exe"
}

function runclean_thunder5()
{
    killall -9 Thunder.exe
    killall -9 ThunderPreload.exe
    killall -9 KKV.exe
}

function runverb_thunderx()
{
    #/opt/deepinwine/apps/Deepin-ThunderSpeed/run.sh
    export WINEPREFIX=$HOME/.deepinwine/Deepin-ThunderSpeed.o
    wine "C:/Program Files/Thunder Network/Thunder/Program/Thunder.exe"
}

function runclean_thunderx()
{
    killall -9 Thunder.exe
    killall -9 ThunderPreload.exe
    killall -9 KKV.exe
}

function runverb_si3()
{
    export WINEPREFIX=$HOME/.local/share/wineprefixes/directinstalled
    wine "C:/Program Files/Source Insight 3/Insight3.exe"
}

function runclean_si3()
{
    killall -9 Insight3.exe
}

function runverb_list()
{
    lst="qqintl TM2013P2 qqlight qq weixin meitu edraw THS QQGame evernote ynote"
    nlst=$(echo $lst|wc -w)
    echo "wine verb list: ($nlst)"
    idx=0
    for verb in $lst; do
        idx=$(expr $idx + 1)
        echo -e "\t${idx}.\t${verb}"
    done
}

### main
if [ x"$act" == x"" ] ; then
    echo "Need least one argument";
elif [ x"$act" == x"clean" ] ; then
    verb=$2
    case $verb in
        'qq')
            runclean_qq;
        ;;
        'evernote')
            runclean_evernote;
        ;;
        'wechat')
            runclean_wechat;
        ;;
        'dingtalk')
            runclean_dingtalk;
        ;;
        'iqiyi')
            runclean_iqiyi;
            ;;
        'hdsql')
            runclean_hdsql;
            ;;
        'thunder5')
            runclean_thunder5;
            ;;
        'thunderx')
            runclean_thunderx;
            ;;
        *)
            read -p "Are you sure clean all verbs? (Y/N): " agree
            if [ x"$agree" == x"Y" ] || [ x"$agree" == x'y' ] ; then
                cleanup_wine_process;
            else
                echo "Usage:"
                echo -e "\twinerun clean [verb]"
            fi
        ;;
    esac

else
    fn="runverb_${act}";
    echo "runing ${fn}...";

    # TODO use case expression
    if [ x"$act" == x"list" ] ; then
        runverb_list;
    elif [ x"$act" == x"qqintl" ] ; then
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
    elif [ x"$act" == x"wechat" ] ; then
        runverb_wechat;
    elif [ x"$act" == x"dingtalk" ] ; then
        runverb_dingtalk;
    elif [ x"$act" == x"youku" ] ; then
        runverb_youku;
    elif [ x"$act" == x"iqiyi" ] ; then
        runverb_iqiyi;
    elif [ x"$act" == x"hdsql" ]; then
        runverb_hdsql;
    elif [ x"$act" == x"thunder5" ]; then
        runverb_thunder5;
    elif [ x"$act" == x"thunderx" ]; then
        runverb_thunderx;
    elif [ x"$act" == x"si3" ]; then
        runverb_si3;
    else
        echo "Not impled: $act";
    fi
fi

# exit;




