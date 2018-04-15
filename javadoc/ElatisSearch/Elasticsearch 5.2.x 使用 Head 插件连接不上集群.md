# Elasticsearch 5.2.x 使用 Head 插件连接不上集群


## 0、前言

Head插件的安装

## 1、安装插件head

```
# 去github上下载head
git clone git://github.com/mobz/elasticsearch-head.git
# 由于head基于nodejs所以安装它
yum -y install nodejs npm
npm install grunt-cli
npm install grunt
grunt -version
# 修改配置文件
cd elasticsearch-head
vim _site/app.js
# 修改 『http://localhost:9200』字段到本机ES端口与IP
```

## 2、启动head

```
cd elasticsearch-head
grunt server
# 打开浏览器 http://localhost:9100
```

## 3、出现问题

head主控页面是可以显示的，但是显示连接失败

```
“集群健康值: 未连接”
```

## 4、解决方案

修改elasticsearch.yml文件

```
vim $ES_HOME$/config/elasticsearch.yml
# 增加如下字段
http.cors.enabled: true
http.cors.allow-origin: "*"
```


重启es和head即可


 ## 5、CORS是什么

 wiki上的解释是 Cross-origin resource sharing (CORS) is a mechanism that allows restricted resources ，即跨域访问。   这个字段默认为false，在Elasticsearch安装集群之外的一台机上用Sense、Head等监控插件访问Elasticsearch是不允许的。这个字段最早可以追溯到1.4.x版本，而非5.x特有。 具体这个http.cors.x字段还有哪些用途和用法，见下表：

```
http.cors.enabled	是否支持跨域，默认为false

http.cors.allow-origin	当设置允许跨域，默认为*,表示支持所有域名，如果我们只是允许某些网站能访问，那么可以使用正则表达式。比如只允许本地地址。 /https?:\/\/localhost(:[0-9]+)?/

http.cors.max-age	浏览器发送一个“预检”OPTIONS请求，以确定CORS设置。最大年龄定义多久的结果应该缓存。默认为1728000（20天）

http.cors.allow-methods	允许跨域的请求方式，默认OPTIONS,HEAD,GET,POST,PUT,DELETE

http.cors.allow-headers	跨域允许设置的头信息，默认为X-Requested-With,Content-Type,Content-Length

http.cors.allow-credentials	是否返回设置的跨域Access-Control-Allow-Credentials头，如果设置为true,那么会返回给客户端。
```

