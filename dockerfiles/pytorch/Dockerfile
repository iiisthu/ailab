FROM pytorch/pytorch:2.1.1-cuda12.1-cudnn8-devel

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata 

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \ 
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	echo '[global]\nindex-url=https://mirrors.aliyun.com/pypi/simple/\n' >> /etc/pip.conf

RUN apt-get update && \
    apt-get install -y openssh-server vim curl wget git iputils-ping net-tools git-lfs && \
    apt-get clean && rm -rf /tmp/* && \
    service ssh start \
    rmdir /workspace \
    ln -s /root/workspace/ /workspace

RUN pip install ipykernel ipywidgets

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
CMD ["-p","22"]

