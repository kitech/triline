# beanstalkd异步任务执行端
# 可能的任务，
# 异步git仓库向不同站点提交
# 上传图片功能
# curl/aria2c下载队列功能。

# can send task from shell using queueit
# can send task from many language

import os
import sys
import logging
import argparse
import base64

from pystalkd.Beanstalkd import Connection

from pprint import pprint


class ArgumentParser(argparse.ArgumentParser):

    def parse_args(self, args=None, namespace=None):
        try:
            ret = super(ArgumentParser, self).parse_args(args=args, namespace=namespace)
            return ret
        except Exception as ex:
            print('catched:', ex)
            return False
        return

    def parse_known_args(self, args=None, namespace=None):
        try:
            ret = super(ArgumentParser, self).parse_known_args(args=args, namespace=namespace)
            return ret
        except Exception as ex:
            print('catched:', ex)
            return False
        return ret

    def error(self, message):
        raise Exception(message)


# cmd format: cmd -a 123 -b 456 -c 789
# or json form: {"cmd": "cmd", "a":"123", "b":"456", "c", "789"}
# or both
# 直接把命令行复制过来？
def run_job(job):
    logging.debug(job.body)

    cmdline = job.body.split()
    parse_cmd = ArgumentParser(add_help=False)
    parse_cmd.add_argument('-c', '--cmd')
    cmd_args, unknown_args = parse_cmd.parse_known_args(cmdline)

    if cmd_args.cmd == 'gmpush':
        import pygit2
        import pygit2.remote

        parse_mpush = ArgumentParser(add_help=False, parents=[parse_cmd])
        parse_mpush.add_argument('-p', '--pwd')
        parse_mpush.add_argument('--rawcmdline')  # base64，否则冲突

        mpush_args, unknown_args = parse_mpush.parse_known_args(cmdline)
        logging.info('mpush parse args done:' + str(mpush_args) + str(unknown_args))
        cwd = os.getcwd()
        os.chdir(mpush_args.pwd)

        rpath = pygit2.discover_repository('.')
        repo = pygit2.Repository(rpath)
        print(rpath, repo)

        def dump_repo(repo):
            print('path:' + repo.path)
            print('workdir:' + repo.workdir)
            print('is_bare:' + str(repo.is_bare))
            print('is_empty:' + str(repo.is_empty))
            print('remotes: ' + str(repo.remotes))
            for remote in repo.remotes:
                print('  %s=%s' % (remote.name, remote.url))

            print('')
            return

        dump_repo(repo)

        os.chdir('/tmp')
    else:
        logging.debug('unknown task.')

    return


def main_loop():

    bsc = Connection('localhost', 11300)
    logging.debug('Connected bsc')
    while True:
        job = bsc.reserve()  # default tube only
        logging.debug('got 1 new job')
        run_job(job)
        job.delete()
    return


def test123():
    c = Connection()
    c.put('Hey!')
    c.put('Hey123!')

    job = c.reserve()
    print(job.body)
    pprint(job.stats())
    job.touch()
    job.delete()

    job = c.reserve()
    print(job.body)
    pprint(job.stats())
    job.touch()
    job.delete()

    pprint(c.stats_tube('default'))
    pprint(c.stats())
    return


def test_add_job():
    bsc = Connection('localhost', 11300)
    logging.debug('Connected bsc')
    bsc.put('--cmd abc --hehere 123')
    return


# send git multiple push
def test_gmpush():
    bsc = Connection('localhost', 11300)
    logging.debug('Connected bsc')
    gitcmdline = base64.b64encode("git push origin master".encode()).decode()
    gmcmdline = '--cmd gmpush --pwd /home/gzleo/opensource/wxagent --rawcmdline %s --hehere 123' % gitcmdline
    bsc.put(gmcmdline)

    return

if __name__ == '__main__':
    loglevel = logging.DEBUG
    # loglevel = logging.WARNING
    # loglevel = logging.INFO
    logging.basicConfig(level=loglevel, format='%(levelname)-8s %(message)s')

    if len(sys.argv) == 1:
        main_loop()
    else:
        test_gmpush()
        # test_add_job()
