# 29_ElasticSearchIK中文分词器的安装和使用

## 一、概述

在搜索引擎领域，比较成熟和流行的，就是ik分词器

* 对于“中国人很喜欢吃油条” 。使用不同的分词器会进行下面的不同的拆分

```java
standard：中 国 人 很 喜 欢 吃 油 条
ik：中国人 很 喜欢 吃 油条
```

## 二、安装

1、在elasticsearch中安装ik中文分词器

* 1、git clone https://github.com/medcl/elasticsearch-analysis-ik
* 2、git checkout tags/v5.2.0
* 3、mvn package
* 4、将target/releases/elasticsearch-analysis-ik-5.2.0.zip拷贝到es/plugins/ik目录下
* 5、在es/plugins/ik下对elasticsearch-analysis-ik-5.2.0.zip进行解压缩
* 6、重启es

## 三、ik分词器基础知识

* 两种analyzer，你根据自己的需要自己选吧，但是一般是选用ik_max_word
* ik_max_word: 会将文本做最细粒度的拆分，比如会将“中华人民共和国国歌”拆分为“中华人民共和国,中华人民,中华,华人,人民共和国,人民,人,民,共和国,共和,和,国国,国歌”，会穷尽各种可能的组合；
* ik_smart: 会做最粗粒度的拆分，比如会将“中华人民共和国国歌”拆分为“中华人民共和国,国歌”。


## 四、ik分词器的使用

```java
PUT /my_index 
{
  "mappings": {
    "my_type": {
      "properties": {
        "text": {
          "type": "text",
          "analyzer": "ik_max_word"
        }
      }
    }
  }
}
```

例子：
```java
POST /my_index/my_type/_bulk
{ "index": { "_id": "1"} }
{ "text": "男子偷上万元发红包,被抓获时仍然单身" }
{ "index": { "_id": "2"} }
{ "text": "16岁为结婚“变”22岁7年后想离婚被法院拒绝" }
{ "index": { "_id": "3"} }
{ "text": "深圳女孩骑车逆行撞奔驰 遭索赔被吓哭" }
{ "index": { "_id": "4"} }
{ "text": "对护肤品比对男票好" }
{ "index": { "_id": "5"} }
{ "text": "为什么国内的街道招牌用的都是红黄配" }
```

```java
GET /my_index/_analyze
{
  "text": "上万元发红包",
  "analyzer": "ik_max_word"
}
```

```java
GET /my_index/my_type/_search 
{
  "query": {
    "match": {
      "text": "结婚好还是单身好"
    }
  }
}

```