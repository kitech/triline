#!/usr/bin/env python3

# search/install golang package by go-search.org
# like minimal pip


import sys
import os
import json
import urllib.parse
import requests
import argparse


API_URL = 'http://go-search.org/api'


class GoSearch:
    def __init__(self):
        return

    def search(self, keyword):
        # keyword = sys.argv[1]
        keyword = urllib.parse.quote(keyword, safe='')

        requrl = self.get_search_url('search', keyword)
        print('searching...', requrl)
        resp = requests.get(requrl)
        print(resp)
        print(resp.encoding)
        # print(resp.content)
        jccs = json.JSONDecoder().decode(resp.content.decode())

        hits = []
        cnt = 0
        for rec in jccs['hits']:
            # print(rec['name'], '=', rec['author'], '=', rec['package'])
            installed = '[installed]' if self.installed(rec['package']) else ''
            print('{} {} {}'.format(rec['name'], installed, rec['package']))
            print('    ', rec['synopsis'][0:80])
            cnt += 1
            hits.append(rec)
            if cnt > 10: break

        return hits

    def install(self, keyword):
        hits = self.search(keyword)
        if len(hits) > 0:
            rec = hits[0]
            print('installing...', keyword, rec['package'])
            import subprocess
            args = ['/usr/bin/go', 'get', '-v', '-u', rec['package']]
            print('>', ' '.join(args))
            ph = subprocess.Popen(args)
            ph.wait()
        return

    def info(self, keyword):
        return

    def package(self):
        return

    def packages(self):
        return

    def tops(self):
        return

    def get_search_url(self, action, keyword):
        # http://go-search.org/api?action=search&q=gcse
        return '{}?action={}&q={}'.format(API_URL, action, keyword)

    def installed(self, pkgpath):
        return False


#####
gose = GoSearch()


def handler_search(args):
    print(args, args.func, args.pkgname)
    gose.search(args.pkgname)
    return


def handler_install(args):
    print(args)
    gose.install(args.pkgname)
    return

parser = argparse.ArgumentParser('gose')
subparsers = parser.add_subparsers()
parser_search = subparsers.add_parser('search', help='search help')
parser_search.add_argument('pkgname', help='golang package name. like php-go')
parser_search.set_defaults(func=handler_search)
parser_install = subparsers.add_parser('install', help='install help')
parser_install.add_argument('pkgname', help='golang package name. like php-go')
parser_install.set_defaults(func=handler_install)
pr = parser.parse_args()

# print(pr._get_kwargs())
# print(pr._get_args())
# print(pr)

if len(pr._get_kwargs()) > 0:
    pr.func(pr)
else:
    parser.print_help()

