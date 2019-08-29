FROM kitech/archlinux:latest

#ADD . /
COPY . /

RUN /bootstrap.sh

EXPOSE 80 443 22 2222 6080 6443 9981 4712 4711 16861

#  相反, ENTRYPOINT的作用不同, 如果你希望你的docker镜像只执行一个具体程序, 不希望用户在执行docker run的时候随意覆盖默认程序. 建议用ENTRYPOINT.
# ENTRYPOINT ["/entrypoint.sh"]

CMD /entrypoint.sh

# usage:
# docker run --privileged -p 4712:4712 -p 4711:4711 -p 16861:16861 -v /path/to/download:/srv/download dkwnat

