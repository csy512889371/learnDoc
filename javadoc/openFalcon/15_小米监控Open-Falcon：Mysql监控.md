# 15_小米监控Open-Falcon：Mysql监控

## 一、	工作原理
* 在数据采集一节中我们介绍了常见的监控数据源。open-falcon作为一个监控框架，可以去采集任何系统的监控指标数据，只要将监控数据组织为open-falcon规范的格式就OK了。
* MySQL的数据采集可以通过mymon来做。
* mymon是一个cron，每分钟跑一次，配置文件中配置了数据库连接地址，mymon连到该数据库，采集一些监控指标，比如global status, global variables, slave status等等，然后组装为open-falcon规定的格式的数据，post给本机的falcon-agent。falcon-agent提供了一个http接口，使用方法可以参考数据采集中的例子。比如我们有1000台机器都部署了MySQL实例，可以在这1000台机器上分别部署1000个cron，即：与数据库实例一一对应。

## 二、	配置安装

* 下载地址：https://github.com/open-falcon/mymon

安装：
```shell

设置$GOPATH：export $GOPATH =/src/

mkdir -p $GOPATH/src/github.com/open-falcon
cd $GOPATH/src/github.com/open-falcon
git clone https://github.com/open-falcon/mymon.git

cd mymon
go get ./...
go build -o mymon

echo '* * * * * cd $GOPATH/src/github.com/open-falcon/mymon && ./mymon -c etc/mon.cfg' > /etc/cron.d/mymon

```


```shell
执行go get ./…的时候出现如下错误：
package golang.org/x/crypto/ssh/terminal: unrecognized import path "golang.org/x/crypto/ssh/terminal" (https fetch: Get https://golang.org/x/crypto/ssh/terminal?go-get=1: dial tcp 216.239.37.1:443: i/o timeout)
package golang.org/x/sys/unix: unrecognized import path "golang.org/x/sys/unix" (https fetch: Get https://golang.org/x/sys/unix?go-get=1: dial tcp 216.239.37.1:443: i/o timeout)
解决办法：
方法一：直接下载文件，然后把解压出来的文件夹放在src里。
下载地址：https://pan.baidu.com/s/1boVAtJp

方法二：直接从git上下载对应文件放到src下面。
mkdir -p $GOPATH/src/golang.org/x
cd $GOPATH/src/golang.org/x
git clone https://github.com/golang/crypto.git
git clone https://github.com/golang/sys.git

```


修改配置文件：

```shell
/src/github.com/open-falcon/mymon/etc
vi mon.cfg
```


```xml
[default]
    log_file=mymon.log # 日志路径和文件名
    # Panic 0
    # Fatal 1
    # Error 2
    # Warn 3
    # Info 4
    # Debug 5
    log_level=4 # 日志级别

    falcon_client=http://127.0.0.1:1988/v1/push # falcon agent连接地址

    #自定义endpoint
    endpoint=127.0.0.1 #若不设置则使用OS的hostname

    [mysql]
    user=root # 数据库用户名
    password= # 数据库密码
    host=127.0.0.1 # 数据库连接地址
    port=3306 # 数据库端口

```

如下图采集成功：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/19.png)
