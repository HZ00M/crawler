#!/bin/sh

# 执行 dockerd-entrypoint.sh 并将输出重定向
dockerd-entrypoint.sh > /var/log/dockerd.log 2>&1 &

# 运行 myapp
./myapp