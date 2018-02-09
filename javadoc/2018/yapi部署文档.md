# windows 下 yapi部署文档

1) 安装nodejs
2) 安装mongodb
3）安装yapi

## 安装mongodb
* 安装mongodb 到 D:\Mongo 
* mongodb 安装目录下创建几个文件夹具体如下

1) 数据库路径（data目录）
2) 日志路径（logs目录）
3) 日志文件（mongo.log文件）

4) 创建配置文件mongo.conf，文件内容如下：路径修改为对应路径

```xml
#数据库路径  
dbpath=D:\Mongo\data  
#日志输出文件路径  
logpath=D:\Mongo\logs\mongo.log  
#错误日志采用追加模式  
logappend=true  
#启用日志文件，默认启用  
journal=true  
#这个选项可以过滤掉一些无用的日志信息，若需要调试使用请设置为false  
quiet=true  
#端口号 默认为27017  
port=27017   


```

5） 创建并启动MongoDB服务，执行下面命令
```shell
mongod --config "D:\Mongo\mongo.conf"  --install --serviceName "MongoDB"
```

```shel
net start MongoDB
```

## 安装yapi

1) 克隆项目到本地
2) 使用命令进入项目所在目录
3) 首次使用先运行npm install -g yapi-cli --registry https://registry.npm.taobao.org
4) 运行yapi server
5) 访问http:\\ip:9090进行yapi部署
6) 切换到部署目录，输入node vendors/server/app.js
7) 访问http:\\ip:3000


## 注意
* 如果内网安装 可以先在外网安装好后然后拷贝代码和mongodb 数据文件到内网
* 内网环境 antd 的图标无法看到
* mongodb-win32-x86_64-2008plus-ssl-3.4.10-signed mongodb 如果是3.6安装时候需要官网下载 补丁


