# 使用 debian:buster-slim 作为基础镜像
FROM default.registry.tke-syyx.com/syyx-tpf/yh-python-1:3.10.0

# 设置工作目录
WORKDIR /app

COPY . .

RUN apt list --installed
# 安装 Python 依赖
RUN pip3.10 install --no-cache-dir -r requirements.txt -i https://pypi.doubanio.com/simple --retries 5

# 运行 Python 应用
CMD ["python3.10", "main.py"]
