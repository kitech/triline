#!/bin/sh

set -x 



route -v  add  -net 172.24.0.0/16 eth0
route -v  add  -net 202.108.12.0/24 eth0
route -v  add  -net 202.108.15.0/24 eth0
route -v  add  -net 211.100.41.0/24 eth0

