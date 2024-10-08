# 使用官方 Debian 镜像作为构建阶段
FROM default.registry.tke-syyx.com/om/debian:buster-slim AS builder

# 更换为阿里云的源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
       curl \
       build-essential \
    && rm -rf /var/lib/apt/lists/* 

# 下载并安装 Go（使用阿里云开源镜像站）
ENV GO_VERSION 1.22.5
RUN curl -fsSL "https://mirrors.aliyun.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz
# 设置 Go 模块代理为阿里云
ENV GOPROXY=https://goproxy.cn,direct

# 设置 Go 环境变量
ENV PATH="/usr/local/go/bin:${PATH}"

# 设置工作目录
WORKDIR /app 

# 复制 Go 项目文件到容器
COPY . .

# 构建 Go 应用
RUN go build -a -mod=vendor -o myapp .

# 使用一个更小的基础镜像（Debian）
FROM default.registry.tke-syyx.com/om/debian:buster-slim

# 安装必要的证书
RUN apt-get update && apt-get install -y ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制构建的二进制文件到该镜像
COPY --from=builder /app/myapp .
COPY --from=builder /app/conf ./conf

# 运行二进制文件
CMD ["./myapp"]
