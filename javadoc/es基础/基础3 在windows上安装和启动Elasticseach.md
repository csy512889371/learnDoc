# 基础5 Elasticseach 在windows上安装和启动Elasticseach

## 软件下载

链接：https://pan.baidu.com/s/1co-8gEHBwSi5hRBjNMu6Xg 密码：821i

## 概述

* 1、安装JDK，至少1.8.0_73以上版本，java -version
* 2、下载和解压缩Elasticsearch安装包，目录结构
* 3、启动Elasticsearch：bin\elasticsearch.bat，es本身特点之一就是开箱即用，如果是中小型应用，数据量少，操作不是很复杂，直接启动就可以用了
* 4、检查ES是否启动成功：http://localhost:9200/?pretty

```
name: node名称
cluster_name: 集群名称（默认的集群名称就是elasticsearch）
version.number: 5.2.0，es版本号
```

```
{
  "name" : "4onsTYV",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "nKZ9VK_vQdSQ1J0Dx9gx1Q",
  "version" : {
    "number" : "5.2.0",
    "build_hash" : "24e05b9",
    "build_date" : "2017-01-24T19:52:35.800Z",
    "build_snapshot" : false,
    "lucene_version" : "6.4.0"
  },
  "tagline" : "You Know, for Search"
}
```

* 5、修改集群名称：elasticsearch.yml
* 6、下载和解压缩Kibana安装包，使用里面的开发界面，去操作elasticsearch，作为我们学习es知识点的一个主要的界面入口
* 7、启动Kibana：bin\kibana.bat
* 8、进入Dev Tools界面 http://localhost:5601
* 9、GET _cluster/health