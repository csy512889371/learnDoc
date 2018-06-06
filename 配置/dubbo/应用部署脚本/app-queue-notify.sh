#!/bin/sh

## java env
export JAVA_HOME=/usr/local/java/jdk1.7.0_72
export JRE_HOME=$JAVA_HOME/jre

## you only need to change next two parameters value
APP_DIR=/home/wusc/edu/app/queue-notify
APP_NAME=pay-app-queue-notify

JAR_NAME=$APP_NAME\.jar

cd $APP_DIR

## check app process weather exists
process=`ps aux | grep -w "$APP_NAME" | grep -v grep`
if [ "$process" == "" ]; then
    echo "=== $APP_NAME process not exists"
else
    echo "=== $APP_NAME process exists"
    echo "=== $APP_NAME process is : $process"
    ## get PID by process name
    P_ID=`ps -ef | grep -w "$APP_NAME" | grep -v "grep" | awk '{print $2}'`
    echo "=== $APP_NAME process PID is:$P_ID"
    echo "=== begin kill $APP_NAME process"
    kill $P_ID
	
    sleep 3

    P_ID=`ps -ef | grep -w "$APP_NAME" | grep -v "grep" | awk '{print $2}'`
    if [ "$P_ID" == "" ]; then
        echo "=== $APP_NAME process stop success"
    else
        echo "=== $APP_NAME process kill failed, PID is:$P_ID"
        echo "=== begin kill -9 $APP_NAME process, PID is:$P_ID"
	sleep 3
        kill -9 $P_ID
    fi
fi

sleep 2
echo "=== begin start $APP_NAME"
$JRE_HOME/bin/java -Xms128m -Xmx512m -jar $APP_DIR/$JAR_NAME >/dev/null 2>&1 &

