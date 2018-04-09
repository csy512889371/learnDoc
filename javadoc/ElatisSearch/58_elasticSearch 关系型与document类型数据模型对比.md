# 58_elasticSearch 关系型与document类型数据模型对比


## 一、概述


1、关系型数据库的数据模型
2、es的document数据模型

```
public class Department {
	
	private Integer deptId;
	private String name;
	private String desc;
	private List<Employee> employees;

}

public class Employee {
	
	private Integer empId;
	private String name;
	private Integer age;
	private String gender;
	private Department dept;
}
```

## 二、关系型数据库中

department表

```
dept_id
name
desc
```

employee表

```
emp_id
name
age
gender
dept_id
```

## 三、说明


三范式 --> 将每个数据实体拆分为一个独立的数据表，同时使用主外键关联关系将多个数据表关联起来 --> 确保没有任何冗余的数据

一份数据，只会放在一个数据表中 --> dept name，部门名称，就只会放在department表中，不会在employee表中也放一个dept name，如果说你要查看某个员工的部门名称，那么必须通过员工表中的外键，dept_id，找到在部门表中对应的记录，然后找到部门名称

es文档数据模型

```
{
	"deptId": "1",
	"name": "研发部门",
	"desc": "负责公司的所有研发项目",
	"employees": [
		{
			"empId": "1",
			"name": "张三",
			"age": 28,
			"gender": "男"
		},
		{
			"empId": "2",
			"name": "王兰",
			"age": 25,
			"gender": "女"
		},
		{
			"empId": "3",
			"name": "李四",
			"age": 34,
			"gender": "男"
		}
	]
}
```

es，更加类似于面向对象的数据模型，将所有由关联关系的数据，放在一个doc json类型数据中，整个数据的关系，还有完整的数据，都放在了一起

