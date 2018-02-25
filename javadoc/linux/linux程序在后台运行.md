# 后台进程运行

# nohup

```shell
which nohup
.bash_profile中并source加载

如果没有就安装吧
yum provides */nohup

nohup npm start &

```

> 原程序的的标准输出被自动改向到当前目录下的nohup.out文件，起到了log的作用。

停止程序
```shell
ps -ef | grep npm
ps -ef | grep node
kill -9 10532
```

# pm2

>* forever已经out了，严重推荐pm2方式运行nodejs,这是最好的，没有之一。
>* 内建负载均衡（使用 Node cluster 集群模块）
>* 后台运行
>* 0 秒停机重载，我理解大概意思是维护升级的时候不需要停机.
>* 具有 Ubuntu 和 CentOS 的启动脚本
>* 停止不稳定的进程（避免无限循环）
>* 控制台检测
>* 提供 HTTP API
>* 远程控制和实时的接口 API ( Nodejs 模块，允许和 PM2 进程管理器交互 )
>* pm2官网http://pm2.keymetrics.io/

## 安装
```shell
cnpm install pm2 -g 
```
## 启动项目

```shell
pm2启动：
pm2 start "/usr/local/src/node/bin/npm" --name "law" -- start .

pm2 list
pm2 stop    
pm2 restart 
pm2 delete  
```





