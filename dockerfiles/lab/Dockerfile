FROM nvcr.io/nvidia/pytorch:24.10-py3

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    BNB_CUDA_VERSION=125

RUN apt-get update && \
    apt-get install -y ca-certificates tzdata && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    cat <<'EOF' > /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.cernet.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
# deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# # deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF

RUN apt-get update && \
    apt-get install -y openssh-server vim curl wget git iputils-ping net-tools git-lfs man-db zsh poppler-utils tesseract-ocr libgl1 && \
    pip config set global.index-url https://mirrors.cernet.edu.cn/pypi/web/simple && \
    pip config set global.trusted-host mirrors.cernet.edu.cn && \
    apt-get clean && rm -rf /tmp/* && \
    service ssh start && \
    rm /workspace/* -rf && \
    mkdir -p /root/workspace && \  
    ln -s /root/workspace/ /workspace

COPY requirements.txt /opt/app/requirements.txt
WORKDIR /opt/app
RUN pip install -r requirements.txt && \
    pip install flash-attn --no-build-isolation && \
    pip install flashinfer -i https://flashinfer.ai/whl/cu124/torch2.4/ && \
    pip install sglang[all] -i https://pypi.org/simple
WORKDIR /root

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
CMD ["-p","22"]

