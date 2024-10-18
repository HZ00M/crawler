# 爬虫管理平台部署流程
docker build -t crawler:1.0 .
docker tag crawler:1.0  default.registry.tke-syyx.com/syyx-tpf/crawler:1.0
docker push default.registry.tke-syyx.com/syyx-tpf/crawler:1.0 

# 数据库导出导入
D:\pgAdmin 4\runtime\pg_dump.exe --file "C:\\Users\\huangziming\\Documents\\导出" --host "10.100.0.220" --port "5432" --username "postgres" --format=c --blobs --verbose "crawler"
D:\pgAdmin 4\runtime\pg_restore.exe --host "10.100.16.111" --port "5432" --username "postgres" --dbname "crawler" --verbose "C:\\Users\\huangziming\\Documents\\导出"