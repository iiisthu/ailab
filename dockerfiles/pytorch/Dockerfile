FROM pytorch/pytorch:2.1.1-cuda12.1-cudnn8-devel

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata 

RUN apt-get update && \
    apt-get install -y openssh-server vim curl wget git iputils-ping net-tools && \
    apt-get clean && rm -rf /tmp/* && \
    service ssh start \
    rmdir /workspace \
    ln -s /root/workspace/ /workspace

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
CMD ["-p","22"]
