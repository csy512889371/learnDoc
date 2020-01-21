# 安装 JDK1.8
以root身份在 master 节点上执行：

```
yum install java-1.8.0-openjdk* -y
```



#在 master 节点上安装 maven

在 maven 官网 获取最新版 maven 的 binary 文件下载链接，例如 apache-maven-3.6.2-bin.tar.gz 的下载地址为 http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz

以 root 身份在 master 节点上执行：

```
#切换到 /root 用户目录
cd /root
# 下载 tar.gz

wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz

```



# 解压 tar.gz
```
tar -xvf apache-maven-3.6.3-bin.tar.gz
```

以root身份在 master 节点上执行 vim /root/.bash_profile 修改 .bash_profile 文件，向 PATH= 所在行的行尾增加 :/root/apache-maven-3.6.2/bin 如下所示：



```
mv apache-maven-3.6.3 /var/local/apache-maven-3.6.3
```

```
# User specific environment and startup programs

PATH=$PATH:$HOME/bin:/var/local/apache-maven-3.6.3/bin

export PATH
```

```
source .bash_profile
```

> TIP 
> 您可以把 apache-maven-3.6.2 放在您自己喜欢的位置

检查安装结果：退出 master 节点的 shell 终端，并重新以 root 用户登录 master 节点的 shell 终端，执行命令 mvn -version，输出结果如下所示：

```
Apache Maven 3.6.2 (40f52333136460af0dc0d7232c0dc0bcf0d9e117; 2019-08-27T23:06:16+08:00)
Maven home: /root/apache-maven-3.6.2
Java version: 1.8.0_222, vendor: Oracle Corporation, runtime: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-1.el7_7.x86_64/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-957.21.3.el7.x86_64", arch: "amd64", family: "unix"
```

```
#在 master 节点上安装 git
以root身份在 master 节点执行：
# 安装 git
yum install -y git
# 查看已安装版本
git version
```


