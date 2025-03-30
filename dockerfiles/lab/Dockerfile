FROM nvcr.io/nvidia/pytorch:24.10-py3

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    BNB_CUDA_VERSION=125

RUN apt-get update && \
    apt-get install -y ca-certificates tzdata && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata


# RUN cat <<'EOF' > /etc/apt/sources.list
# # 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
# deb https://mirrors.cernet.edu.cn/ubuntu/ jammy main restricted universe multiverse
# # deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# # deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# # deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# # 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
# # deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# # # deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

# deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# # 预发布软件源，不建议启用
# # deb https://mirrors.cernet.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# # # deb-src https://mirrors.cernet.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# EOF

RUN apt-get update && \
    apt-get install -y openssh-server vim curl wget git iputils-ping net-tools git-lfs man-db zsh poppler-utils tesseract-ocr libgl1 && \
    # pip config set global.index-url https://mirrors.cernet.edu.cn/pypi/web/simple && \
    # pip config set global.trusted-host mirrors.cernet.edu.cn && \
    apt-get clean && rm -rf /tmp/* && \
    service ssh start && \
    rm /workspace/* -rf && \
    mkdir -p /root/workspace && \  
    ln -s /root/workspace/ /workspace

COPY requirements.txt /opt/app/requirements.txt
COPY lab5-version-package/flashinfer-0.2.4.tar.gz /opt/app/flashinfer-0.2.4.tar.gz
WORKDIR /opt/app
RUN pip install -r requirements.txt && \
    pip install ./flashinfer-0.2.4.tar.gz && \
    pip install sglang[all] -i https://pypi.org/simple
WORKDIR /root

COPY . /root
RUN pip install torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124 && \
    pip install qwen-vl-utils && \
    pip install /root/lab5-version-package/transformers && \
    pip install /root/lab5-version-package/CLIP-d50d76daa670286dd6cacf3bcd80b5e4823fc8e1.zip && \
    pip install /root/lab5-version-package/open_clip-bb6e834e9c70d9c27d0dc3ecedeebeaeb1ffad6b.zip && \
    pip install -U -I --no-deps xformers==0.0.23.post1 && \
    pip install ngrok && \
    pip install /root/lab5-version-package/torch-2.5.1+cu124-cp310-cp310-linux_x86_64.whl

RUN pip install flash-attn==2.7.0.post2 --no-build-isolation && \
    pip install -U accelerate && \
    pip install /root/lab5-version-package/torch-2.5.1+cu124-cp310-cp310-linux_x86_64.whl

WORKDIR /app
COPY ./lab5-version-package/sam2 /app/sam2
RUN pip install -e /app/sam2 && \
    pip install /root/lab5-version-package/opencv_python-4.8.0.74-cp37-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl && \
    pip install /root/lab5-version-package/torch-2.5.1+cu124-cp310-cp310-linux_x86_64.whl

WORKDIR /root
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
CMD ["-p","22"]

