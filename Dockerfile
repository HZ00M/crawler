# 使用官方 Debian 镜像作为构建阶段
FROM default.registry.tke-syyx.com/syyx-tpf/docker:20.10-dind AS builder
RUN cat /etc/os-release
# 更换为阿里云的源
RUN echo "" > /etc/apk/repositories && \
    echo "https://mirrors.aliyun.com/alpine/v3.18/main" >> /etc/apk/repositories && \
    echo "https://mirrors.aliyun.com/alpine/v3.18/community" >> /etc/apk/repositories
RUN apk update && apk add --no-cache \
    curl
#    build-base

# 下载并安装 Go（使用阿里云开源镜像站）
ENV GO_VERSION 1.22.5
RUN curl -fsSL "https://mirrors.aliyun.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz
# 设置 Go 模块代理为阿里云
ENV GOPROXY=https://goproxy.cn,direct

# 设置 Go 环境变量
ENV PATH="/usr/local/go/bin:${PATH}"

# 设置工作目录
WORKDIR /app 

# 先复制依赖文件
COPY go.mod go.sum ./

# 下载依赖，这一层在依赖没有变动时会被缓存
RUN go mod download

# 复制 Go 项目文件到容器
COPY . .

# 构建 Go 应用
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o myapp .

# 使用一个更小的基础镜像（Debian）
FROM default.registry.tke-syyx.com/syyx-tpf/docker:20.10-dind

# 安装必要的证书
RUN echo "" > /etc/apk/repositories && \
    echo "https://mirrors.aliyun.com/alpine/v3.18/main" >> /etc/apk/repositories && \
    echo "https://mirrors.aliyun.com/alpine/v3.18/community" >> /etc/apk/repositories
RUN apk update && apk add --no-cache ca-certificates busybox-extras curl git

# 设置工作目录
WORKDIR /app

# 复制构建的二进制文件到该镜像
COPY --from=builder /app/myapp .
# 配置通过configmap挂载
#COPY --from=builder /app/conf ./conf
COPY --from=builder /app/plugins ./plugins


COPY --from=builder /app/start.sh ./start.sh
# 将启动脚本复制到镜像中
RUN chmod +x start.sh
# 使用启动脚本作为 ENTRYPOINT
ENTRYPOINT ["./start.sh"]
#CMD ["sh", "-c", "dockerd-entrypoint.sh > /var/log/dockerd.log & ./myapp"]

