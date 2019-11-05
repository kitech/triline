#!/bin/sh

SOCK=/tmp/tmux-restop
tmux -S $SOCK kill-server

tmux -S $SOCK new-session -d -s 0 'top -c -o %MEM'
tmux -S $SOCK list-windows -a
tmux -S $SOCK list-panes -t 0
tmux -S $SOCK select-window -t 0
tmux -S $SOCK split-window -t 0 -p 30 -v 'sudo nethogs'
tmux -S $SOCK split-window -t 0 -p 20 -v 'sudo iotop -d 3'

tmux -S $SOCK list-windows -a
tmux -S $SOCK list-panes -t 0

#tmux -S $SOCK run-shell -b -t 0 "sh -c 'top -u root'"

# exec tmux -S $SOCK attach-session -t 0
exec xterm -u8 -geometry 110x50  -xrm 'XTerm*selectToClipboard:true' -bg black -fg green3 \
     -e "tmux -S $SOCK attach-session -t 0"
# xterm -u8 -maximized
# xterm -u8 -geometry 110x50 -fn 10x20 -xrm 'XTerm*selectToClipboard:true' -bg black -fg green -fg  green/lightblue/lightgray

