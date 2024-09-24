# 使用官方的Python镜像作为基础镜像
FROM default.registry.tke-syyx.com/om/python:3.10

# 设置工作目录
WORKDIR /app

# 将当前目录下的所有文件复制到容器中的/app目录
COPY . /app

# 创建Python虚拟环境
RUN python -m venv venv

# 把镜像下载地址设置成豆瓣，默认是国外的，下载巨慢
RUN venv/bin/pip config set global.index-url https://pypi.doubanio.com/simple

# 安装项目的依赖包，假设requirements.txt中列出了依赖项
RUN venv/bin/pip install -r requirements.txt

# 运行Python脚本
CMD ["venv/bin/python", "main.py"]
