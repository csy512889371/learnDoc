# 项目相关信息



Group: com.timeloit.project

Group: com.timeloit.cloud

Artifact: loit-seata-storage-example

Type: maven

java version: 9

version 0.0.1.SNAPSHOT

name: timeloit Seata Example

description: timeloit Seata Example

package: com.loit.seata.example.moduleName 



## 命名规则

* 项目模块命名规则
* * loit-projectName-moduleName  
  * projectName为项目名称
  * moduleName  为模块名称

 ```
loit-seata-example
loit-seata-example-dependencies
loit-seata-example-main
loit-seata-example-web
loit-seata-example-biz
loit-seata-example-service
loit-seata-example-service-provider
loit-seata-example-service-consumer
loit-seata-example-repository
loit-seata-example-entity
loit-seata-example-common
 ```

* 包名命名规则
* * com.loit.projectName-moduleName  
  * projectName为项目名称
  * moduleName  为模块名称



loit-seata-example: pom文件

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.0.6.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <groupId>com.timeloit.project</groupId>
    <artifactId>loit-seata-example</artifactId>
    <version>0.0.1.SNAPSHOT</version>
    <packaging>pom</packaging>

	<name>timeloit Seata Example</name>
	<description>timeloit Seata Example</description>
	
	<modules>
        <module>loit-seata-example-dependencies</module>
	</modules>
	
	<properties>
        <java.version>1.8</java.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <spring-cloud.version>Finchley.SR4</spring-cloud.version>
        <spring-cloud-timeloit.version>0.0.1-SNAPSHOT</spring-cloud-timeloit.version>
    </properties>

	<dependencyManagement>
        <dependencies>
         	<dependency>
         		<groupId>com.timeloit.cloud</groupId>
				<artifactId>spring-cloud-timeloit</artifactId>
				<version>${spring-cloud-timeloit.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            
            <dependency>
				<groupId>com.timeloit.project</groupId>
				<artifactId>loit-seata-example-dependencies</artifactId>
				<version>${project.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
        </dependencies>
    </dependencyManagement>
    

    <distributionManagement>
		<repository>
			<id>nexus-releases</id>
			<name>Nexus Release Repository</name>
			<url>http://192.168.66.40:8082/repository/maven-releases/</url>
		</repository>
		<snapshotRepository>
			<id>nexus-snapshots</id>
			<name>Nexus Snapshot Repository</name>
			<url>http://192.168.66.40:8082/repository/maven-snapshots/</url>
		</snapshotRepository>
	</distributionManagement>

	<repositories>
		<repository>
			<id>nexus-loit-dev</id>
			<name>Nexus Repository</name>
			<url>http://192.168.66.40:8082/repository/maven-public/</url>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
			<releases>
				<enabled>true</enabled>
			</releases>
		</repository>
	</repositories>
	<pluginRepositories>
		<pluginRepository>
			<id>nexus-loit-dev</id>
			<name>Nexus Plugin Repository</name>
			<url>http://192.168.66.40:8082/repository/maven-public/</url>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
			<releases>
				<enabled>true</enabled>
			</releases>
		</pluginRepository>
	</pluginRepositories>

</project>
```



loit-seata-example-dependencies: pom.xml



```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <parent>
        <artifactId>spring-cloud-dependencies-parent</artifactId>
        <groupId>org.springframework.cloud</groupId>
        <version>2.0.6.RELEASE</version>
        <relativePath/>
    </parent>

    <groupId>com.timeloit.cloud</groupId>
    <artifactId>loit-seata-example-dependencies:</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>pom</packaging>

    <name>TimeLoit Seata Example</name>
    <description>TimeLoit Seata Example</description>

    <properties>
        
    </properties>


    <dependencyManagement>
        <dependencies>
            <!--tools-->
                   
            <!--Own dependencies -->
            
            <!--Own dependencies - Starters -->
            
        </dependencies>
    </dependencyManagement>

   <build>
        <pluginManagement>
            <plugins>

                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                    <version>${spring-boot.version}</version>
                    <configuration>
                        <mainClass>com.loit.LoitSeataExampleApplication</mainClass>
                    </configuration>
                </plugin>

            </plugins>
        </pluginManagement>

        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>${maven-compiler-plugin.version}</version>
                <configuration>
                    <source>${java.version}</source>
                    <target>${java.version}</target>
                    <encoding>${project.build.sourceEncoding}</encoding>
                    <compilerVersion>${java.version}</compilerVersion>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
```



loit-seata-example-common: pom.xml



```
	<packaging>jar</packaging>
    <dependencies>


    </dependencies>
```



loit-seata-example-main: pom.xml

```
    <packaging>jar</packaging>

    <dependencies>


    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
```







## 服务引入



* 服务发现
* rpc 调用 
* 熔断？
* actuator
* swagger

```
@EnableDiscoveryClient
@EnableFeignClients
```





```
 <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>


        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>


        <!-- nacos -->
        <dependency>
            <groupId>com.timeloit.cloud</groupId>
            <artifactId>spring-cloud-timeloit-nacos-discovery</artifactId>
        </dependency>
        
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger-ui</artifactId>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
        </dependency>

```

其他

```
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-freemarker</artifactId>
        </dependency>
```

http://localhost:9091/swagger-ui.html

http://localhost:9091/order/user

http://localhost:9091/order/placeOrder/commit

http://localhost:9091/order/placeOrder/rollback

```
java -jar nacos-client-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
```

解决办法 ：设置Naming客户端的日志级别
com.alibaba.nacos.config.log.level(-D) Naming客户端的日志级别 info,error,warn等 info >= 1.0.0

-Dcom.alibaba.nacos.naming.log.level=warn

spring-cloud-timeloit

```
<groupId>com.timeloit.cloud</groupId>
<artifactId>spring-cloud-timeloit</artifactId>
<version>1.0-SNAPSHOT</version>
```

```
<packaging>pom</packaging>
<name>Spring Cloud Timeloit</name>
```





```
 <groupId>com.timeloit.cloud</groupId>
 <artifactId>spring-cloud-timeloit-dependencies</artifactId>
 <version>1.0-SNAPSHOT</version>
```



```
 <groupId>com.timeloit.cloud</groupId>
spring-cloud-timeloit-nacos-discovery
 <version>1.0-SNAPSHOT</version>
 <name>Spring Cloud Timeloit Nacos Discovery</name>
```



spring-cloud-timeloit-seata



spring-cloud-timeloit-examples

spring-cloud-timeloit-sentinel

```
spring.profiles.active=devnacos
```

```
com.loit.cloud.nacos
```

```
@SpringBootApplication(scanBasePackages = {"com.loit","com.loit.cloud.nacos"})
```

