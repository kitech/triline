#!/usr/bin/env python
# vim:fileencoding=utf-8,tab=4

import sys
import pycurl
import io


def uploadFile(fname):
    dest_url = 'http://ipfs.pics/upload.php'

    c = pycurl.Curl()
    c.setopt(pycurl.URL, dest_url)
    c.setopt(pycurl.POST, 1)

    filename = fname
    c.setopt(c.HTTPPOST, [(('img', (c.FORM_FILE, filename)))])
    c.setopt(pycurl.SSL_VERIFYPEER, 0)
    c.setopt(pycurl.SSL_VERIFYHOST, 0)
    c.setopt(pycurl.USERAGENT, 'curl/7.45.0')
    # c.setopt(pycurl.VERBOSE, 1)
    # c.setopt(pycurl.PROXY, '127.0.0.1:8117')
    # c.setopt(pycurl.PROXYTYPE_HTTP, 1)

    outval = io.BytesIO()
    hdrval = io.BytesIO()
    c.setopt(pycurl.WRITEFUNCTION, outval.write)
    c.setopt(pycurl.HEADERFUNCTION, hdrval.write)
    c.setopt(pycurl.TIMEOUT, 107)  # 这网烂成如此，不容易

    c.perform()
    resp_code = c.getinfo(pycurl.RESPONSE_CODE)
    used_time = c.getinfo(pycurl.TOTAL_TIME)

    c.close()

    # print(outval.getvalue().decode(), hdrval.getvalue().decode())
    if resp_code != 302: print('upload error: ', hdrval.getvalue())
    hdrs = hdrval.getvalue().decode().split("\r\n")
    # print(hdrs)
    url = None
    for hdr in hdrs:
        if hdr.startswith('Location:'):
            url = hdr[10:]

    hash_name = url.split('#')[0].split('/')[-1]
    rawurl = 'http://ipfs.pics/ipfs/%s' % hash_name
    return rawurl


if len(sys.argv) < 2:
    print('need a image file path.')
    sys.exit(0)

file_name = sys.argv[1]
# u = uploadFile('/home/xxx/Pictures/Screenshot_20150902_204958.png')
u = uploadFile(file_name)
print(u)
