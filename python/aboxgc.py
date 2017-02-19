#!/usr/bin/env python

import os
import sys
import subprocess


# TODO some dir need reserved
gcfiles = """
~/.cache/vivaldi-snapshot/Default/Cache/
~/.ccache/
~/.cache/mozilla/firefox/rsuh84fl.default/cache2/entries/
~/.meow/cow.log
~/.cache/winetricks
/var/spool/postfix/maildrop/
/var/lib/sddm/.cache/
/var/cache/lxc/download/
/var/lib/texmf/web2c
"""

home = os.getenv('HOME')
if home == '' or len(home) <= len('/home/'):
    print('Invalid home:', home)
    exit(-1)

# print(gcfiles)
vec = gcfiles.strip().split('\n')
for f in vec:
    f = f.strip()
    if f == '': raise 'wtf: ' + f
    if len(f) <= 3: raise 'wtf: ' + f

    # print(f)
    if f.startswith('/'): rootsys = True
    else: rootsys = False

    # some transform
    if f.startswith('~/'): f = home + f[1:]

    if not os.path.exists(f):
        print('not exists:', f)
        continue

    # print(f)
    ducmd = ['du', '-hs', f]
    if rootsys: ducmd = ['sudo'] + ducmd
    r = subprocess.Popen(ducmd, stdout=subprocess.PIPE)
    r.wait()
    print(r.returncode, r.stdout.read().decode().strip())
    print('cleaning...', f)
    cleancmd = ['rm', '-rf', f]
    if rootsys: cleancmd = ['sudo'] + cleancmd
    r = subprocess.Popen(cleancmd)
    r.wait()
    if r.returncode == 0: print('clean done. ok:', f)
    else: print('clean done. failed:', f)
