# FROM base/archlinux
FROM kitech/archlinux

MAINTAINER yatseni <yatseni@gmail.com>

# ADD . /tmp/buildroot
# ADD . /

# RUN /tmp/buildroot/bootstrap.sh
# RUN  /bootstrap.sh
RUN pacman -Syy && pacman -S --noconfirm git toxcore dbus python nginx python-pyqt5 \
    && rm -f /var/cache/pacman/pkg/*.xz \
    && rm -fr /usr/share/{man,doc}

# VOLUME ["/root/.config"]

# EXPOSE 80 443 22 33445 33445/udp

# ENTRYPOINT ["/entrypoint.sh"]

# CMD ["dktoxsrv"]



### readme
### just docker run somehere
###

### 参数，环境变量:
# MYSQL_HOST: 不包括端口部分，必须是3306端口
# REDIS_HOST: 不包括端口部分，必须是6379端口
