#!/usr/bin/env python

import sys
import os
import json
import subprocess
import functools

LOG = '/tmp/vaplay.log'
URL = sys.argv[1]
print(URL)


def convres(outlines):
    outlines = functools.reduce(lambda x, y: x + y.decode().strip(), outlines, '')
    jres = json.JSONDecoder().decode(outlines)

    return jres


def getjson(cmd):
    CMD = cmd
    print(CMD)

    ph = subprocess.Popen(CMD.split(' '), stdout=subprocess.PIPE)
    ph.wait()
    outlines = ph.stdout.readlines()
    # print(outlines)
    print(len(outlines))
    return convres(outlines)


def getinfo():
    CMD = 'you-get -i --json ' + URL
    return getjson(CMD)


def geturl(fmt):
    CMD = 'you-get -u -F {} '.format(fmt) + URL
    print(CMD)

    ph = subprocess.Popen(CMD.split(' '), stdout=subprocess.PIPE)
    ph.wait()
    outlines = ph.stdout.readlines()
    # print(outlines)
    print(len(outlines))

    title = 'unknown'
    srcs = []
    inurl = False
    for line in outlines:
        line = line.decode().strip()
        # print(line)
        if line.lower().startswith('title'):
            title = line
            continue
        if line.startswith('Real URLs'):
            inurl = True
            continue
        if inurl is True:
            srcs.append(line)

    return [srcs, title]


if __name__ == '__main__':
    info = getinfo()
    # print(info)
    streams = info['streams'].keys()
    # print(streams)
    stream = ''
    for stm in streams:
        if info['streams'][stm]['video_profile'] == '高清':
            stream = stm
            break
    print(stream)

    urls = geturl(stream)
    # print(urls)

    title = urls[1]
    srcs = urls[0]
    PCMD = ["smplayer", '-media-title', '{}: {}'.format(title, URL)] + srcs
    print(PCMD)
    subprocess.Popen(PCMD).wait()
