# Docker EEDocker CE简介与版本规划

随着Docker的不断流行与发展，docker公司（或称为组织）也开启了商业化之路，Docker 从 17.03版本之后分为 CE（Community Edition） 和 EE（Enterprise Edition）。我们来看看他们之前的区别于联系。


## 版本区别


### Docker EE

Docker EE由公司支持，可在经过认证的操作系统和云提供商中使用，并可运行来自Docker Store的、经过认证的容器和插件。

> Docker EE提供三个服务层次：


* 1、Basic	
* 1.1、包含用于认证基础设施的Docker平台
* 1.2、Docker公司的支持
* 1.3、经过 认证的、来自Docker Store的容器与插件


* 2、Standard	
* 2.1、添加高级镜像与容器管理
* 2.2、LDAP/AD用户集成
* 2.3、基于角色的访问控制(Docker Datacenter)

* 3、Advanced
* 3.1、添加Docker安全扫描
* 3.2、连续漏洞监控


## Docker CE

* Docker CE是免费的Docker产品的新名称，Docker CE包含了完整的Docker平台，非常适合开发人员和运维团队构建容器APP。事实上，Docker CE 17.03，可理解为Docker 1.13.1的Bug修复版本。因此，从Docker 1.13升级到Docker CE 17.03风险相对是较小的。
* 大家可前往Docker的RELEASE log查看详情https://github.com/docker/docker/releases 。
* Docker公司认为，Docker CE和EE版本的推出为Docker的生命周期、可维护性以及可升级性带来了巨大的改进。

 

## 版本迭代计划

Docker从17.03开始，转向基于时间的YY.MM 形式的版本控制方案，类似于Canonical为Ubuntu所使用的版本控制方案。

Docker CE有两种版本：
* edge版本每月发布一次，主要面向那些喜欢尝试新功能的用户。
* stable版本每季度发布一次，适用于希望更加容易维护的用户（稳定版）。
* edge版本只能在当前月份获得安全和错误修复。而stable版本在初始发布后四个月内接收关键错误修复和安全问题的修补程序。这样，Docker CE用户就有一个月的窗口期来切换版本到更新的版本。举个例子，Docker CE 17.03会维护到17年07月；而Docker CE 17.03的下个稳定版本是CE 17.06，这样，6-7月这个时间窗口，用户就可以用来切换版本了。
* Docker EE和stable版本的版本号保持一致，每个Docker EE版本都享受为期一年的支持与维护期，在此期间接受安全与关键修正。

## 总结
* Docker从17.03开始分为企业版与社区版，社区版并非阉割版，而是改了个名称；企业版则提供了一些收费的高级特性。
* EE版本维护期1年；CE的stable版本三个月发布一次，维护期四个月；另外CE还有edge版，一个月发布一次。



