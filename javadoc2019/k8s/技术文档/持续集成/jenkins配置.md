#### 一、上线基本流程：

> 1.代码获取（直接了拉取最新代码，使用tag标签获取某个版本代码）
>  2.编译      （可选）
>  3.配置文件放进去
>  4.打包
>  5.scp到目标服务器
>  6.将目标服务器移除集群
>  7.解压并放置到Webroot
>  8.Scp 差异文件
>  9.重启      （可选）
>  10.测试
>  11.加入集群



## 二、Jenkins



####  Jenkins插件安装

因为我们要和gitlab结合，所以这里需要安装gitlab的插件
 在系统管理中，进入插件管理，搜索gitlab



![img](https:////upload-images.jianshu.io/upload_images/6006801-559691fd70bf7c76.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



按实际情况，选择需要的插件，点击下载待重启后安装既可



![img](https:////upload-images.jianshu.io/upload_images/6006801-afa247db20e6f41e.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)




 等待安装完成，并重启Jenkins

## 三、实现持续集成

点击创建一个新任务，输入任务名字，选择自由风格，点击确定既可



![img](https:////upload-images.jianshu.io/upload_images/6006801-8e01411a0385fd65.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



在源码管理添加源码路径，点击Add，添加认证，这里是git，如果是svn，需要安装svn相关插件



```
ssh://git@39.100.254.140:12222/loit-Infrastructure-example/loit-mybatis-example.git
```


![img](https:////upload-images.jianshu.io/upload_images/6006801-a32773fb2025d98d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



 选择SSH认证方式

![img](https:////upload-images.jianshu.io/upload_images/6006801-eb0d994ad067131c.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



在Gitlab上创建deploy keys

![img](https:////upload-images.jianshu.io/upload_images/6006801-e25f09bc826eec43.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



* gitlab 创建用户

```
deploy
deploy@loit.com
```



* 进入jenkins虚拟机

```
docker exec -it c0fe2fc20c88 /bin/sh

ssh-keygen -t rsa -C "deploy@loit.com"


```

* 获取公钥

```
cat /var/jenkins_home/.ssh/id_rsa.pub
```

* 获取私钥

```
cd /var/jenkins_home/.ssh
```



![img](https:////upload-images.jianshu.io/upload_images/6006801-37cce64f2b99af20.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



点击Create既可,填写私钥文件，点击Add既可



![img](https:////upload-images.jianshu.io/upload_images/6006801-983af17c6d4f4343.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



点击保存既可，点击立即构建

![image-20200121153123728](F:\9Git140\loit-initproject-doc\4、技术文档\jenkins配置.assets\image-20200121153123728.png)

构建成功

![image-20200121153144130](F:\9Git140\loit-initproject-doc\4、技术文档\jenkins配置.assets\image-20200121153144130.png)

安装maven插件

![image-20200121153818515](F:\9Git140\loit-initproject-doc\4、技术文档\jenkins配置.assets\image-20200121153818515.png)

# maven 构建



```

```





# 备注

代码路径

```
ssh://git@39.100.254.140:12222/loit-Infrastructure-example/loit-mybatis-example.git
```

