#!/usr/bin/python2
# encoding: utf8

import os
import sys
import pwd
from pkg_resources import load_entry_point
import logging
import re

# EASY-INSTALL-ENTRY-SCRIPT: 'mitmproxy>=0.13','console_scripts','mitmdump'
__requires__ = 'mitmproxy>=0.13, execjs, argparse'

######################
import pkgutil
import urlparse
import json
import logging
from argparse import ArgumentParser

# __all__ = ['main']


def parse_args():
    parser = ArgumentParser()
    parser.add_argument('-i', '--input', dest='input', required=True,
                      help='path to gfwlist', metavar='GFWLIST')
    parser.add_argument('-f', '--file', dest='output', required=True,
                      help='path to output pac', metavar='PAC')
    parser.add_argument('-p', '--proxy', dest='proxy', required=True,
                        help='the proxy parameter in the pac file, for example,\
                        "SOCKS5 127.0.0.1:1080;"', metavar='PROXY')
    return parser.parse_args()


def decode_gfwlist(content):
    # decode base64 if have to
    try:
        return content.decode('base64')
    except:
        return content


def get_hostname(something):
    try:
        # quite enough for GFW
        if not something.startswith('http:'):
            something = 'http://' + something
        r = urlparse.urlparse(something)
        return r.hostname
    except Exception as e:
        logging.error(e) 
        return None


def add_domain_to_set(s, something):
    hostname = get_hostname(something)
    if hostname is not None:
        if hostname.startswith('.'):
            hostname = hostname.lstrip('.')
        if hostname.endswith('/'):
            hostname = hostname.rstrip('/')
        if hostname:
            s.add(hostname)


def parse_gfwlist(content):
    # builtin_rules = pkgutil.get_data('gfwlist2pac', 'resources/builtin.txt').splitlines(False)
    builtin_rules = """
google.com
google.co.jp
google.co.hk
google.com.hk
github.com
wikipedia.org
akamaihd.net
add-more-domains-below.org
githubusercontent.com
githubapp.com
mozilla.org
mozilla.net
zulip.org
vim-cn.com
mitmproxy.org
pushbullet.com
blogspot.com
travis-ci.org
travis-ci.com
docker.com
msecnd.net
    """
    builtin_rules = builtin_rules.split('\n')

    gfwlist = content.splitlines(False)
    domains = set(builtin_rules)
    for line in gfwlist:
        if line.find('.*') >= 0:
            continue
        elif line.find('*') >= 0:
            line = line.replace('*', '/')
        if line.startswith('!'):
            continue
        elif line.startswith('['):
            continue
        elif line.startswith('@'):
            # ignore white list
            continue
        elif line.startswith('||'):
            add_domain_to_set(domains, line.lstrip('||'))
        elif line.startswith('|'):
            add_domain_to_set(domains, line.lstrip('|'))
        elif line.startswith('.'):
            add_domain_to_set(domains, line.lstrip('.'))
        else:
            add_domain_to_set(domains, line)
    # TODO: reduce ['www.google.com', 'google.com'] to ['google.com']
    return domains


def generate_pac(domains, proxy):
    # render the pac file
    # proxy_content = pkgutil.get_data('gfwlist2pac', 'resources/proxy.pac')
    proxy_content = """
var domains = __DOMAINS__;
var proxy = __PROXY__;
var direct = 'DIRECT;';
function FindProxyForURL(url, host) {
    var lastPos = 0;
    var domain = host;
    while(lastPos >= 0) {
        if (domains[domain]) {
            return proxy;
        }
        lastPos = host.indexOf('.', lastPos + 1);
        domain = host.slice(lastPos + 1);
    }
    return direct;
}
    """

    domains_dict = {}
    for domain in domains:
        domains_dict[domain] = 1
    proxy_content = proxy_content.replace('__PROXY__', json.dumps(str(proxy)))
    proxy_content = proxy_content.replace('__DOMAINS__', json.dumps(domains_dict, indent=2))
    return proxy_content


def gfwlist2pac():
    args = parse_args()
    with open(args.input, 'rb') as f:
        content = f.read()
    content = decode_gfwlist(content)
    domains = parse_gfwlist(content)
    domains
    pac_content = generate_pac(domains, args.proxy)
    return pac_content
    # with open(args.output, 'wb') as f:
    #    f.write(pac_content)
    return


def main_gfwlist2pac():
    myuid = os.getuid()
    mypwuid = pwd.getpwuid(myuid)
    myhome = os.getenv('HOME')
    if myhome is None: myhome = '/home/' + mypwuid.pw_name

    input = myhome + '/tmp/gfwlist.txt'
    output = myhome + '/tmp/gfwlist.pac'
    handby_args = ['--input', input, '--file', output, '--proxy', '127.0.0.1:8117', ]

    old_argv = sys.argv
    sys.argv = [sys.argv[0]]
    sys.argv += handby_args
    logging.debug(str(sys.argv))

    pac_content = gfwlist2pac()
    # print(pac_content)

    sys.argv = old_argv
    return pac_content


#######################################
import execjs
jsrt = None
jsctx = None
jsinitcnt = 0

# fixed by https://github.com/mitmproxy/mitmproxy/issues/745
htst_or_cert_pin_domains = [
    'vim-cn.com',
]


def initialize_javascript_runtime():
    global jsrt, jsctx, jsinitcnt
    pac_content = main_gfwlist2pac()
    jsrts = execjs.available_runtimes()
    logging.debug(str(jsrts.keys()))  # [u'Node', u'SpiderMonkey', u'Spidermonkey']
    # SpiderMonkey 引擎比Node引擎用内存与CPU资源少，速度更快。
    # 在archlinux上是包会自动使用js185，js包和js17包都不认。
    # 好像有很严重的内存泄漏
    # 内存问题好像不是出在execjs上的，而是mitmproxy本身就有问题
    # https://github.com/mitmproxy/mitmproxy/issues/620
    # 如果这有真有内存问题的话，可以考虑试用pacparser包。
    jsrt = execjs.get('SpiderMonkey')
    # jsrt = execjs.get('Node')
    jsctx = jsrt.compile(pac_content)
    jsinitcnt += 1

    return


def find_proxy_for_url(url, host):
    global jsrt, jsctx, jsinitcnt
    if jsrt is None: initialize_javascript_runtime()
    if jsinitcnt > 1: raise 'what???'

    pxy = jsctx.call('FindProxyForURL', url, host)
    return pxy


def auto_proxy_address(flow):
    host = flow.request.host
    port = flow.request.port
    path = flow.request.path
    scheme = flow.request.scheme
    logging.debug(str((host, port, path, scheme)))

    if port == 443 and scheme == 'http': scheme = 'https'
    url = scheme + '://' + host
    if port not in (80, 443): url += ':' + str(port)
    if path is not None: url += path

    logging.debug('Auto proxy for: ' + str(url))
    pxy = find_proxy_for_url(url, host)
    logging.debug('Result proxy: ' + pxy)
    if pxy == 'DIRECT;':
        logging.debug('Changing upstream proxy server to :8118...')
        flow.live.change_server(('127.0.0.1', 8118), persistent_change=True)
    else:
        logging.debug('Changing upstream proxy server to :8116...')
        flow.live.change_server(('127.0.0.1', 8116), persistent_change=True)

    return


def proxy_address(flow):
    # Poor man's loadbalancing: route every second domain through the alternative proxy.
    if flow.request.host == 'www.baidu.com':
        return ('127.0.0.1', 8118)
    else:
        return ('127.0.0.1', 8116)

    # if hash(flow.request.host) % 2 == 1:
    #    return ("localhost", 8082)
    # else:
    #    return ("localhost", 8081)
    return


from libmproxy.script import concurrent
@concurrent
def request(context, flow):
    # if flow.request.method == "CONNECT":
        # If the decision is done by domain, one could also modify the server address here.
        # We do it after CONNECT here to have the request data available as well.
    #     return
    # address = proxy_address(flow)
    # if flow.live:
        # flow.live.change_upstream_proxy_server(address)
        # flow.live.change_server(address)
    # logging.debug('====================\n' +
    #              str(flow.request.method) +
    #              str(flow.request) + str(flow))
    # if flow.request.method in ('CONNECT'):  # only https
    # if flow.request.method in ('CONNECT', 'GET', 'POST'):
    auto_proxy_address(flow)  # for all request

    # logging.debug('srv sni:' + str(flow.server_conn.sni))
    # flow.server_conn.sni = 'vim-cn.com'
    return


def responseheaders(context, flow):
    # logging.debug('====================\n' +
    #              str(flow.request.method) +
    #              str(flow.request) + str(flow))
    return


def response(context, flow):
    # logging.debug('====================\n' +
    #              str(flow.request.method) +
    #              str(flow.request) + str(flow))
    return


def error(context, flow):
    logging.debug('====================\n' +
                  str(flow.request.method) +
                  str(flow.request) + str(flow))
    return


loglevel = logging.DEBUG
# loglevel = logging.INFO
loglevel = logging.WARNING
# loglevel = logging.ERROR

logging.basicConfig(level=loglevel,
                    format='%(asctime)-11s %(levelname)-8s %(filename)s:%(lineno)s %(funcName)s %(message)s')
logging.debug('The run name is:' + __name__)

if __name__ == '__builtin__':
    logging.info('Loading mitm inline script...')


if __name__ == '__main__':
    # main_gfwlist2pac()
    # sys.exit(0)
    logging.info('Starting main program...')
    # __file__ should be like this: ~/triline/mitmis.py']
    # -v --port 8119 -U http://127.0.0.1:8118/ -s ~/triline/mitmis.py --no-upstream-cert
    autopxy_args = ('--port 8119 -U http://127.0.0.1:8118/ -s ' + __file__).split(' ')
    sys.argv += autopxy_args
    if loglevel <= logging.INFO: sys.argv.append('-v')
    logging.debug('Using args: ' + str(autopxy_args))
    sys.exit(load_entry_point('mitmproxy>=0.13', 'console_scripts', 'mitmdump')())


# https://github.com/mitmproxy/mitmproxy/
# offical: https://github.com/gfwlist/gfwlist/
# https://github.com/itcook/gfwlist2pac/
