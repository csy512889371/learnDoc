# 基于ldap实现的统一用户代码
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-ldap

# LDAP说明

* LDAP是轻量目录访问协议(Lightweight Directory Access Protocol)的缩写
* LDAP标准实际上是在X.500标准基础上产生的一个简化版本

# LDAP特点

* LDAP的结构用树来表示，而不是用表格。正因为这样，就不能用SQL语句了
* LDAP可以很快地得到查询结果，不过在写方面，就慢得多
* LDAP提供了静态数据的快速查询方式
* Client/server模型

1) Server 用于存储数据
2) Client提供操作目录信息树的工具,这些工具可以将数据库的内容以文本格式（LDAP 数据交换格式，LDIF）呈现在您的面前

```xml
LDAP是一种开放Internet标准，LDAP协议是跨平台的 的Interent协议
它是基于X.500标准的， 与X.500不同，LDAP支持TCP/IP(即可以分布式部署)
```
	 
* LDAP存储这样的信息最为有用: 也就是数据需要从不同的地点读取，但是不需要经常更新
* 公司员工的电话号码簿和组织结构图  

1) 客户的联系信息  
2) 计算机管理需要的信息，包括NIS映射、email假名，等等  
3) 软件包的配置信息  
4) 公用证书和安全密匙 

## 什么是dn?
* DN，Distinguished Name分辨名
* LDAP中，一个条目的分辨名叫做“DN”，DN是该条目在整个树中的唯一名称标识
* DN相当于关系数据库表中的关键字,是一个识别属性，通常用于检索

常见的两种DN设置

* 基于cn（姓名）
```xml
cn=Fran Smith,ou=employees,dc=foobar,dc=com （dn格式就是这么一大串）
最常见的CN是/etc/group转来的条目
```

* 基于uid（User ID）
```xml
uid=fsmith,ou=employees,dc=foobar,dc=com
最常见的UID是/etc/passwd和/etc/shadow转来的条目
```

## Base DN （就是dc=,dc= ） 唯一限定名

* LDAP目录树的最顶部就是根，也就是所谓的“Base DN"。
* （假定我在名为FooBar 的电子商务公司工作，这家公司在Internet上的名字是foobar.com）。 BaseDN通常采用两种格式：

1) 商务型格式——以X.500格式表示的基准DN
```xml
o="FooBar, Inc.", c=US  
```
2) Internet型格式——以公司的Internet 域名地址表示的基准DN）、是最常用的格式

```xml
dc=foobar, dc=com 
```
  
  
  
  
