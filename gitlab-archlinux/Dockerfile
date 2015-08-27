# FROM base/archlinux
FROM archlinux

MAINTAINER yatseni <yatseni@gmail.com>

# ADD . /tmp/buildroot
ADD . /

# RUN /tmp/buildroot/bootstrap.sh
RUN  /bootstrap.sh

VOLUME ["/home/git/repositories", "/home/git/gitlab-satellites", "/home/git/.ssh",
       "/home/git/gitlab/public/uploads"]
# VOLUME /home/git/gitlab/log

EXPOSE 8009 80 443 22

ENTRYPOINT ["/entrypoint.sh"]

CMD ["gitlab-server"]



### readme
### just docker run somehere
###

### 参数，环境变量:
# MYSQL_HOST: 不包括端口部分，必须是3306端口
# REDIS_HOST: 不包括端口部分，必须是6379端口
