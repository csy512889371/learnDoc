# nginx 80端口映射多个应用

## 一、配置文件

>* worker_connections 默认最大的并发数为1024，如果你的网站访问量过大，已经远远超过1024这个并发数，那你就要修改worker_connecions这个值 ，这个值越大，并发数也有就大。当然，你一定要按照你自己的实际情况而定，也不能设置太大，不能让你的CPU跑满100%。
>* worker_processes 一般来说，设置成CPU核的数量即可



nginx.conf

```xml
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    
	fastcgi_buffer_size 128k;
    fastcgi_buffers 4 256k;
    fastcgi_busy_buffers_size 256k;
    fastcgi_temp_file_write_size 256k;

    gzip on;
    gzip_min_length  1k;
    gzip_buffers     4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types       text/plain application/x-javascript text/css application/xml;
    gzip_vary on;

    server {
        listen       80;
        server_name  localhost ; 

        index index.jsp index.html;

        location / {
             proxy_pass http://127.0.0.1:8080;
             proxy_set_header X-Real-IP $remote_addr;
             proxy_redirect          off;
             proxy_set_header        Host            $host;
             proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
             client_max_body_size    10m;
             client_body_buffer_size 128k;
             proxy_buffers           32 4k;
             proxy_connect_timeout   3;
             proxy_send_timeout      30;
             proxy_read_timeout      30;
        }
		
		location /server2 {
                proxy_pass http://127.0.0.1:9080;
                proxy_set_header X-Real-IP $remote_addr;
                  proxy_redirect          off;
             proxy_set_header        Host            $host;
             proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
             client_max_body_size    10m;
             client_body_buffer_size 128k;
             proxy_buffers           32 4k;
             proxy_connect_timeout   3;
             proxy_send_timeout      30;
             proxy_read_timeout      30;
				}
		}

}

```

## 二、映射server1

80 端口映射到 8080 tomcat 的ROOT 下
![image](https://github.com/csy512889371/learnDoc/blob/master/image/nginx_server1.png)

## 三、映射server2

80/server2 端口映射到 9080 tomcat 的webApp/server2下
![image](https://github.com/csy512889371/learnDoc/blob/master/image/nginx_server2.png)

