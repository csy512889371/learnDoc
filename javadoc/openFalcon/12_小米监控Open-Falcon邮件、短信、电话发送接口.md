# 小米监控Open-Falcon 邮件、短信、电话发送接口

## 一、	介绍
监控系统产生报警事件之后需要发送报警邮件或者报警短信，各个公司可能有自己的邮件服务器，有自己的邮件发送方法；有自己的短信通道，有自己的短信发送方法。falcon为了适配各个公司，在接入方案上做了一个规范，需要各公司提供http的短信和邮件发送接口。

## 二、	邮件配置
邮件发送http接口：

```shell
method: post
params:
  - content: 邮件内容
  - subject: 邮件标题
  - tos: 使用逗号分隔的多个邮件地址


```

* 代码地址：https://github.com/open-falcon/mail-provider
* 下载然后进行编译：

```shell
git clone https://github.com/open-falcon/mail-provider
cd mail-provider
```

* 先配置安装go环境：
```shell
yum install golang
```
* 配置gopath指向mail-provider的目录
```shell
export GOPATH= /data/program/software/mail-provider/
```

* 执行命令： ./control build (编译)
* 执行命令： ./control pack (打包)

```shell
启动 ./control start
停止 ./control stop
重启 ./control restart
状态 ./control status
```


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/8.png)


测试：

```shell
curl http://127.0.0.1:4000/sender/mail -d "tos=邮箱地址&subject=xx&content=yy"
```

## 三、	短信配置

短信发送http接口：

```shell
method: post
params:
  - content: 短信内容
  - tos: 使用逗号分隔的多个手机号

```

目前open-falcon支持LinkedSee灵犀云通道短信/语音通知API快速接入，只需一个API即可快速对接Open Falcon，快速让您拥有告警通知功能，90%的告警压缩比。云通道短信/语音通知接口接入步骤如下：

### 1、	注册

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/9.png)

### 2、	新建应用

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/11.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/12.png)

点击如下，保存token，并且开启短信通知：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/13.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/15.png)

### 3、	测试
https://www.linkedsee.com/alarm/falcon_sms/保存的token

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/16.png)


## 四、	电话配置

类似第三步中开启语音通知，将地址改为https://www.linkedsee.com/alarm/falcon_voice/保存的token既可以发送语音通知。

## 五、	更改Alarm配置

更改前：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/17.png)

更改后：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/18.png)
