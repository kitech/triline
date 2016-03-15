#!/usr/bin/env python

import optparse
import json
import requests


class DcClient:
    burl = "https://openapi.daocloud.io/v1"
    from dckey import dckey  # dckey = ""

    def __init__(self):
        return

    def list_projects(self):
        result = requests.get(self.burl + '/build-flows',
                              headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()

    def show_project(self, id):
        result = requests.get(self.burl + '/build-flows/%s' % (id),
                              headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()

    def list_apps(self):
        result = requests.get(self.burl + '/apps',
                              headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()

    def show_app(self, id):
        result = requests.get(self.burl + '/apps/%s' % (id),
                              headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()

    def start_app(self, id):
        result = requests.post(self.burl + '/apps/%s/actions/start' % (id),
                               headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()

    def stop_app(self, id):
        result = requests.post(self.burl + '/apps/%s/actions/stop' % (id),
                               headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()

    def restart_app(self, id):
        result = requests.post(self.burl + '/apps/%s/actions/restart' % (id),
                               headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()

    def redeploy_app(self, appid, relname):
        result = requests.post(self.burl + '/apps/%s/actions/redeploy' % (appid),
                               data=json.JSONEncoder().encode({"release_name": '%s' % (relname)}),
                               headers={"Authorization": "token %s" % (self.dckey),
                                        "Content-Type": "application/json"})
        return result.json()

    def show_action(self, appid, actionid):
        result = requests.get(self.burl + '/apps/%s/actions/%s' % (appid, actionid),
                              headers={"Authorization": "token %s" % (self.dckey)})
        return result.json()


def test():
    dc = DcClient()
    print(dc.list_projects())
    for p in dc.list_projects()['build_flows']:
        print(p, p['id'])
        pinfo = dc.show_project(p['id'])
        print(pinfo)
    return


def help():
    return


def main():
    op = optparse.OptionParser()
    op.add_option('-a', '--app', dest='app', action='store_true', help='appplication')
    op.add_option('-p', '--project', dest='project', action='store_true', help='project')
    op.add_option('--id', dest='id', action='store', help='app/project id')
    op.add_option('-n', '--name', dest='name', action='store', help='appname/projectname')
    op.add_option('-c', '--cmd', dest='command',
                  help='command like [show, list, deploy, start, stop, restart,]',)
    (opts, args) = op.parse_args()
    # cmd = opts.command
    # print(cmd, opts.ensure_value)

    dc = DcClient()
    if opts.app is True:
        if opts.id is not None:
            if opts.command == 'show':
                info = dc.show_app(opts.id)
                print(json.dumps(info, indent=4, sort_keys=True))
            elif opts.command == 'start':
                res = dc.start_app(opts.id)
                print(json.dumps(res, indent=4, sort_keys=True))
            elif opts.command == 'stop':
                res = dc.stop_app(opts.id)
                print(json.dumps(res, indent=4, sort_keys=True))
            elif opts.command == 'restart':
                res = dc.restart_app(opts.id)
                print(json.dumps(res, indent=4, sort_keys=True))
            elif opts.command == 'deploy':
                res = dc.redeploy_app(opts.id, opts.name)
                print(json.dumps(res, indent=4, sort_keys=True))
        else:
            if opts.command == 'list':
                apps = dc.list_apps()
                print(json.dumps(apps, indent=4, sort_keys=True))

    return


if __name__ == '__main__':
    main()
