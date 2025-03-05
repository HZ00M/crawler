# 爬虫项目说明文档
## 一、项目概述
本项目是一个名为 crawler 的云原生爬虫平台，具备数据抓取、存储、部署以及持续集成与部署等功能。
前端使用低代码框架nocobase实现， 后端使用Go进行开发，
目标是实现爬虫插件的统一管理，通过 Kubernetes 进行统一部署，
并利用 GitHub Actions 实现 CI/CD。 目前插件有基于 Go Colly 框架的爬虫， python Scrapy 框架爬虫。
## 二、项目结构
![img.png](docs/images/系统架构图.png)

### 主要目录说明
1. infrast/persistence ：数据持久化相关代码，使用 GORM 与 PostgreSQL 数据库交互，实现数据的增删改查操作。
2. domain/entity ：定义项目中的实体类，如 JobRecord 和 DataRecord ，对应数据库表结构。
3. plugins ：存放不同语言编写的爬虫插件，包括 Python 和 Go 语言编写的爬虫代码。
   - plugins/python/python_scrapy ：使用 Scrapy 框架编写的 Python 爬虫，用于抓取哔哩哔哩等网站的数据。
   - plugins/go/myColly ：使用 Colly 框架编写的 Go 语言爬虫，实现数据抓取功能。
4. deploy ：包含 Kubernetes 部署相关代码，可在 Kubernetes 集群中部署爬虫任务。
5. bat ：包含一些部署和配置脚本及 YAML 文件，如 PostgreSQL 和 NocoBase 的部署配置。
   ![img_1.png](docs/images/k8s脚本列表.png)
6. build/ci ：包含 CI 配置文件（ ci.yaml ），使用 GitHub Actions 实现代码的构建和测试。
7. build/cd ：包含 CD 配置文件（ cd.yaml ），使用 GitHub Actions 实现代码的部署。
8. docs ：包含 Swagger 生成的 API 文档（ swagger.json ）和相关代码文件，描述项目的 API 接口。
## 三、环境准备
### 开发环境
- Go 语言环境（版本 1.16 及以上）
- Python 环境（版本 3.x）
- PostgreSQL 数据库
- Docker 环境
- Kubernetes 集群（可选，用于部署）
### 依赖安装
- Go 依赖：在项目根目录下执行 go mod tidy 安装 Go 依赖。
- Python 依赖：在 plugins/python/python_scrapy 目录下执行 pip install -r requirements.txt 安装 Python 依赖。
## 四、项目启动
### 本地开发
1. 配置数据库连接信息，在 conf 目录下的配置文件中修改数据库连接参数。
2. 启动数据库服务。
3. 在项目根目录下执行 go run main.go 启动项目。
### 容器化部署
1. 构建 Docker 镜像：在项目根目录下执行 docker build -t crawler:latest .
2. 打标签docker tag  crawler:latest default.registry.tke-syyx.com/syyx-tpf/crawler:1.0.67
2. 推送 Docker 镜像到镜像仓库：执行 docker push crawler:latest default.registry.tke-syyx.com/syyx-tpf/crawler:1.0.67
3. 在 Kubernetes 集群中部署项目：使用 deploy 目录下的 YAML 文件进行部署，例如 kubectl apply -f deployment_pro.yaml
## 五、持续集成与部署（CI/CD）
### CI
当代码推送到 main 分支或发起 Pull Request 到 main 分支时，GitHub Actions 会自动触发 build-and-test 任务，执行代码构建和测试操作。配置文件位于 build/ci/ci.yaml 。

### CD
当代码推送到 main 分支时，GitHub Actions 会自动触发 deploy 任务，将代码部署到指定服务器。配置文件位于 build/cd/cd.yaml 。

## 六、快速开始
- 1.环境准备：如pvc挂载数据库（nfs_pv.yaml和nfs_pvc.yaml）
- 2.运行postgreSQL数据库：postgresql-secret.yaml、postgresql-deploy.yaml、 postgresql-service.yaml
- 3.创建数据库：使用pg_restore恢复/bat/crawler_data.sql创建爬虫数据库
- 4.启动nocobase前端服务器：nocobase-secret.yaml，nocobase-deploment.yaml，暴露前端服务（nocobase-service.yaml）
- 5.启动crawler后端服务器：configmap_pro.yaml、deployment_pro.yaml
- 6.访问爬虫管理平台：访问地址查看nocobase-service暴露的服务地址，如下：10.100.16.116:80 账户：nocobase 密码：admin123
 ![img_3.png](docs/images/nacobase_service.png)
- 7：插件管理：进入爬虫作业平台后，进入插件管理菜单，添加自己的爬虫插件的相关信息，如下：
![img_4.png](docs/images/插件管理.png)
- 8：构建插件：配置完成后，点击构建并推送自己的插件镜像，如下：
![img_5.png](docs/images/构建推送插件.png)
- 9：创建爬虫任务：推送完成后，进入任务管理，就可以使用自己的爬虫插件了，平台基于k8s的job组件运行你的插件脚本，也可以使用cron表达式周期运行你的爬虫脚本，
以下创建了一个每日凌晨2点执行的爬虫任务，定时爬取bilibili下的关于霓虹深渊前一天的评论信息。
![img_7.png](docs/images/创建任务.png)
- 10：启动爬虫任务：创建完成后，执行启动，平台会每天在配置的时间执行你的爬虫脚本，并可以查看自己的爬虫数据（按自己需求定制）：
![img_8.png](docs/images/运行任务.png)
## 六、数据库导出导入
### 正式环境到开发环境
```bash
(D:\pgAdmin 4\runtime\).\pg_dump.exe --file "C:\\Users\\huangziming\\Documents\\prod_to_dev" --host "10.100.16.111" --port "5432" --username "postgres" --format=c --blobs --verbose "crawler"
(D:\pgAdmin 4\runtime\).\pg_restore.exe --host "10.100.0.220" --port "5432" --username "postgres" --dbname "crawler" --verbose "C:\\Users\\huangziming\\Documents\\prod_to_dev"
 ```


### 开发环境到正式环境
```bash
(D:\pgAdmin 4\runtime\).\pg_dump.exe --file "C:\\Users\\huangziming\\Documents\\dev_to_prod" --host "10.100.0.220" --port "5432" --username "postgres" --format=c --blobs --verbose "crawler"
(D:\pgAdmin 4\runtime\).\pg_restore.exe --host "10.100.16.111" --port "5432" --username "postgres" --dbname "crawler" --verbose "C:\\Users\\huangziming\\Documents\\dev_to_prod"
 ```


## 七、注意事项
- 确保数据库服务正常运行，并且配置文件中的数据库连接信息正确。
- 在使用 Kubernetes 部署时，确保集群环境正常，并且有足够的资源。
- 在使用 CI/CD 功能时，确保 GitHub Actions 的配置正确，并且有相应的权限。