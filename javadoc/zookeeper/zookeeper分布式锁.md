# Zookeeper客户端Curator使用详解
Curator是Netflix公司开源的一套zookeeper客户端框架，解决了很多Zookeeper客户端非常底层的细节开发工作，包括连接重连、反复注册Watcher和NodeExistsException异常等等。

# 多共享锁对象 —Multi Shared Lock

* Multi Shared Lock是一个锁的容器。 当调用acquire()， 所有的锁都会被acquire()，如果请求失败，所有的锁都会被release。 
* 同样调用release时所有的锁都被release(失败被忽略)。 基本上，它就是组锁的代表，在它上面的请求释放操作都会传递给它包含的所有的锁。


# pom 依赖


```xml

	<curator.version>2.11.1</curator.version>
	
	<dependency>
		<groupId>org.apache.curator</groupId>
		<artifactId>curator-framework</artifactId>
		<version>${curator.version}</version>
	</dependency>
	<dependency>
		<groupId>org.apache.curator</groupId>
		<artifactId>curator-recipes</artifactId>
		<version>${curator.version}</version>
	</dependency>

```

# java代码

```java

import org.apache.curator.framework.CuratorFramework;
import org.apache.curator.framework.recipes.locks.InterProcessMutex;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;


@Service
public class DistributeLockService {

    // zookeeper配置中心 初始化默认值
    private static final String INIT_VAL = "0";

    @Autowired
    private CuratorFramework zkClient;

    /**
     * 生成序列，需要提供LockZNode
     *
     * @param lockZnode 格式类似 /jgbs/profile，具体参考zookeeper
     * @return
     */
    public Integer getSequence(String lockZnode) {
        InterProcessMutex lock = new InterProcessMutex(zkClient, lockZnode);
        try {
            boolean retry = true;
            byte[] newData = null;
            do {
                if (lock.acquire(1000, TimeUnit.SECONDS)) {
                    byte[] oldData = zkClient.getData().forPath(lockZnode);
                    String s = new String(oldData);
                    if ("".equals(s)) {
                        s = INIT_VAL;
                    }
                    int d = Integer.parseInt(s);
                    d = d + 1;
                    s = String.valueOf(d);
                    newData = s.getBytes();
                    zkClient.setData().forPath(lockZnode, newData);
                    retry = false;
                }
            } while (retry);
            return Integer.valueOf(new String(newData));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (lock.isAcquiredInThisProcess()) {
                    lock.release();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 拼接zookeeper的路径
     * @param znodes
     * @return
     */
    public String buildLockZNode(Object... znodes) {
        if (null == znodes || 0 == znodes.length) {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        for (Object node : znodes) {
            builder.append("/")
                    .append(String.valueOf(node));
        }
        return builder.toString();
    }
}

```


