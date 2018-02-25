# gradle 使用

* Gradle安装
* 多项目构建
* 测试
* 发布

# 构建工具Gradle

> 1.Gradle是什么


一个开源的**项目自动化构建工具**, 建立在Apache Ant和Apache Maven 概念的基础上，并引入了基于Groovy的特定领域语言（DSL）,而不再使用XML形式管理构建脚本

> 2.主流构建工具
* Ant 编译、测试、打包
* Maven 依赖管理、发布
* Gradle Groovy 

> 3.构建工具的作用
* 依赖管理
* 测试、打包、发布

> 4.gradle 优点
* Gradle Wrapper 防止构建环境造成的问题
* 优秀的API与工具集成
* 内置Maven与Ivy进行依赖管理
* 基于Groovy的领域专用语言DSL描述和控制构建逻辑


>构建生命周期

* 初始化
* 配置
* 执行

# Groovy语法


> Groovy

Groovy 是用于Java虚拟机的一种敏捷的动态语言，它是一种成熟的面向对象编程语言，即可以用于面向对象编程，又可以用作纯粹的脚本语言。
使用该种语言不必编写过多的代码，同时又具有闭包和动态语言中的其他特性

> Groovy 特点
* 动态语言:运行时检查数据的类型
* 基于JVM
* 扩展JDK: 对JDK中的类型进行扩展，封装方法调用简化开发
* 元编程： 注入、拦截、合并、委托方法、操作编译运行行为


> 高效的Groovy特性
* assert语句
* 可选类型定义
* 可选的括号
* 字符串

> Groovy 与java对比
* Groovy 完全兼容Java的语法
* 分号是可选的
* 类、方法默认是public的
* == 等同于equals(),不会有NullPointerExceptions异常


```java

// 可选类型定义
def version = 1

// assert
assert version == 2

// 可选的括号
println(version)
println version

//字符串

def s1 = 'ctoedu'
def s2 = "version is ${version}"
def s3 = ''' project
name
is
ctoedu
'''

// 集合api
//list
def buildTools=['ant','maven']
buildTools << 'gradle'
assert buildTools.getClass() == ArrayList
assert buildTools.size() == 3


//map

def buildYears = ['ant':2000, 'maven':2004]
buildYears.gradle = 2009

println buildYears.ant
println buildYears['gradle']
println buildYears.getClass()

```


# 安装

* 安装JDK **java -version**
* 下载Gradle, https://gradle.org
* 用户变量 GRADLE_HOME
* 环境变量 path 中增加 %GRADLE_HOME%\bin;
* gradle -version


build.gradle
```java
//构建脚本中默认都有一个Project实例
apply plugin:'java'

version = '0.1'

repositories {
	mavenCentral()
}

dependencies {
	compile 'commons-codec:commons-codec:1.6'
}

```

# 构建概要

## 构建块
Gradle 构建中的两个基本概念是项目(**project**) 和任务(**task**), 每个构建至少包含一个项目，项目中包含一个或多个任务。
在多项目构建中，一个项目可以依赖于其他项目。类似的，任务可以形成一个依赖关系图来确保他们的执行顺序

## 项目（project）
一个项目代表一个正在构建的组件（比如一个Jar文件）,当构建启动后，
Gradle会基于build.gradle实例化一个org.gradle.api.Project类，并且能够通过project变量使其隐式可用

* group \name \ version
* apply \dependencies\repositories\task
* 属性的其他配置方式：ext\gradle.properties

## task 任务
* dependsOn
* doFirst\doLast <<

> 自定义task

```java
def createDir = {
	path ->
		File dir = new File(path);
		if(!dir.exists()){
			dir.mkdirs();
		}
}

task makeJavaDir() {
	def paths = ['src/main/java','src/main/resources','src/test/java','src/test/resources']
	doFirst{
		paths.forEach(createDir)
	}
}

task makeWebDir() {
	dependsOn 'makeJavaDir'
	def paths = ['src/main/webapp','src/test/webapp']
	doLast {
		paths.forEach(createDir)
	}
}

```


## 依赖管理

概述
> 几乎所有的基于JVM的软件项目都需要依赖外部类库来重用现有的功能。自动化的依赖管理可以明确依赖的版本，可以解决因传递性依赖带来的版本冲突。

工件坐标
* group 、name 、version

常用仓库
* mavenLocal\mavenCentral\jcenter
* 自定义maven仓库
* 文件仓库

依赖的传递性
* B依赖A，如果C依赖B，那么C依赖A

依赖阶段配置
* compile、runtime
* testCompile、testRuntime

[Central Repository](http://search.maven.org)

```java
repositories{
	maven {
		url ''
	}
	mavenLocal()
	mavenCentral()
}
```

## 版本冲突

解决版本冲突
* 查看依赖报告
* 排除传递性依赖
* 强制一个版本
* 默认解决策略是选择最高的一个版本


> 修改默认解决策略
```java
configurations.all{
	resolutionStrategy{
		failOnVersionConflict()
	}
}

```

> 排除传递性依赖
```java
compile('org.hibernate:hibernate-core:3.6.3.Final') {
	exclude group:"org.slf4j", module: "slf4j-api"
	//transitive = false
}
```
> 强制指定一个版本
```java
configurations.all {
	resolutionStrategy {
		failOnVersionConflict()
		force 'org.slf4j:slf4j-api:1.7.24'
	}
}
```

## 多项目构建
在企业项目中，包层次和类关系比较复杂，把代码拆分成模块通常是最佳的实践，这需要你清晰的划分功能的边界，比如业务逻辑和数据持久层分开来。
项目符合高内聚低耦合时，模块化就变的很容易，这是一条非常好的软件开发实践

* Web -> Repository -> Model

>配置要求
* 所有的项目应用Java插件
* web子项目打包成WAR

```java
allprojects {
	apply plugin: 'java'
	sourceCompatibility = 1.8
}

subprojects {
	repositories {
		mavenCentral()
	}
	dependencies {
		
	}
}
```

```java
//Repository 依赖 Model
dependencies {
	compile project(":model")
}
```

grodle.properties

```xml
group = 'com.imooc.gradle'
version = 1.0-SNAPSHOT
```

## 自动化测试
一些开源的测试框架比如JUnit，TestNG能够帮助你编写可复用的结构化的测试，为了运行这些测试，你要先编译他们，就像编译源代码一样。测试代码的作用仅仅用于测试的情况，不应该被发布到生产环境中。
需要把源代码和测试代码分开。

### 测试配置

```java
dependencies {
	testCompile 'junit:junit:4.11'
}
```
### 测试发现
* 任何继承自junit.framework.TestCase或groovy.utils.GroovyTestCase的类
* 任何被@RunWith注解的类
* 任何至少包含一个被@Test注解的类


## 发布

```java
publishing {
	publications{
		myPublish(MavenPublication) {
			from components.java
		}
	}
	repositories {
		maven {
			name "myRepo"
			url ""
		}
	}
}

```
















