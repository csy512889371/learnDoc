# 分布式调度系统xxl-job 搭建


## 概述


* github 地址 https://github.com/xuxueli/xxl-job
* 
*  文档


xxl-job 本身的文档说明和代码例子比较清楚了，本文只在记录首次搭建的过程中修改的部分

## 项目配置


### 一、下载项目

* github 地址 https://github.com/xuxueli/xxl-job

* clone 项目到本地
* 使用ieda 打开项目


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/job/1.png)

* 其中 xxl-job-core 为核心包
* xxl-job-admin 为后台控制台
* xxl-jobexecutor-samples为例子



### 二、修改部分配置


修改xxl-job下的pom.xml 编译使用jdk 1.8

```
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.1</version>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
				</configuration>
			</plugin>
```


修改xxl-job-admin.properties中的数据库地址

```
xxl.job.db.driverClass=com.mysql.jdbc.Driver
xxl.job.db.url=jdbc:mysql://localhost:3306/xxl-job?useUnicode=true&characterEncoding=UTF-8
xxl.job.db.user=root
xxl.job.db.password=rj@123456
```

### 三、创建数据库

建表语句 tables_xxl_job.sql


### 四、maven 打包项目

```
clean install -Dmaven.test.skip=true -X
```

### 五、运行admin

* tomcat 版本 apache-tomcat-8.5.16-windows-x64
* 将项目部署到 tomcat\webapps\xxl-job-admin 中
* 启动tomcat



![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/job/2.png)



![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/job/3.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/job/4.png)


### 六 代码

如何在spring boot 中使用分布式调度

以下是简单配置过程即可以实现


#### spring boot 项目引入jar


```

        <jetty-server.version>9.4.6.v20170531</jetty-server.version>
        <hessian.version>4.0.7</hessian.version>

```

```

		<!-- jetty -->
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-server</artifactId>
            <version>${jetty-server.version}</version>
        </dependency>
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-util</artifactId>
            <version>${jetty-server.version}</version>
        </dependency>
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-http</artifactId>
            <version>${jetty-server.version}</version>
        </dependency>
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-io</artifactId>
            <version>${jetty-server.version}</version>
        </dependency>

        <!-- hessian -->
        <dependency>
            <groupId>com.caucho</groupId>
            <artifactId>hessian</artifactId>
            <version>${hessian.version}</version>
        </dependency>
```


#### 配置文件

* XxlJobConfig

* 其中 @ComponentScan 中的包路径为定时器代码的包路径

```

@Configuration
@ComponentScan(basePackages = "com.soft.court.web.job")
public class XxlJobConfig {
    private Logger logger = LoggerFactory.getLogger(XxlJobConfig.class);

    @Value("${xxl.job.admin.addresses}")
    private String adminAddresses;

    @Value("${xxl.job.executor.appname}")
    private String appName;

    @Value("${xxl.job.executor.ip}")
    private String ip;

    @Value("${xxl.job.executor.port}")
    private int port;

    @Value("${xxl.job.accessToken}")
    private String accessToken;

    @Value("${xxl.job.executor.logpath}")
    private String logPath;

    @Value("${xxl.job.executor.logretentiondays}")
    private int logRetentionDays;


    @Bean(initMethod = "start", destroyMethod = "destroy")
    public XxlJobExecutor xxlJobExecutor() {
        logger.info(">>>>>>>>>>> xxl-job config init.");
        XxlJobExecutor xxlJobExecutor = new XxlJobExecutor();
        xxlJobExecutor.setAdminAddresses(adminAddresses);
        xxlJobExecutor.setAppName(appName);
        xxlJobExecutor.setIp(ip);
        xxlJobExecutor.setPort(port);
        xxlJobExecutor.setAccessToken(accessToken);
        xxlJobExecutor.setLogPath(logPath);
        xxlJobExecutor.setLogRetentionDays(logRetentionDays);

        return xxlJobExecutor;
    }

}
```

application.yml

```

## xxl-job admin address list, such as "http://address" or "http://address01,http://address02"
xxl:
  job:
    admin:
      addresses: http://205.0.0.15:8080/xxl-job-admin

    ### xxl-job executor address
    executor:
      appname: splc-job-executor
      ip:
      port: 9999

      ### xxl-job log path
      logpath: D:/logs
      ### xxl-job log retention days
      logretentiondays: -1

    ### xxl-job, access token
    accessToken:

```

#### 调度代码


```
@JobHandler(value="demoJobHandler")
@Component
public class DemoJobHandler extends IJobHandler {

	@Override
	public ReturnT<String> execute(String param) throws Exception {
		XxlJobLogger.log("XXL-JOB, Hello World.");

		for (int i = 0; i < 5; i++) {
			XxlJobLogger.log("beat at:" + i);
			TimeUnit.SECONDS.sleep(2);
		}
		return SUCCESS;
	}

}
```


