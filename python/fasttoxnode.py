#!/usr/bin/env python3

import os
import json
import re
import subprocess
import math

# TODO 自动下载节点列表文件
# https://nodes.tox.chat/json

file="toxnodes.json"
fp = os.open(file, os.O_RDONLY)
sz = os.path.getsize(file)

print("file info:", file, sz)

jcc = os.read(fp, sz)
print("file content info:", len(jcc), jcc[0:16])

joo = json.JSONDecoder().decode(jcc.decode())
print("total nodes:", len(joo['nodes']))

# TODO 使用ping库实现该功能
def ping(ip):
    times = 3
    cmd = ['ping', '-t', str(times), ip]
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    outs = proc.stdout.readlines()
    # print(outs)

    tsv = []
    for line in outs:
        line = line.decode()
        # print(line.strip())
        mats = re.match('\d+ bytes from .*: icmp_seq=\d+ ttl=\d+ time=([.0-9]+) ms', line)

        if mats is not None:
            # print(mats, mats.group(1))
            tsv.append(float(mats.group(1)))

    if len(tsv) > 0:
        avg = sum(tsv)/len(tsv)
        print(ip, avg)
        return avg
    else:
        return 888888888888


no = 0
pvs = []
for node in joo['nodes']:
    print("\n", no, node['ipv4'], node['ipv6'])
    pv = ping(node['ipv4'])
    pvs.append({'ip': node['ipv4'], 'pv': pv})
    no += 1
    if no > 55: break

print(pvs)
def cmpfn(a, b):
    return a['pv'] < b['pv']
def keyfn(a):
    return a['pv']

pvs2 = sorted(pvs, key=keyfn)
print(pvs2)
