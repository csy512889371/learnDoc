# 多模块，多Web应用，合并成一个War包


1：在总的web的pom里面，加入要合并的war内容，示例如下：

```
<plugin> 
  <groupId>org.apache.maven.plugins</groupId>  
  <artifactId>maven-war-plugin</artifactId>  
  <version>2.4</version>  
  <configuration> 
    <overlays> 
      <overlay> 
        <groupId>com.sishuok</groupId>  
        <artifactId>usermgr</artifactId> 
      </overlay>  
      <overlay> 
        <groupId>com.sishuok</groupId>  
        <artifactId>goodsweb</artifactId> 
      </overlay> 
    </overlays> 
  </configuration> 
</plugin>

```


2：在总的web的pom里面，加入要合并的war的依赖，示例如下：
```
<dependency>
	<groupId>com.sishuok</groupId>
	<artifactId>goodsweb</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<type>war</type>
</dependency>
<dependency>
	<groupId>com.sishuok</groupId>
	<artifactId>usermgr</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<type>war</type>
</dependency>
```
3：查看最后生成的war包，应该就是合并后的内容了。

注意：如果多个war有同路径且同名的文件，如果总的web里面有，那么总的这个会覆盖分支的；如果总的没有，那么看合并的顺序，留下第一个的文件。


4：在每个要测试的web的pom里面，加入jetty的插件配置，示例如下：
```
<plugin> 
  <groupId>org.mortbay.jetty</groupId>  
  <artifactId>jetty-maven-plugin</artifactId>  
  <version>8.1.14.v20131031</version>  
  <configuration> 
    <scanIntervalSeconds>10</scanIntervalSeconds>  
    <stopPort>9999</stopPort>  
    <webAppConfig> 
      <contextPath>/user</contextPath> 
    </webAppConfig>  
    <connectors> 
      <connector implementation="org.eclipse.jetty.server.nio.SelectChannelConnector"> 
        <port>9080</port>  
        <maxIdleTime>60000</maxIdleTime> 
      </connector> 
    </connectors> 
  </configuration> 
</plugin>
```