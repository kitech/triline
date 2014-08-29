#!/bin/sh

####### 0-11位数字
rand_by_date=$(date +%N)

### 0-99999
rand_by_env=$(echo $RANDOM)


###### 
rand_by_urandom=$(head -50 /dev/urandom | cksum)

#######
rand_by_uuid=$(cat /proc/sys/kernel/random/uuid)


#######
rand_by_mktemp=${$(mktemp -u):9}
rand_by_mktemp=${rand_by_mktemp:9}

echo "rand_by_date: ${rand_by_date}"

echo "rand_by_env: ${rand_by_env}"

echo "rand_by_random: ${rand_by_urandom}"

echo "rand_by_uuid: ${rand_by_uuid}"

echo "rand_by_tmpn: ${rand_by_mktemp}"
