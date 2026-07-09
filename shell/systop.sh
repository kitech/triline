#!/bin/sh

myexe=$0
mypid=$$ # or $BASHPID
parpid=$2
export LC_ALL=en_US.UTF-8
export LC_LANG=en_US.UTF-8

# set -x

# shit processes like some pls
# usage1: proccess_monitor_oom &
# usage2: systop.sh pkoom
function process_monitor_oom() {
    totoomcnt=0
    while true; do
		# opencode 1G not enough
        lines=$(ps xu | grep -E '(zed-editor|gopls|vls|v-analyzer|rust-analyzer|clangd|electron3|xfsettingsd)' | grep -v "grep -E")
        oomproccnt=0
        nearlycnt=0
        totmem=0
        while IFS= read -r line; do
            # echo "... $line ..."
            memname=$(echo "$line" | awk '{print $2 " " $6 " " $11}')
            pid=$(echo "$line" | awk '{print $2}')
            mem=$(echo "$line" | awk '{print $6}')
            # echo "$memname"
            totmem=$(($mem + $totmem))
            if [[ "$mem" -gt "1000000" ]]; then
                echo "$memname KB"
                kill -9 "$pid"
                oomproccnt=$(($oomproccnt + 1))
                totoomcnt=$(($totoomcnt + 1))
            elif [[ "$mem" -gt "500000" ]]; then
                echo "nearly $memname KB"
                nearlycnt=$(($nearlycnt + 1))
            else
                true
            fi
        done <<< "$lines"
        linecnt=$(echo "$lines"|cat|wc -l)
        totmemkb=$(expr $totmem / 1)
        echo "checked $linecnt, oomed $oomproccnt, nearly $nearlycnt, totmem $totmemkb KB totoomcnt $totoomcnt @$(date)"

        # check parent process exists
        # kill -s 0 $pid will return success if $pid is running
        parexists=$(ps -p $parpid|wc -l)
        echo "parexists $parexists, pid $parpid"
        if [ x"$parexists" = x"1" ]; then
            echo "parexists gone, exit"
            break
        fi
        sleep 3
    done
    echo "stopped"
    exit
}

if [ x"$1" == x"pkoom" ] ;then
    process_monitor_oom
    exit
fi

### tui part

SOCK=/tmp/tmux-restop
tmux -S $SOCK kill-server
tmux -S $SOCK kill-server

tmux -S $SOCK new-session -d -s 0 'top -c -o %MEM'
tmux -S $SOCK list-windows -a
tmux -S $SOCK list-panes -t 0
tmux -S $SOCK select-window -t 0
tmux -S $SOCK split-window -t 0 -p 3 -v "$myexe pkoom $mypid"
tmux -S $SOCK split-window -t 0 -p 30 -v 'nethogs'
tmux -S $SOCK split-window -t 0 -p 20 -v 'sudo iotop -d 3'

# todo nvtop???

tmux -S $SOCK list-windows -a
tmux -S $SOCK list-panes -t 0

#tmux -S $SOCK run-shell -b -t 0 "sh -c 'top -u root'"

# exec tmux -S $SOCK attach-session -t 0
exec xterm -u8 -geometry 120x54  -xrm 'XTerm*selectToClipboard:true' -bg black -fg green3 -T 'sysmon.top.iotop.nethogs' \
     -e "tmux -S $SOCK attach-session -t 0"
# xterm -u8 -maximized
# xterm -u8 -geometry 110x50 -fn 10x20 -xrm 'XTerm*selectToClipboard:true' -bg black -fg green -fg  green/lightblue/lightgray
# -fs 8 -fa 'Source Code Pro'

# todo alacritty
