#!/bin/sh

## java env
export JAVA_HOME=/usr/local/java/jdk1.7.0_72
export JRE_HOME=$JAVA_HOME/jre

## you only need to chage next two line value
SERVICE_DIR=/home/wusc/edu/timer/report
APP_NAME=pay-timer-report

JAR_NAME=$APP_NAME\.jar

sleep 1

echo "=== invoke task, please wait"
$JRE_HOME/bin/java -jar $SERVICE_DIR/$JAR_NAME >/dev/null 2>&1 &

## until process stop to print log

while true
do
   process=`ps aux | grep $APP_NAME | grep -v grep`;
   if [ "$process" == "" ]; then
        sleep 1;
        echo "=== task complete";
        sleep 3;
        break;
   else
        echo "=== process is running, please wait";
        sleep 10;
        continue;
   fi
done

