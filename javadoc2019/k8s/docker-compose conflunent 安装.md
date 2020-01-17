**1、首先安装docker-compose**



**2、编写mysql-confluence-compose.yaml 文件**



```
version: '3.1'
services:
  confluence:
    container_name: wiki_confluence
    restart: always
    image: cptactionhank/atlassian-confluence:latest
    ports:
      - "9751:8090"

```



带数据库的

```
mysql:
  container_name: mysql
  restart: always
  image: mysql:5.7
  ports:
    - "3307:3307"
  environment:
    MYSQL_ROOT_PASSWORD: 3a99bce0c4991b91
  volumes:
    - /opt/docker/mysql/conf:/etc/mysql/mysql.conf.d
    - /opt/docker/mysql/data:/usr/local/mysql/data
    - /opt/docker/mysql/logs/:/usr/local/mysql/logs

confluence:
  container_name: wiki_confluence
  restart: always
  image: cptactionhank/atlassian-confluence:latest
  ports:
    - "8090:8090"
  links:
    - mysql:mysql
```





安装mysql和confluence服务。confluence服务依赖于mysql。



**3、运行容器**

```
docker-compose -f mysql-confluence-compose.yaml up
```

至此confluence和mysql已经启动成功。剩下的就是激活confluence

**5、访问confluence**



**激活**

**（1）docker cp将confluence容器中对应版本的jar包拷贝到主机**

  docker cp wiki_confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar /opt/docker/mysql



 （2）将atlassian-extras-decoder-v2-3.4.1.jar文件拷贝到windows下。同时将文件名改为 atlassian-extras-2.4.jar。破解工具只识别这个文件名

 （3）下载破解文件 [http://wiki.wuyijun.cn/download/attachments/2327034/51CTO%E4%B8%8B%E8%BD%BD-Confluence.zip](http://wiki.wuyijun.cn/download/attachments/2327034/51CTO下载-Confluence.zip)

 （4） 解压缩此文件夹，dos命令行进入此文件夹，目录需根据你的实际情况修改 C:\Users\lrs\Desktop\wiki\51CTO下载-Confluence\confluence5.1-crack\confluence5.1-crack\iNViSiBLE

 （5） 执行 java -jar confluence_keygen.jar 运行破解文件

 （6）填入 name ，server id 处输入confluence 服务器ID，点击 “gen” 生成key

​      ![img](https://images2018.cnblogs.com/blog/733995/201807/733995-20180721170154519-1645725740.png)



（7）点击 patch，选择刚才改名为 “atlassian-extras-2.4.jar” 的jar包，显示 “jar success fully patched” 则破解成功

　　　　　　注意：path前先删除atlassian-extras-2.4.bak文件否则path失败

​         ![img](https://images2018.cnblogs.com/blog/733995/201807/733995-20180721170403281-28916037.png)

（8）将 “atlassian-extras-2.4.jar” 文件名改回原来的 “atlassian-extras-decoder-v2-3.4.1.jar”

（9）复制key中的内容备用

（10）将 “atlassian-extras-decoder-v2-3.4.1.jar” 文件上传回服务器

（11）将破解后的文件复制回 confluence 容器

​      docker cp atlassian-extras-decoder-v2-3.4.1.jar wiki_confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar 

（12）启动 confluence 容器

​      docker-compose -f mysql-confluence-compose.yml up -d

（13）再次访问页面

（14）输入之前复制的key后点击下一步

**7、最后配置自己的数据库**

![img](https://images2018.cnblogs.com/blog/733995/201807/733995-20180721173122852-1002424047.png)

 