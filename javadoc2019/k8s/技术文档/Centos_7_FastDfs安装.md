#### fastdfs install

##### 安装 libfastcommon

```
yum install make cmake gcc gcc-c++
```

```
yum -y install libevent
```

```
# cd /usr/local/src/
tar -zxvf libfastcommonV1.0.7.tar.gz 
cd libfastcommon-1.0.7/


```

```
./make.sh
./make.sh install


mkdir -p /usr/lib64
install -m 755 libfastcommon.so /usr/lib64
mkdir -p /usr/include/fastcommon
install -m 644 common_define.h hash.h chain.h logger.h base64.h shared_func.h pthread_func.h ini_file_reader.h _os_bits.h sockopt.h sched_thread.h http_func.h md5.h local_ip_func.h avl_tree.h ioevent.h ioevent_loop.h fast_task_queue.h fast_timer.h process_ctrl.h fast_mblock.h connection_pool.h /usr/include/fastcommon

```


```
# ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
# ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so
```


#### 安装 FastDFS

```
cd /usr/local/src/
tar -zxvf FastDFS_v5.05.tar.gz 

cd FastDFS
```

```
# ./make.sh
# ./make.sh install

mkdir -p /usr/bin
mkdir -p /etc/fdfs
cp -f fdfs_trackerd /usr/bin
if [ ! -f /etc/fdfs/tracker.conf.sample ]; then cp -f ../conf/tracker.conf /etc/fdfs/tracker.conf.sample; fi
mkdir -p /usr/bin
mkdir -p /etc/fdfs
cp -f fdfs_storaged  /usr/bin
if [ ! -f /etc/fdfs/storage.conf.sample ]; then cp -f ../conf/storage.conf /etc/fdfs/storage.conf.sample; fi
mkdir -p /usr/bin
mkdir -p /etc/fdfs
mkdir -p /usr/lib64
cp -f fdfs_monitor fdfs_test fdfs_test1 fdfs_crc32 fdfs_upload_file fdfs_download_file fdfs_delete_file fdfs_file_info fdfs_appender_test fdfs_appender_test1 fdfs_append_file fdfs_upload_appender /usr/bin
if [ 0 -eq 1 ]; then cp -f libfdfsclient.a /usr/lib64; fi
if [ 1 -eq 1 ]; then cp -f libfdfsclient.so /usr/lib64; fi
mkdir -p /usr/include/fastdfs
cp -f ../common/fdfs_define.h ../common/fdfs_global.h ../common/mime_file_parser.h ../common/fdfs_http_shared.h ../tracker/tracker_types.h ../tracker/tracker_proto.h ../tracker/fdfs_shared_func.h ../storage/trunk_mgr/trunk_shared.h tracker_client.h storage_client.h storage_client1.h client_func.h client_global.h fdfs_client.h /usr/include/fastdfs
if [ ! -f /etc/fdfs/client.conf.sample ]; then cp -f ../conf/client.conf /etc/fdfs/client.conf.sample; fi

```

```
# ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so
# ln -s /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so
```


```

拷贝、黏贴

把/etc/init.d/fdfs_storaged 和/etc/init.d/fdfs_tracker 两个脚本中的/usr/local/bin 修改成/usr/bin
```


##### 配置 FastDFS 跟踪器( 192.168.111.119)

```
cd /etc/fdfs/
cp tracker.conf.sample tracker.conf

# vi /etc/fdfs/tracker.conf
```


```
disabled=false

port=22122
base_path=/fastdfs/tracker
```


```
mkdir -p /fastdfs/tracker
```

##### 防火墙

查看firewall服务状态

```
systemctl status firewalld

```
查看firewall的状态

```
firewall-cmd --state
```

开启、重启、关闭、firewalld.service服务

```
# 开启
service firewalld start
# 重启
service firewalld restart
# 关闭
service firewalld stop
```

查看防火墙规则
```
firewall-cmd --list-all 
```


```
# 查询端口是否开放
firewall-cmd --query-port=22122/tcp
# 开放80端口
firewall-cmd --permanent --add-port=22122/tcp


#重启防火墙(修改配置后要重启防火墙)
firewall-cmd --reload

# 参数解释
1、firwall-cmd：是Linux提供的操作firewall的一个工具；
2、--permanent：表示设置为持久；
3、--add-port：标识添加的端口；
```


启动 Tracker：

```
/etc/init.d/fdfs_trackerd start
```

查看 FastDFS Tracker 是否已成功启动

```
ps -ef | grep fdfs
```
关闭 Tracker

```
/etc/init.d/fdfs_trackerd stop
```

设置 FastDFS 跟踪器开机启动

```
vi /etc/rc.d/rc.local

添加

## FastDFS Tracker
/etc/init.d/fdfs_trackerd start
```

##### 配置 FastDFS 存储 192.168.111.123

```
cd /etc/fdfs/
cp storage.conf.sample storage.conf
vi /etc/fdfs/storage.conf
```

```
disabled=false
port=23000
base_path=/fastdfs/storage
store_path0=/fastdfs/storage
tracker_server=192.168.111.119:22122
http.server_port=8888
```

```
mkdir -p /fastdfs/storage
```
防火墙中打开存储器端口（默认为 23000）



```
# 查询端口是否开放
firewall-cmd --query-port=23000/tcp

# 开放23000端口
firewall-cmd --permanent --add-port=23000/tcp
service firewalld restart

启动 Storage：
/etc/init.d/fdfs_storaged start

ps -ef | grep fdfs
```

关闭 Storage：

```
/etc/init.d/fdfs_storaged stop
```

设置 FastDFS 存储器开机启动：

```
 vi /etc/rc.d/rc.local
```

```
## FastDFS Storage
/etc/init.d/fdfs_storaged start
```


##### 文件上传测试 192.168.111.119

```
# cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf
# vi /etc/fdfs/client.conf
base_path=/fastdfs/tracker
tracker_server=192.168.111.119:22122
```

```
 /usr/bin/fdfs_upload_file /etc/fdfs/client.conf /usr/local/src/FastDFS_v5.05.tar.gz

 返回
 group1/M00/00/00/wKhve1yIr3KAP8e-AAVFOL7FJU4.tar.gz
```

查看文件 192.168.111.123

cd /fastdfs/storage

##### fastdfs-nginx-module 192.168.111.123

```
# cd /usr/local/src/
# tar -zxvf fastdfs-nginx-module_v1.16.tar.gz
```

```
# cd fastdfs-nginx-module/src
# vi config
```
修改 fastdfs-nginx-module 的 config 配置文件

```
CORE_INCS="$CORE_INCS /usr/local/include/fastdfs /usr/local/include/fastcommon/"

改成：


CORE_INCS="$CORE_INCS /usr/include/fastdfs /usr/include/fastcommon/"
```

##### 安装 Nginx nginx-1.12.2.tar.gz

上传到/usr/local/src 目录

```
# yum install gcc gcc-c++ make automake autoconf libtool pcre* zlib openssl openssl-devel
```

```
# cd /usr/local/src/
# tar -zxvf nginx-1.12.2.tar.gz
# cd nginx-1.12.2
# ./configure --add-module=/usr/local/src/fastdfs-nginx-module/src
# make && make install
```

复制 fastdfs-nginx-module 源码中的配置文件到/etc/fdfs 目录，并修改

```
# cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/
# vi /etc/fdfs/mod_fastdfs.conf
```

```
connect_timeout=10
base_path=/tmp
tracker_server=192.168.111.119:22122
storage_server_port=23000
group_name=group1
url_have_group_name = true
store_path0=/fastdfs/storage
```


复制 FastDFS 的部分配置文件到/etc/fdfs 目录

```
# cd /usr/local/src/FastDFS/conf
# cp http.conf mime.types /etc/fdfs/
```

```
 ln -s /fastdfs/storage/data/ /fastdfs/storage/data/M00
```

/usr/local/nginx/conf/nginx.conf

```
    server {
        listen       8888;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location ~/group([0-9])/M00{#alias/fastdfs/storage/data;
            ngx_fastdfs_module;
        }
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root html;
        }
    }

```

防火墙中打开 Nginx 的 8888 

```
# 查询端口是否开放
firewall-cmd --query-port=8888/tcp

# 8888
firewall-cmd --permanent --add-port=8888/tcp
service firewalld restart
```

启动 Nginx

```
/usr/local/nginx/sbin/nginx


/usr/local/nginx/sbin/nginx -s reload
```

Nginx 开机启动

```
# vi /etc/rc.local

/usr/local/nginx/sbin/nginx
```

##### 进行测试
```
 /usr/bin/fdfs_test /etc/fdfs/client.conf upload /home/rj/1.jpg
```


##### 命令

```
/usr/local/nginx/sbin/nginx -s reload

/etc/init.d/fdfs_storaged stop
/etc/init.d/fdfs_storaged start

/etc/init.d/fdfs_trackerd stop
/etc/init.d/fdfs_trackerd start
```


##### 文件名

然后在url后面增加一个参数，指定原始文件名

```
http://192.168.111.123:8888/group1/M00/00/00/wKhve1yIslaAHg1gAABSlAD3VCM170_big.jpg?attname=filename.jpg
```

```
    server {
        listen       8888;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location ~/group([0-9])/M00{#alias/fastdfs/storage/data;
            if ($arg_attname ~ "^(.*)") {
                add_header Content-Disposition "attachment;filename=$arg_attname";
            }
            ngx_fastdfs_module;
        }
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root html;
        }
    }

```


#### 开机启动

```$xslt
chmod +x /etc/rc.d/rc.local

systemctl enable rc-local.service

systemctl start rc-local.service

```

#### 排错

/usr/bin/fdfs_monitor /etc/fdfs/storage.conf



