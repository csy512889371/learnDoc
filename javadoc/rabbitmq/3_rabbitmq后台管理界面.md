# rabbitmq后台管理界面

* localhost:15671

## 1.添加用户

### 1.1. 添加用户界面

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/12.png)

### 1.2 添加管理员用户

```xml
我们添加账号 user_mmr 密码 admin tags 选择 admin
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/13.png)

我们看到刚添加完成的用户 在 vhost 一栏是没有权限的,所以呢我们这个时候的给他设置一个 vhost,那么这个 vhost 就相当于一个数据库(可以理解为 mysql 里面的一个 db),我们创建一个用户对其用户授权,他就可以访问了

## 2. vhost 管理

点击右侧的菜单进入 vhost 的管理界面

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/14.png)

点击 Add a new virtual host 添加一个 vhost,在 Rabbitmq 中我们添加 vhost 一般是以”/”开头,那么我们添加一个
/mmr 的 vhost

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/15.png)

当我们创建这个”vhost_mmr”的 vhost, 就可以对他进行用户授权,我们点击/vhost_mmr,进入其配置界面

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/16.png)


在 permission 权限这一栏 我们选择刚刚创建的用户 user_mmr,选择完成后 Set Permission

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/17.png)

我们退出 guest 用户,就可以使用刚刚创建的用户 user_mmr 进行登录了

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/18.png)


## 3. 控制台功能介绍 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/19.png)

Overview 概览

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/20.png)

Connections 连接

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/21.png)

我们没有连接 , 这个就好像 jdbc 连接 mysql 一样 如果有程序连接这 ,这时候这里面就能显示哪些机器连接着

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/22.png)

