#!/bin/sh

cmd=$1
shift # 弹出参数列表左边第一个

while true; do
    $cmd "$@"
    sleep 2
done
