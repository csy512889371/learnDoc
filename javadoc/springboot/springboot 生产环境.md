#  springboot 生产环境 部署


注意事项

> 1.去除不需要的 jar 
* 开发工具jar：spring-boot-devtools

> 2.监控一定要做好权限控制或者去除
* 控制jar：spring-boot-starter-actuator
* druid的监控
* swagger的接口
> 3、打包，跳过测试
* maven：cleanpackage -Dmaven.test.skip=true

* 脚本
```java
#!/bin/sh

## chang here
SERVICE_DIR=/var/www/ctoedu
SERVICE_NAME=blog-api-boot-jpa-data-0.0.1-SNAPSHOT
SPRING_PROFILES_ACTIVE=dev

## java env
export JAVA_HOME=/opt/jdk1.8
export JRE_HOME=${JAVA_HOME}/jre

case "$1" in 
	start)
		procedure=`ps -ef | grep -w "${SERVICE_NAME}" |grep -w "java"| grep -v "grep" | awk '{print $2}'`
		if [ "${procedure}" = "" ];
		then
			echo "start ..."
			if [ "$2" != "" ];
			then
				SPRING_PROFILES_ACTIVE=$2
			fi
			echo "spring.profiles.active=${SPRING_PROFILES_ACTIVE}"
			exec nohup ${JRE_HOME}/bin/java -Xms128m -Xmx512m -jar ${SERVICE_DIR}/${SERVICE_NAME}\.jar --spring.profiles.active=${SPRING_PROFILES_ACTIVE} >/dev/null 2>&1 &
			echo "start success"
		else
			echo "${SERVICE_NAME} is start"
		fi
		;;
		
	stop)
		procedure=`ps -ef | grep -w "${SERVICE_NAME}" |grep -w "java"| grep -v "grep" | awk '{print $2}'`
		if [ "${procedure}" = "" ];
		then
			echo "${SERVICE_NAME} is stop"
		else
			kill -9 ${procedure}
			sleep 1
			argprocedure=`ps -ef | grep -w "${SERVICE_NAME}" |grep -w "java"| grep -v "grep" | awk '{print $2}'`
			if [ "${argprocedure}" = "" ];
			then
				echo "${SERVICE_NAME} stop success"
			else
				kill -9 ${argprocedure}
				echo "${SERVICE_NAME} stop error"
			fi
		fi
		;;
		
	restart)
		$0 stop
		sleep 1
		$0 start $2
		;;  
		
	*)
		echo "usage: $0 [start|stop|restart] [dev|test|prod]"
		;;  
esac



```

# 执行脚本
./ctoedu.sh start  
./ctoedu.sh stop
./ctoedu.sh start test
./ctoedu.sh start dev
./ctoedu.sh start prod

ps -ef | grep blog-api-boot-jpa-data-0.0.1-SNAPSHOT

tail -100f logs 