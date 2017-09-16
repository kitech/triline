#!/bin/sh

# 保持连接不断线，30min
TIMEOUT=60; while true; do date; sleep $TIMEOUT; done

# 查看多个LOG文件
tail -f log/{DEBUG,INFO,WARNING,ERROR,FATAL,run}.log
