# SpringBoot 热部署

#  使用IDEA 中 实现springboot 热部署

## 设置IDEA

Settings->Build,Execution,Deployment->Compiler
勾选 Build project automatically


## 添加配置pom.xml配置

>* 添加依赖包
```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <optional>true</optional>
            <scope>true</scope>
        </dependency>

```

>* 添加插件
```xml
		<plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
			<configuration>
				<fork>true</fork>
			</configuration>
		</plugin>
```

## 任意修改源代码 并且 Ctrl+F9 bulid

> 但是在eclipse中 项目是会自动编译的 但是在IDEA 中 我们需要 按ctrl+F9 让它再编译一下


## 原理介绍

>* spring-boot-devtools 是一个为开发者服务的一个模块，其中最重要的功能就是自动应用代码更改到最新的App上面去。原理是在发现代码有更改之后，重新启动应用，但是速度比手动停止后再启动还要更快，更快指的不是节省出来的手工操作的时间。


其深层原理是：
>* 使用了两个ClassLoader，一个Classloader加载那些不会改变的类（第三方Jar包），另一个ClassLoader加载会更改的类，称为 restart ClassLoader,这样在有代码更改的时候，原来的restart ClassLoader 被丢弃，重新创建一个restart ClassLoader，由于需要加载的类相比较少，所以实现了较快的重启时间（5秒以内）。



