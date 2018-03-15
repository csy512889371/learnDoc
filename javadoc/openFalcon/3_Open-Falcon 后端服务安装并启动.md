# 后端服务安装并启动

## 一、	创建工作目录

```shell
export FALCON_HOME=/home/work
export WORKSPACE=$FALCON_HOME/open-falcon
mkdir -p $WORKSPACE
```

## 二、	解压二进制包
```shell
cd /data/program/software
tar -xzvf open-falcon-v0.2.1.tar.gz -C $WORKSPACE
```

## 三、	配置数据库账号和密码
```shell
cd $WORKSPACE
grep -Ilr 3306  ./ | xargs -n1 -- sed -i 's/root:/root:bigdata/g'
```
注意root:后面默认密码为空，所以只是看到了root:

## 四、	启动

查看目录下包括Open-Falcon的所有组件，我们先默认全部启动，之后我们一个一个讲解如何分布式部署以及启动

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/1.png)

```shell
cd $WORKSPACE
./open-falcon start
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/2.png)

# 检查所有模块的启动状况

```shell
./open-falcon check
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/3.png)

## 五、	更多命令行工具

# ./open-falcon [start|stop|restart|check|monitor|reload] module

```shell

./open-falcon start agent

./open-falcon check
  falcon-graph         UP           53007
  falcon-hbs         UP           53014
  falcon-judge         UP           53020
  falcon-transfer         UP           53026
  falcon-nodata         UP           53032
  falcon-aggregator         UP           53038
  falcon-agent         UP           53044
  falcon-gateway         UP           53050
  falcon-api         UP           53056
  falcon-alarm         UP           53063

For debugging , You can check $WorkDir/$moduleName/log/logs/xxx.log
```

