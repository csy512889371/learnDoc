# windows 下 yapi部署文档

1) 安装nodejs
2) 安装mongodb
3) 安装yapi

## 介绍

随着 web 技术的发展，前后端分离成为越来越多互联网公司构建应用的方式。前后端分离的优势是一套 Api 可被多个客户端复用，分工和协作被细化，大大提高了编码效率，但同时也带来一些“副作用”:

1) 接口文档不可靠。很多小伙伴管理接口文档，有使用 wiki 的，有 word 文档的，甚至还有用聊天软件口口相传的，后端接口对于前端就像一个黑盒子，经常遇到问题是接口因未知原因增加参数了，参数名变了，参数被删除了。
2) 测试数据生成方案没有统一出口。我们都有这样的经历，前端开发功能依赖后端，解决方案有自己在代码注入 json 的，还有后端工程师临时搭建一套测试数据服务器，这种情况下势必会影响工作效率和代码质量，也不能及时进行更新。
3) 资源分散，无法共享。接口调试每个开发者单独维护一套 Postman 接口集，每个人无法共用其他人的接口集，存在大量重复填写请求参数工作，最重要的是 postman 没法跟接口定义关联起来，导致后端没有动力去维护接口文档。 基于此，我们在前端和后端之间搭建了专属桥梁—— YApi 接口管理平台

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


