# 爬虫管理平台部署流程
docker build -t crawler:1.0 .
docker tag crawler:1.0  default.registry.tke-syyx.com/syyx-tpf/crawler:1.0 
docker push default.registry.tke-syyx.com/syyx-tpf/crawler:1.0 