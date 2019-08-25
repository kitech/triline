#!/bin/sh


DISPLAY=:0 ./cvtier -config ./cvtier.ini -bs-group cn -disable-udp inone >cvtier.log 2>&1 &

