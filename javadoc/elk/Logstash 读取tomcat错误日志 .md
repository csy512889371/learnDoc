# Logstash 读取tomcat错误日志 

## 概述

最近搭建了elk日志分析系统、想读取一下tomcat的错误日志、但是一个异常由于换行总是分多次存储展示、导致不是很清晰的看一个错误日志信息

* inputs 输入
* codecs 解码
* filters 过滤
* outputs 输出

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/logstach/1.jpg)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/logstach/2.jpg)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/logstach/3.png)

## 例子


安装插件 logstash-filter-multiline


```
在线安装插件

logstash-plugin.bat install logstash-filter-multiline

升级插件 
logstash-plugin.bat update logstash-filter-multiline

离线安装
logstash-plugin.bat install logstash-filter-multiline.gem

卸载
logstash-plugin.bat uninstall logstash-filter-multiline

```

## 例子

如果不是以 “[“开头的日志 都跟上一个日志合并在一起。以此类推遇到其他的多行日志也可以按照这个方法来做合并。

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
                    index => "logstash-cmis"  
                    document_type =>"tomcat"}  
      
    stdout { codec => rubydebug  }   
}  
```

## 例子一


```
input {  
    file {  
        path => "E:/install/temp/*.log"
		start_position => beginning
    }  
} 
 

output {    
    elasticsearch { hosts => localhost   
                    index => "logstash-cmis"  
                    document_type =>"tomcat"}  
      
    stdout { codec => json_lines }   
}  
```

## 例子二


```

input {  
    file {  
        path => "E:/install/temp/*.log"
		start_position => beginning
        codec => multiline {  
            pattern => "^\s"  
            what => "previous"  
        }  
    }  
} 

 filter {  
    multiline {    
		pattern => "^\s+%{TIMESTAMP_ISO8601}"  
		negate=>true    
		what=>"previous"    
	}

}

output {    
    elasticsearch { hosts => localhost   
                    index => "logstash-cmis"  
                    document_type =>"tomcat"}  
      
    stdout { codec => json_lines }   
}  
```

## 例子

```
input {  
    file{  
        path => "E:/install/temp/*.csv"  
        start_position => beginning  
    }  
 }    
    
filter {  
    grok {  
        patterns_dir => "patterns.txt"  
        match =>{ "message" => "%{DATA:name},%{DATA:person_id},%{DATA:email},%{DATA:tel},%{DATA:adress},%{DATA:from}%{S}" }  
        }  
    mutate{  
        remove_field => ["host","path","message","@version"]  
}  
}  
    
output {    
    elasticsearch { hosts => localhost   
                    index => "sgdb"  
                    document_type =>"sgdb"}  
      
    stdout { codec => rubydebug }   
}  
```

## 例子四

* 分割匹配日志


日志格式


```
2015-09-28·09:50:48·[http-bio-80-exec-13]·DEBUG·com.weitoo.server.aspect.LogAspect·-{ip:183.16.4.40,url:http://api.xx.com/server/sc/commodity/getOnlineCommodity,param:{"shopId":1000001,"needCategory":false,"needCommodityTotal":false,"searchCommodityId":1002001},return:{"status":1},cost:3.911ms}
```

```
SERVER_LOG %{DATA:year}-%{DATA:month}-%{DATA:day}\ %{DATA:hour}\:%{DATA:min}\:%{DATA:sec}\ %{DATA:level}\ %{DATA:class} -{ip:%{DATA:ip},url:%{DATA:url},param:%{DATA:param},return:%{DATA:return},cost:%{BASE10NUM:cost}
```

conf

```
input {
  file {
   type=>"xx_server_log"
   path=>"/opt/software/apache-tomcat-7.0.59/logs/catalina.out"
   codec=> multiline {
           pattern => "(^.+Exception:.+)|(^\s+at .+)|(^\s+... \d+ more)|(^\s*Caused by:.+)"
           what=> "previous"
    }

 }
}



filter {
        if [type] == "xx_server_log" {
           grok {
                 match => [ "message","%{SERVER_LOG}"]
                 patterns_dir => ["/opt/conf/logstash"]
                 remove_field => ["message"]
          }
        }
}


output {
   elasticsearch {
  host =>"xx-management"
  protocol =>"http"
  workers => 5
  template_overwrite => true

}
   stdout { codec=> rubydebug }
}
```


## 清空es数据


```
DELETE /logstash-cmis

DELETE /.kibana/index-pattern/logstash-cmis

GET /_search


```


