# beanstalkd异步任务执行端
# 可能的任务，
# 异步git仓库向不同站点提交
# 上传图片功能
# curl/aria2c下载队列功能。


import sys
import logging

from pystalkd.Beanstalkd import Connection

from pprint import pprint


# cmd format: cmd -a 123 -b 456 -c 789
# or json form: {"cmd": "cmd", "a":"123", "b":"456", "c", "789"}
def run_job(job):
    logging.debug(job.body)

    return


def main_loop():

    bsc = Connection('localhost', 11300)
    logging.debug('Connected bsc')
    while True:
        job = bsc.reserve()
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


def add_job():
    bsc = Connection('localhost', 11300)
    logging.debug('Connected bsc')
    bsc.put('--cmd abc --hehere 123')
    return

if __name__ == '__main__':
    loglevel = logging.DEBUG
    # loglevel = logging.WARNING
    # loglevel = logging.INFO
    logging.basicConfig(level=loglevel, format='%(levelname)-8s %(message)s')

    if len(sys.argv) == 1:
        main_loop()
    else:
        add_job()
