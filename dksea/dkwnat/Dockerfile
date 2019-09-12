FROM kitech/archlinux:latest

#ADD . /
COPY . /

RUN /bootstrap.sh

EXPOSE 80 443 22 2222 6080 6443 9981 4712 4711 16861 56800

#  相反, ENTRYPOINT的作用不同, 如果你希望你的docker镜像只执行一个具体程序, 不希望用户在执行docker run的时候随意覆盖默认程序. 建议用ENTRYPOINT.
# ENTRYPOINT ["/entrypoint.sh"]

CMD /entrypoint.sh

# usage:
# docker run --privileged -p 4712:4712 -p 4711:4711 -p 16861:16861 -v /path/to/download:/srv/download dkwnat
# 可以设置资源限制，内存128M，CPU 1个

# 所需环境变量：
# PEMKEY= # string like a password, use for wnat cert key, amuled pass
# USERPASS=
# WNAT_SRVPROTO=udp|tcp
# WNAT_SRVIP=  # vpn server 公网IP
# WNAT_SRVPORT= # vpn server 公网端口
#

# 挂载卷：
# 用于存放下载文件，可以把本地 $HOME中的对应目录拷贝，添加后缀，并挂载
# /root/.aMule
# /root/.aria2
# /root/TDDOWNLOAD  # 存储前两者下载完成后的文件
# 例如，对amule, 可以挂载为 -v $HOME/.aMule.dkvol:/root/.aMule
# 例如，对aria2, 可以挂载为 -v $HOME/.aria2.dkvol:/root/.aria2
# 最后一个，挂载为 -v /mnt/winc/TDDOWNLOAD:/root/TDDOWNLOAD

# 特性：
# 默认路由为VPN

# 包含软件包，
# openvpn client
# amuled
# aria2c
# transmission-cli

# 问题
# Q: Error: File '/root/.aMule/Temp/006.part' couldn't be renamed '/root/.aMule/Incoming/' (error 0: Invalid or incomplete multibyte or wide character)
# A:


