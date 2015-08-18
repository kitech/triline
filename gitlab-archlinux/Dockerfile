# FROM base/archlinux
FROM archlinux

MAINTAINER yatseni <yatseni@gmail.com>

# ADD . /tmp/buildroot
ADD . /

# RUN /tmp/buildroot/bootstrap.sh
RUN  /bootstrap.sh

VOLUME ["/home/git/repositories", "/home/git/gitlab-satellites"]
# VOLUME /home/git/gitlab/log

EXPOSE 8009 80 443 22

ENTRYPOINT ["/entrypoint.sh"]

CMD ["gitlab-server"]



### readme
### just docker run somehex 
### 