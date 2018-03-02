# 基于spring-ladp的统一用户中心结构设计以及代码结构设计

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
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/a1.png)

### 2 人员添加

人员添加需要指定具体目录。

例如：要在“财务部”下添加人员，需要指定ou=财务部,o=用友超客
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/a2.png)

目前我们的人员上下级关系全部用人员去处理，不用添加部门上下级关系。


## 三、	接口

### 1、增加公司

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/organization/create |
| Http Method | post |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |

> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| organization_name | String | y | 公司名称 |
| domain_name | String | y | 域（暂存域名） |

### 2、删除公司


> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/organization/delete |
| Http Method | delete |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |

> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| organization_name | String | y | 公司名称 |
	

### 3、增加部门
> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ou/create |
| Http Method | post |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| rdn | String | y | 部门的具体路径(不包括部门名称) |
| ou_name | String | y | 部门名称 |
			
### 4、删除部门

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ou/delete |
| Http Method | delete |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |

> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| rdn | String | y | 部门的具体路径(包括部门名称) |


### 5、增加人员

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/create |
| Http Method | post |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |

> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| rdn | String | y | 增加人员的具体路径(不包括登录名称) |
| login_name | String | y | 登录名称 |
| user_password | String | y | 登录密码 |
| user_name | String | y | 人员名称 |
| mobile | String | n | 联系电话 |
| company | String | n | 所属公司 |
| department | String | n | 所属部门 |
| email | String | n | 邮箱 |
| employee_type | String | n | 职位 |
	
### 6、	删除人员	
				
> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/delete |
| Http Method | delete |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| rdn | String | y | 增加人员的具体路径(包括登录名称) |

### 7、	人员注册

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/register |
| Http Method | post |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| login_name | String | y | 登录名称 |		
| user_password | String | y | 登录密码 |	
| user_name | String | y | 人员名称 |	
| mobile | String | n | 联系电话 |	
| company | String | n | 所属公司 |	
| department | String | n | 所属部门 |	
| employee_type | String | n | 职位 |	
| email | String | n | 邮箱 |	


### 8、人员登录

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/account |
| Http Method | get |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| login_name | String | y | 登录名称 |
| user_password | String | y | 登录密码 |					
			
> Response Parameter

| parameter | type | comment |
| -------- | :------ | :------ |
| login_name | String | 登录名称 |
| user_password | String | 登录密码 |
| user_name | String | 人员名称 |
| mobile | String | 联系电话 |
| company | String | 所属公司 |
| department | String | 所属部门 |
| employee_type | String | 职位 |

		
### 9、人员迁移	

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/move |
| Http Method | get |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |
	
> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| oldrdn | String | y | 人员的具体路径(包括登录名称) |
| newrdn | String | y | 人员的具体路径(包括登录名称(可以重命名) |

### 10、添加层级人员

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/hierarchy |
| Http Method | post |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| rdn | String | y | 增加人员的具体路径 |
| login_name | String | y | 对应人员的uid |
| user_name | String | y | 人员名称 |

### 11、查询人员信息的具体路径

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/rdn |
| Http Method | get |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| login_name | String | y | 登录名称 |

> Response Parameter

| parameter | type | comment |
| -------- | :------ | :------ |
| path | String | 路径 |

## 12、人员的所有下一级
> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/nexthierarchy |
| Http Method | get |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| rdn | String | y | 人员的具体路径(包括登录名称) |

> Response Parameter

| parameter | type | comment |
| -------- | :------ | :------ |
| login_name | String | 登录名称 |
| user_name | String | 人员名称 |

## 11、删除层级人员

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/delhierarchy |
| Http Method | delete |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |

> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| rdn | String | y | 人员的具体路径(包括登录名称) |

## 12、更改密码

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/replacepwd |
| Http Method | put |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |

> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| login_name |  String| y | 登录uid |
| user_oldpassword | String | y | 旧密码 |
| user_newpassword | String | y | 新密码 |


### 13、找回密码

> Request describe

| Item | value |
| -------- | :------ |
| PATH | /usercenter/ouperson/retrievepwd |
| Http Method | put |
| Accept | application/json |
| Conten-Type | application/json;charset=UTF-8 |


> Request Parameter

| parameter | type | require | comment |
| -------- | :------ | :------ | :------ |
| login_name | String | y | 登录uid |
| user_newpassword | String | y | 新密码 |



