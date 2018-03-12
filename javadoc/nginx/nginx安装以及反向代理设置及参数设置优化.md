# nginx安装以及反向代理设置及参数设置优化

## 一、	介绍
* Nginx是多进程单线程模型，即启动的工作进程只有一个进程响应客户端请求，不像apache可以在一个进程内启动多个线程响应可请求，因此在内存占用上比apache小的很多。Nginx维持一万个非活动会话只要2.5M内存。Nginx和Mysql是CPU密集型的，就是对CPU的占用比较大，默认session在本地文件保存，支持将session保存在memcache，但是memcache默认支持最大1M的课hash对象。
* nginx的版本分为开发版、稳定版和过期版，nginx以功能丰富著称，它即可以作为http服务器，也可以作为反向代理服务器或者邮件服务器，能够快速的响应静态网页的请求，支持FastCGI/SSL/Virtual Host/URL Rwrite/Gzip/HTTP Basic Auth等功能，并且支持第三方的功能扩展。
* nginx安装可以使用yum或源码安装，推荐使用源码，一是yum的版本比较旧，二是使用源码可以自定义功能，方便业务的上的使用，源码安装需要提前准备标准的编译器，GCC的全称是（GNU Compiler collection），其有GNU开发，并以GPL即LGPL许可，是自由的类UNIX即苹果电脑Mac OS X操作系统的标准编译器，因为GCC原本只能处理C语言，所以原名为GNU C语言编译器，后来得到快速发展，可以处理C++,Fortran，pascal，objective-C，java以及Ada等其他语言，此外还需要Automake工具，以完成自动创建Makefile的工作，Nginx的一些模块需要依赖第三方库，比如pcre（支持rewrite），zlib（支持gzip模块）和openssl（支持ssl模块）

## 二、	下载nginx

```shell
cd /data/program/software
wget http://nginx.org/download/nginx-1.12.1.tar.gz
```

## 三、	解压
```shell
tar -zxvf nginx-1.12.1.tar.gz
```

## 四、	安装依赖
* 安装PCRE:  yum -y install pcre-devel
* 安装zlib:  yum install -y zlib-devel

## 五、	编译并且安装nginx
```shell
cd /data/program/software/nginx-1.12.1
```
* 初始化配置：./configure
* 编译：make install

安装成功后有四个主要的目录如下：

* 1、conf：保存nginx所有的配置文件，其中nginx.conf是nginx服务器的最核心最主要的配置文件，其他的.conf则是用来配置nginx相关的功能的，例如fastcgi功能使用的是fastcgi.conf和fastcgi_params两个文件，配置文件一般都有个样板配置文件，是文件名.default结尾，使用的使用将其复制为并将default去掉即可。
* 2、html目录中保存了nginx服务器的web文件，但是可以更改为其他目录保存web文件,另外还有一个50x.html的web文件是默认的错误页面提示页面。
* 3、logs：用来保存nginx服务器的访问日志错误日志等日志，logs目录可以放在其他路径，比如/var/logs/nginx里面。
* 4、sbin：保存nginx二进制启动脚本，可以接受不同的参数以实现不同的功能。
* 5、成功之后发现多了如下目录：

```shell
/usr/local/nginx
```

## 六、	启动nginx
```shell
cd /usr/local/nginx/sbin
```
* 执行./nginx
* 访问http://localhost如果出现如下界面说明成功：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/nginx/1.png)

常用命令：
```shell
启动：./nginx
停止：./nginx -s stop
重启：./nginx -s reopen
```

验证端口是否开启：
```shell
[root@dst6 ~]# ps -ef|grep nginx
root      5566     1  0 Nov06 ?        00:00:00 nginx: master process ./nginx  主进程，只有一个
nginx     5567  5566  0 Nov06 ?        00:00:00 nginx: worker process   工作进程，默认只有一个，可以通过修改nginx.conf中的worker_processes  1; 参数启动多个工作进程
nginx     5568  5566  0 Nov06 ?        00:00:00 nginx: worker process
nginx     5569  5566  0 Nov06 ?        00:00:00 nginx: worker process
nginx     5570  5566  0 Nov06 ?        00:00:00 nginx: worker process
root     10970 10950  0 01:10 pts/1    00:00:00 grep nginx
```
## 七、	配置反向代理

### 1、	新建nginx.conf，加入如下配置

```shell
cd /usr/local/nginx/conf/

# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections  1024;
}


http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /usr/local/nginx/conf/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /usr/local/nginx/conf/conf.d/*.conf;
}
```

### 2、	新建代理文件
```shell
cd /usr/local/nginx/conf/conf.d
touch open-falcon.conf
加入如下配置：

server {
    listen       80;
    server_name  118.178.230.175;
    access_log /var/log/nginx/openfalcon_access_log main;
    client_max_body_size 60M;
    client_body_buffer_size 512k;
    location / {
        proxy_pass      http://localhost:8081;
        proxy_redirect  off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }


}
```


## 八、	参数设置及优化

### 1、	网络连接优化
只能在events模块设置，用于防止在同一一个时刻只有一个请求的情况下，出现多个睡眠进程会被唤醒但只能有一个进程可获得请求的尴尬，如果不优化，在多进程的nginx会影响以部分性能。
```shell
events {
accept_mutex on; #优化同一时刻只有一个请求而避免多个睡眠进程被唤醒的设置，on为防止被同时唤醒，默认为off，因此nginx刚安装完以后要进行适当的优化。
}
```

### 2、	设置是否同时接受多个网络连接
只能在events模块设置，Nginx服务器的每个工作进程可以同时接受多个新的网络连接，但是需要在配置文件中配置，此指令默认为关闭，即默认为一个工作进程只能一次接受一个新的网络连接，打开后几个同时接受多个，配置语法如下：
```shell
events {
accept_mutex on;
multi_accept on; #打开同时接受多个新网络连接请求的功能。
}
```

### 3、	隐藏nginx版本号
当前使用的nginx可能会有未知的漏洞，如果被黑客使用将会造成无法估量的损失，但是我们可以将nginx的版本隐藏，如下：
```shell
server_tokens off; #在http 模块当中配置
```

### 4、选择事件驱动模型
```shell
events {
accept_mutex on;
multi_accept on;
use epoll; #使用epoll事件驱动，因为epoll的性能相比其他事件驱动要好很多
}
```

### 5、	配置单个工作进程的最大连接数
通过worker_connections number；进行设置，numebr为整数，number的值不能大于操作系统能打开的最大的文件句柄数，使用ulimit -n可以查看当前操作系统支持的最大文件句柄数，默认为为1024.
```shell
events {
    worker_connections  102400; #设置单个工作进程最大连接数102400
    accept_mutex on;
    multi_accept on;
    use epoll;
}
```

### 6、	定义MIME-Type
在浏览器当中可以显示的内容有HTML/GIF/XML/Flash等内容，浏览器为取得这些资源需要使用MIME Type，即MIME是网络资源的媒体类型，Nginx作为Web服务器必须要能够识别全部请求的资源类型，在nginx.conf文件中引用了一个第三方文件，使用include导入：
```shell
include mime.types;
default_type application/octet-stream;
```

### 7、	自定义访问日志
访问日志是记录客户端即用户的具体请求内容信息，全局配置模块中的error_log是记录nginx服务器运行时的日志保存路径和记录日志的level，因此有着本质的区别，而且Nginx的错误日志一般只有一个，但是访问日志可以在不同server中定义多个，定义一个日志需要使用access_log指定日志的保存路径，使用log_format指定日志的格式，格式中定义要保存的具体日志内容：
```shell
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
```

### 8、	配置允许sendfile方式传输文件
是由后端程序负责把源文件打包加密生成目标文件，然后程序读取目标文件返回给浏览器；这种做法有个致命的缺陷就是占用大量后端程序资源，如果遇到一些访客下载速度巨慢，就会造成大量资源被长期占用得不到释放（如后端程序占用的CPU/内存/进程等），很快后端程序就会因为没有资源可用而无法正常提供服务。通常表现就是 nginx报502错误，而sendfile打开后配合location可以实现有nginx检测文件使用存在，如果存在就有nginx直接提供静态文件的浏览服务，因此可以提升服务器性能.
可以配置在http、server或者location模块，配置如下：
```shell
sendfile        on;
sendfile_max_chunk 512k;   #Nginxg工作进程每次调用sendfile()传输的数据最大不能超出这个值，默认值为0表示无限制，可以设置在http/server/location模块中。

```

### 9、	配置nginx工作进程最大打开文件数
可以设置为linux系统最大打开的文件数量一致，在全局模块配置
```shell
worker_rlimit_nofile 65535;
```

### 10、会话保持时间
用户和服务器建立连接后客户端分配keep-alive链接超时时间，服务器将在这个超时时间过后关闭链接，我们将它设置低些可以让ngnix持续工作的时间更长，1.8.1默认为65秒，一般不超过120秒。
```shell
 keepalive_timeout  65 60;  #后面的60为发送给客户端应答报文头部中显示的超时时间设置为60s：如不设置客户端将不显示超时时间。
Keep-Alive:timeout=60  #浏览器收到的服务器返回的报文

```

如果设置为0表示关闭会话保持功能，将如下显示：
```shell
Connection:close  #浏览器收到的服务器返回的报文
```

### 11、配置网络监听

使用命令listen，可以配置监听IP+端口，端口或监听unix socket:

```shell
listen       8090;   #监听本机的IPV4和IPV6的8090端口，等于listen *:8000
listen       192.168.0.1:8090; #监听指定地址的8090端口
listen     Unix:/www/file  #监听unix socket
```



