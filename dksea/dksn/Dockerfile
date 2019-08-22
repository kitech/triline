FROM kitech/archlinux:latest

ADD . /

RUN /bootstrap.sh

EXPOSE 80 443 22 2222 6080 6443

#  相反, ENTRYPOINT的作用不同, 如果你希望你的docker镜像只执行一个具体程序, 不希望用户在执行docker run的时候随意覆盖默认程序. 建议用ENTRYPOINT.
# ENTRYPOINT ["/entrypoint.sh"]

CMD /entrypoint.sh

