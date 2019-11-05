FROM kitech/archlinux:latest

#ADD . /
COPY . /

RUN /bootstrap.sh

EXPOSE 80 443 22 2222 5902 6080 6443 8080

#  相反, ENTRYPOINT的作用不同, 如果你希望你的docker镜像只执行一个具体程序, 不希望用户在执行docker run的时候随意覆盖默认程序. 建议用ENTRYPOINT.
# ENTRYPOINT ["/entrypoint.sh"]

CMD /entrypoint.sh


# port 流程
# nginx:http:80(或环境变量PORT) 分发到本docker开启的 http端口，5080,9981
# 访问方式 http(s)://docker-extip:80($PORT)/p5080(p9981)/xxx
# 其他非http端口需要其他方式映射出去。

# 环境变量
# FUSER
# FPASS
# 永存卷
