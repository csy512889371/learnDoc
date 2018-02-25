# 基于oAuth2.0实现开放平台授权中心

OAuth (开发授权)是一个开放标准，允许用户让第三方应用访问该用户在某一网站上存储的秘密的资源（如 照片、视频、联系人列表）而无需将用户名和密码提供给第三方应用
## 在认证和授权的过程中设计的各方包括
* 服务提供方：开放平台内部-- 应用体系
* 用户：商城买家和卖家
* 客户端，要访问服务提供方资源的第三方应用
* 资源服务器 开放平台=》网关
* 认证服务器 开放平台=》授权中心

## 在OAuth2.0当中支持的授权模式
* 授权码模式（authorization code）
* 简化模式（implicit）
* 密码模式
* 客户端模式


## 一个完整的开放平台由4个体系组成，分别是 
* 开放平台网关
* 授权中心
* 开发者中心
* 控制后台

# 架构

> 架构图
![image](https://github.com/csyeva/eva/blob/master/img/oAuth2/jg.png)

> 系统关系图
![image](https://github.com/csyeva/eva/blob/master/img/oAuth2/xtgx.png)

# 用户权限验证
用户权限是指第三方系统是否具备某部分用户指定范围的授权。比如第三方系统访问用户的订单信息。其主要两种交互模式如下

## 自动授权模式
* 该模式下第三方应用必须是WEB系统，有自己的服务器

![image](https://github.com/csyeva/eva/blob/master/img/oAuth2/ms1.png)

> Code授权时序图
![image](https://github.com/csyeva/eva/blob/master/img/oAuth2/sxt.png)

* response_type 表示授权类型
* client_id 客户端ID APP KEY
* redirect_url 重定向URL
* scope 申请权限的范围


## 手动授权模式
在自动授权模式下第三方系统必须有自己的服务器。如果没有则必须采用手动授权模式。
该模式是值，在线下通过浏览器交互自动生成一个 长效期Token, 并手动匹配至第三方应用当中


# 网址

[京东开放服务平台](http://jos.jd.com/api/index.htm#topic)