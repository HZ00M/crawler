
# 使用官方的Python镜像作为基础镜像
FROM default.registry.tke-syyx.com/om/python:3.10-slim

# 设置工作目录
WORKDIR /app

# 将当前目录下的所有文件复制到容器中的/app目录
COPY . /app

#RUN ls /app/packages
#RUN pip install --no-index --find-links=/app/packages -r requirements.txt
RUN pip install --upgrade pip
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ &&  pip install --no-cache-dir -r  requirements.txt
RUN #pip config set global.index-url https://pypi.doubanio.com/simple
#RUN pip install -r requirements.txt
# 运行Python脚本
CMD ["python", "main.py"]
