# dubbo部署脚本

## 目录结构

```
.
├── app                                        //应用
│   ├── message                                //消息
│           ├── ctoedu-pay-app-message.sh      //脚本
│   ├── notify                                 //通知
│           ├── etocdu-pay-app-notify.sh       
│   ├── queue                                  //消息消费者
│           ├── etocdu-pay-app-notify.sh       
│
├── service                                    //服务提供者
│   ├── account                                //订单
│           ├── service-account.sh    
│   ├── accounting                             //记账系统
│           ├── service-accounting.sh    
│   ├── message                                //消息中心
│           ├── service-message.sh    
│   ├── notify                                 //通知
│           ├── service-notify.sh    
│   ├── trade                                  //交易
│           ├── service-trade.sh    
│   ├── user                                   //用户
│           ├── service-user.sh    
│   ├── start-all-service.sh                   //启动所有
│   ├── stop-all-service.sh                    //停止所有
```

# ctoedu-pay-app-message.sh 脚本

```shell
#!/bin/sh

## java env
export JAVA_HOME=/usr/local/java/jdk1.7.0_45
export JRE_HOME=$JAVA_HOME/jre

## application path
APP_DIR=/home/ctoedu/app/message
APP_NAME=ctoedu-pay-app-message

JAR_NAME=$APP_NAME\.jar

cd $APP_DIR

case "$1" in

    start)
		## check app process weather exists
		$0 stop
		echo "=== satrt $APP_NAME"
		nohup $JRE_HOME/bin/java -Xms128m -Xmx512m -jar $APP_DIR/$JAR_NAME >/dev/null 2>&1 &
        ;;

    stop)
		## check app process weather exists
		process=`ps aux | grep -w "$APP_NAME" |grep -w "java" | grep -v grep`
		if [ "$process" == "" ]; then
			echo "=== $APP_NAME process not exists"
		else
			echo "=== $APP_NAME process exists"
			echo "=== $APP_NAME process is : $process"
			## get PID by process name
			P_ID=`ps -ef | grep -w "$APP_NAME" |grep -w "java"| grep -v "grep" | awk '{print $2}'`
			echo "=== $APP_NAME process PID is:$P_ID"
			echo "=== begin kill $APP_NAME process"
			kill $P_ID
			
			sleep 3

			P_ID=`ps -ef | grep -w "$APP_NAME" |grep -w "java"| grep -v "grep" | awk '{print $2}'`
			if [ "$P_ID" == "" ]; then
				echo "=== $APP_NAME process stop success"
			else
				echo "=== $APP_NAME process kill failed, PID is:$P_ID"
				echo "=== begin kill -9 $APP_NAME process, PID is:$P_ID"
			sleep 5
				kill -9 $P_ID
			fi
		fi
        ;;

    restart)
        $0 stop
        sleep 2
        $0 start
        echo "=== restart $APP_NAME"
        ;;

    *)
        ## start
        $0 start
        ;;
esac
exit 0


```

# service-account.sh 脚本

```shell

#!/bin/sh

## java env
export JAVA_HOME=/usr/local/java/jdk1.7.0_45
export JRE_HOME=$JAVA_HOME/jre

APP_NAME=account

SERVICE_DIR=/home/ctoedu/service/$APP_NAME
SERVICE_NAME=ctoedu-pay-service-$APP_NAME
JAR_NAME=$SERVICE_NAME\.jar
PID=$SERVICE_NAME\.pid

cd $SERVICE_DIR

case "$1" in

    start)
        nohup $JRE_HOME/bin/java -Xms128m -Xmx1024m -jar $JAR_NAME >/dev/null 2>&1 &
        echo $! > $SERVICE_DIR/$PID
        echo "=== start $SERVICE_NAME"
        ;;

    stop)
        kill `cat $SERVICE_DIR/$PID`
        rm -rf $SERVICE_DIR/$PID
        echo "=== stop $SERVICE_NAME"

        sleep 5
        P_ID=`ps -ef | grep -w "$SERVICE_NAME" | grep -v "grep" | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "=== $SERVICE_NAME process not exists or stop success"
        else
            echo "=== $SERVICE_NAME process pid is:$P_ID"
            echo "=== begin kill $SERVICE_NAME process, pid is:$P_ID"
            kill -9 $P_ID
        fi
        ;;

    restart)
        $0 stop
        sleep 2
        $0 start
        echo "=== restart $SERVICE_NAME"
        ;;

    *)
        ## restart
        $0 stop
        sleep 2
        $0 start
        ;;
esac
exit 0


```


# start-all-service.sh

```shell
#!/bin/sh

## java env
export JAVA_HOME=/usr/local/java/jdk1.7.0_45
export JRE_HOME=$JAVA_HOME/jre

/home/ctoedu/service/message/service-message.sh start
sleep 5
/home/ctoedu/service/account/service-account.sh start
sleep 5
/home/ctoedu/service/accounting/service-accounting.sh start
sleep 5
/home/ctoedu/service/notify/service-notify.sh start
sleep 5
/home/ctoedu/service/trade/service-trade.sh start
sleep 5
/home/ctoedu/service/user/service-user.sh start
```

# stop-all-service.sh

```shell
#!/bin/sh

## java env
export JAVA_HOME=/usr/local/java/jdk1.7.0_45
export JRE_HOME=$JAVA_HOME/jre

/home/ctoedu/service/account/service-account.sh stop
/home/ctoedu/service/accounting/service-accounting.sh stop
/home/ctoedu/service/notify/service-notify.sh stop
/home/ctoedu/service/trade/service-trade.sh stop
/home/ctoedu/service/user/service-user.sh stop
/home/ctoedu/service/message/service-message.sh stop

```

