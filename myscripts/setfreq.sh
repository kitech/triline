#!/bin/sh

set -x

cpufreqd-get -l
cpufreqd-set manual
cpufreqd-set 1
cpufreqd-get -l

