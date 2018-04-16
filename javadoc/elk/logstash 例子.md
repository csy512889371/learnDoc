# logstash 例子

## 概述

## 1、收集tomcat日志一

* 使用 [ 作为日志切割

```
 input {  

	file { 
		type => "es_error"
        path => "E:/install/tempTwo/*.log"
		start_position => beginning
		codec => multiline {
			pattern => "^\["
			negate => true
			what => "previous"
		}
    }  
	
    file { 
		type => "tomcat_error"
        path => "E:/install/temp/*.log"
		start_position => beginning
		codec => multiline {
			pattern => "^\["
			negate => true
			what => "previous"
		}
    }  
} 


output {   

	if [type]  == "es_error" {
	    elasticsearch { hosts => localhost   
                    index => "logstash-es-%{+YYYY.MM.dd}"}  
	}
	
	if [type]  == "tomcat_error" {
	    elasticsearch { hosts => localhost   
                    index => "logstash-tomcat-%{+YYYY.MM.dd}"}  
	}

      
    stdout { codec => rubydebug  }   
}  
```

## 2、收集tomcat日志二

```
input {  
    file { 
		type => "tomcat_error"
        path => "E:/install/temp/*.log"
		start_position => beginning
    }  
} 

filter {
    if [type] == "tomcat_error" {
            multiline {
                      pattern => "^[^\[]"
                      what => "previous"
                  }
                mutate {
           split => ["message", "|"]
        }
        grok {
            match => { 
                           "message" => "(?m)%{TIMESTAMP_ISO8601:logtime}"
            }
        }
    }
}
 

output {    
    elasticsearch { hosts => localhost   
                    index => "logstash-cmis-%{+YYYY.MM.dd}"}  
      
    stdout { codec => rubydebug  }   
}  
```

## 3、收集nginx日志

设置nginx 的日志格式为json

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/logstach/3.jpg)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/logstach/4.jpg)


```
input {  

	file { 
		type => "access_log"
        path => "E:/install/tempTwo/*.log"
		codec => json
		start_position => beginning
    }  
	 
} 
```


## 4、收集syslog日志

* logstash 监听tcp udp的514 端口

* vim /etc/rsyslog.conf 最后增加

```
*.* @@192.168.0.11:514
```

```
input {  
	syslog { 
		type => "sys_log"
        host => "192.168.0.1"
		port => "514"
    } 
} 

```


## 4、收集tcp日志

```
input {  
	tcp { 
		type => "tcp_log"
        host => "192.168.0.11"
		port => "6666"
    } 
} 

```

安装 nc

```
nc 192.168.56.11 6666 < /etc/resolv.conf
```


## 收集slowlog-grok

常用表达式

* 缺点占用cpu

logstash-patterns-core

```
https://github.com/logstash-plugins/logstash-patterns-core/tree/master/patterns


https://github.com/logstash-plugins/logstash-patterns-core/blob/master/patterns/grok-patterns
```

## 使用redis解耦

* es停掉不影响日志收集
* 并发写日志多的时候redis做反冲
* 对redis可以加预警监控key对应的数据量
* 对比较复杂的日志收集可以先存储在redis 然后通过python处理后存到es 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/logstach/4.png)


## 上线

### 日志分类
* 系统日志 syslog  logstash syslog插件
* 访问日志 nginx   logstash codec json
* 错误日志 file    logstash file+ multiline
* 运行日志 file    logstash codec json
* 设备日志 syslog  logstash syslog 插件
* debug 日志       logstash debug 日志

### 日志标准化

* 1. 路径 固定
* 2. 格式 尽量 json

