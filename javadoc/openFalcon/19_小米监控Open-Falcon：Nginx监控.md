# 小米监控Open-Falcon：Nginx监控


## 一、	工作原理
>* ngx_metric是借助lua-nginx-module的log_by_lua功能实现nginx请求的实时分析，然后借助ngx.shared.DICT存储中间结果。最后通过外部python脚本取出中间结果加以计算、格式化并输出。按falcon格式输出的结果可直接push到falcon agent。
>* ngx_metric(Nginx-Metric) -- Open-Falcon的Nginx Web Server请求数据采集工具，主要包括流量大小、响应时间、异常请求统计等。

## 二、	汇报字段

```xml
key	tag	type	note
query_count	api	GAUGE	nginx 正常请求(status code < 400)数量
error_count	api,errcode	GAUGE	nginx 异常请求(status code >= 400)数量
error_rate	api	GAUGE	nginx 异常请求比例
latency_{50,75,95,99}th	api	GAUGE	nginx 请求平均响应时间，按百分位统计
upstream_contacts	api	GAUGE	nginx upstream 请求次数
upstream_latency_{50,75,95,99}th	api	GAUGE	nginx upstream平均响应时间，按百分位统计
api tag: 即nginx request uri，各统计项按照uri区分。当api为保留字__serv__时，代表nginx所有请求的综合统计
```

error_count、upstream统计项根据实际情况，如果没有则不会输出

## 三、	安装部署
* 1、下载地址：https://github.com/GuyCheung/falcon-ngx_metric
* 2、下载：cd /data/program/software
* 3、git clone https://github.com/GuyCheung/falcon-ngx_metric.git
* 4、lua文件部署：
```shell
cd /usr/local/nginx/
mkdir modules
cp -r /data/program/software/falcon-ngx_metric/lua/* /usr/local/nginx/modules
```
* 5、nginx配置文件加载：
```shell
cp /data/program/software/falcon-ngx_metric/ngx_metric.conf /usr/local/nginx/conf/conf.d
```
* 6、启动测试：python nginx_collect.py --format=falcon –service=dst6-nginx
* 7、将启动脚本加入到crontab

## 四、	参数解释

nginx_collect.py 脚本参数说明

```shell
python nginx_collect.py -h

Usage: nginx_collect.py [options]

Options:
  -h, --help            show this help message and exit
  --use-ngx-host        use the ngx collect lib output host as service column,
                        default read self
  --service=SERVICE     logic service name(endpoint in falcon) of metrics, use
                        nginx service_name as the value when --use-ngx-host
                        specified. default is ngx_metric
  --format=FORMAT       output format, valid values "odin|falcon", default is
                        odin
  --falcon-step=FALCON_STEP
                        Falcon only. metric step
  --falcon-addr=FALCON_ADDR
                        Falcon only, the addr of falcon push api
  --ngx-out-sep=NGX_OUT_SEP
                        ngx output status seperator, default is "|"
--use-ngx-host: 使用nginx配置里的service_name作为采集项的endpoint
--service: 手动设置endpoint值，当指定--use-ngx-host时，该参数无效
--format: 采集数据输出格式，对接falcon请使用--format=falcon
--falcon-step: falcon step设置，请设置为python脚本调用频率，默认是60
--falcon-addr: falcon push接口设置，设置该参数数据直接推送，不再输出到终端。需要安装requests模块

```
