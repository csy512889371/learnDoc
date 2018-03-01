# 基于spring-security-oauth2的mysql数据表设计

## 一、	目录设计

### 1.1 公司

| attribute | describe | require |
| ---------- | :------ | :------ |
| objectClass | organization,dcObject,top | y |
| o | 公司名称(唯一) | y |
| dc | 域（暂存域名） | y |

### 1.2 部门

| attribute | describe | require |
| ---------- | :------ | :------ |
| objectClass | organizationalUnit,top | y |
| ou | 部门名称 | y |

### 1.3 注册人员

| attribute | describe | require |
| ---------- | :------ | :------ |
| objectClass | inetOrgPerson,organizationalPerson,top | y |
| uid | 登录名称（唯一） | y |
| cn | 登录名称 | y |
| sn | 姓名 | y |
| userpassword | 密码 | y |
| o | 公司名称 | n |
| ou | 部门名称 | n |
| mobile | 手机号 | n |
| employeetype | 职位 | n |
| mail | 邮箱 | n |

### 1.4层级人员

| attribute | describe | require |
| ---------- | :------ | :------ |
| objectClass | inetOrgPerson,organizationalPerson,top | y |
| cn | 登录名称（对应注册人员uid） | y |
| sn | 姓名 | y |


## 二、	规则

### 1 注册
自行注册人员放到模拟公司的目录下，等所属公司组织结构建立完毕，将此人员迁移到所属公司(或者删除此人员，所属公司新建此人员)。

模拟公司如下
![image](a1.png)

### 2 人员添加

人员添加需要指定具体目录。

例如：要在“财务部”下添加人员，需要指定ou=财务部,o=用友超客
![image](a2.png)

目前我们的人员上下级关系全部用人员去处理，不用添加部门上下级关系。


## 三、	接口

### 1、增加公司

Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/organization/create |
| Http Method | post |
| Accept | application/json |
| Conten-Type |  |

Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| organization_name | String | y | 公司名称 |
| domain_name | String | y | 域（暂存域名） |

### 2、删除公司

Request describe
| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| PATH | /usercenter/organization/delete |
| Http Method | delete |
| Accept |  |
| Conten-Type |  |

Request Parameter
| Item | value |
| -------- | :------ |
|  |  |

### 3、增加部门

Request describe
| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| PATH |  |
| Http Method |  |
| Accept |  |
| Conten-Type |  |

Request Parameter
| Item | value |
| -------- | :------ |
|  |  |





