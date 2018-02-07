# Linux 常用操作及命令

## 什么是linux服务器load average
Load是用来度量服务器工作量的大小，即计算机cpu任务执行队列的长度，值越大，表明包括正在运行和待运行的进程数越多。

## 如何查看linux服务器负载
* 可以通过w，top，uptime，procinfo命令，也可以通过/proc/loadavg文件查看。

## 服务器负载高怎么办

* 服务器负载（load/load average）是根据进程队列的长度来显示的。
* 当服务器出现负载高的现象时（建议以15分钟平均值为参考），可能是由于CPU资源不足，I/O读写瓶颈，内存资源不足等原因造成，也可能是由于CPU正在进行密集型计算。
* 建议使用vmstat -x，iostat，top命令判断负载过高的原因，然后找到具体占用大量资源的进程进行优化处理。

## 如何查看服务器内存使用率
可以通过free，top（执行后可通过shitf+m对内存排序），vmstat，procinfo命令，也可以通过/proc/meminfo文件查看。


## 如何查看单个进程占用的内存大小
可以使用top -p PID，pmap -x PID，ps aux|grep PID命令，也可以通过/proc/$process_id（进程的PID）/status文件查看，例如/proc/7159/status文件。

## 如何查看正在使用的服务和端口？
可以使用netstat -tunlp，netstat -antup，lsof -i:PORT命令查看。

## 如何杀死进程
* 可以使用kill -9 PID（进程号），killall 程序名（比如killall cron）来杀死进程。
* 如果要杀死的是僵尸进程，则需要杀掉进程的父进程才有效果，命令为： kill -9 ppid（ppid为父进程ID号，可以通过ps -o ppid PID查找，例如ps -o ppid 32535）。


## 如何查找僵尸进程
可以使用top命令查看僵尸进程（zombie）的总数，使用ps -ef | grep defunct | grep -v grep查找具体僵尸进程的信息。