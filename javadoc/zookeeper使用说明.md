# zookeeper使用说明

# 一、概要说明

>* 配置的集中管理
>* 集群管理
>* 分布式锁

znode 可以被监控，包括这个目录节点中存储的数据的修改，子节点目录的变化等，一旦变化可以**通知设置监控的客户端**，
这个功能是zookeeper对于应用最重要的特性，通过这个特性可以实现的功能包括配置的**集中管理**，**集群管理**，**分布式锁**等等


# 二、Zookeeper介绍

## 介绍

>* 每个子目录项如 NameService 都被称作为 znode，这个 znode 是被它所在的路径唯一标识，如 Server1 这个 znode 的标识为 /NameService/Server1
>* znode 可以有子节点目录，并且每个 znode 可以存储数据，注意 EPHEMERAL 类型的目录节点不能有子节点目录
>* znode 是有版本的，每个 znode 中存储的数据可以有多个版本，也就是一个访问路径中可以存储多份数据
>* znode 可以是临时节点，一旦创建这个 znode 的客户端与服务器失去联系，这个 znode 也将自动删除，Zookeeper 的客户端和服务器通信采用长连接方式，每个客户端和服务器通过心跳来保持连接，这个连接状态称为 session，如果 znode 是临时节点，这个 session 失效，znode 也就删除了
>* znode 的目录名可以自动编号，如 App1 已经存在，再创建的话，将会自动命名为 App2
>* znode 可以被监控，包括这个目录节点中存储的数据的修改，子节点目录的变化等，一旦变化可以通知设置监控的客户端，这个是 Zookeeper 的核心特性，Zookeeper 的很多功能都是基于这个特性实现的，后面在典型的应用场景中会有实例介绍

## zookeeper 数据结构

![image](https://github.com/csy512889371/learnDoc/blob/master/image/zookeeper/zookeeper1.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/zookeeper/zookeeper2.png)

## zooKeeper安装
>* http://mirrors.hust.edu.cn/apache/zookeeper/
>* 解压 
>* 修改F:\tools\zookeeper\conf\zoo.cfg
```java
dataDir=F:\\tools\\zk\\tmp\\zookeeper

dataLogDir=F:\\tools\\zk\\logs\\zookeeper

```


```java
# The number of milliseconds of each tick

tickTime=2000

# The number of ticks that the initial

# synchronization phase can take

initLimit=10

# The number of ticks that can pass between

# sending a request and getting an acknowledgement

syncLimit=5

# the directory where the snapshot is stored.

# do not use /tmp for storage, /tmp here is just

# example sakes.

dataDir=F:\\tools\\zk\\tmp\\zookeeper

dataLogDir=F:\\tools\\zk\\logs\\zookeeper

# the port at which the clients will connect

clientPort=2181

# the maximum number of client connections.

# increase this if you need to handle more clients

#maxClientCnxns=60

#

# Be sure to read the maintenance section of the

# administrator guide before turning on autopurge.

#

# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance

#

# The number of snapshots to retain in dataDir

#autopurge.snapRetainCount=3

# Purge task interval in hours

# Set to "0" to disable auto purge feature

#autopurge.purgeInterval=1
```

>* 运行
```java
cmd 
F:\tools\zookeeper\bin\ zkServer.cmd
```

>* 检查运行情况 netstat -ano|findstr "2181"

>* 安装可视化监控工具

```java
ZooInspector
下载地址 https://issues.apache.org/jira/secure/attachment/12436620/ZooInspector.zip ;
运行  F:\tools\zk\ZooInspector\build\zookeeper-dev-ZooInspector.jar
```

# 三、zooKeeper基本API

```java

zk = new ZooKeeper(address, sessionTimeout,null);
zk.exists("/tmp_root_path", true) //exists()方法仅仅监控对应节点的一次数据变化，无论是数据修改还是删除！
zk.getData(event.getPath(), true, null);
```

> 创建节点

```java
// 创建一个总的目录ktv，并不控制权限，这里需要用持久化节点，不然下面的节点创建容易出错

zk.create(ROOT, "root-ktv".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);

 

// 然后杭州开一个KTV , PERSISTENT_SEQUENTIAL 类型会自动加上 0000000000 自增的后缀

zk.create(ROOT + "/杭州KTV", "杭州KTV".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT_SEQUENTIAL);

 

// 也可以在北京开一个, EPHEMERAL session 过期了就会自动删除

zk.create(ROOT + "/北京KTV", "北京KTV".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL);

 

// 同理，我可以在北京开多个，EPHEMERAL_SEQUENTIAL session 过期自动删除，也会加数字的后缀

zk.create(ROOT + "/北京KTV-分店", "北京KTV-分店".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL_SEQUENTIAL);
```

# 四、配置服务

> ConnectionWatcher 建立链接

```java
import org.apache.zookeeper.ZooKeeper;

 

public class ConnectionWatcher {

       protected static ZooKeeper zk = null;

       public void connect(String url) {

              try {

                     zk = new ZooKeeper(url, 30000, null);

              } catch (Exception e) {

                     e.printStackTrace();

              }

       }

}
```
ChangedActiveKeyValueStore对节点操作

```java
import java.nio.charset.Charset;

import java.util.concurrent.TimeUnit;

 

import org.apache.zookeeper.CreateMode;

import org.apache.zookeeper.KeeperException;

import org.apache.zookeeper.Watcher;

import org.apache.zookeeper.ZooDefs.Ids;

import org.apache.zookeeper.data.Stat;

 

public class ChangedActiveKeyValueStore extends ConnectionWatcher{

    private static final Charset CHARSET=Charset.forName("UTF-8");

    private static final int MAX_RETRIES = 5;

    private static final long RETRY_PERIOD_SECONDS = 5;

   

    public void write(String path,String value) throws InterruptedException, KeeperException{

        int retries=0;

        while(true){

            try {

                Stat stat = zk.exists(path, false);//判断节点是否存在

                if(stat==null){//不存在则创建

                    zk.create(path, value.getBytes(CHARSET),Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);

                }else{//存在则设置值

                    zk.setData(path, value.getBytes(CHARSET),stat.getVersion());

                }

                break;

            } catch (KeeperException.SessionExpiredException e) {

                throw e;

            } catch (KeeperException e) { //网络错误重试

                if(retries++==MAX_RETRIES){

                    throw e;

                }

                //sleep then retry

                TimeUnit.SECONDS.sleep(RETRY_PERIOD_SECONDS);

            }

        }

    }

    public String read(String path,Watcher watch) throws KeeperException, InterruptedException{

        byte[] data = zk.getData(path, watch, null);

        return new String(data,CHARSET);

    }

}
```
ResilientConfigUpdater更新配置

```java
import java.io.IOException;

import java.util.Random;

import java.util.concurrent.TimeUnit;

 

import org.apache.zookeeper.KeeperException;

 

public class ResilientConfigUpdater extends ConnectionWatcher {

       public static final String PATH = "/config";

       private ChangedActiveKeyValueStore store;

       private Random random = new Random();

 

       public ResilientConfigUpdater(String hosts) throws IOException, InterruptedException {

              store = new ChangedActiveKeyValueStore();

              store.connect(hosts);

       }

 

       public void run() throws InterruptedException, KeeperException {

              while (true) {

                     String value = random.nextInt(100) + "";

                     store.write(PATH, value);

                     System.out.printf("Set %s to %s\n", PATH, value);

                     TimeUnit.SECONDS.sleep(random.nextInt(10));

              }

       }

 

       public static void main(String[] args) throws Exception {

              while (true) {

                     try {

                            ResilientConfigUpdater configUpdater = new ResilientConfigUpdater("localhost:2181");

                            configUpdater.run();

                     } catch (KeeperException.SessionExpiredException e) {

                            // start a new session

                     } catch (KeeperException e) {

                            // already retried ,so exit

                            e.printStackTrace();

                            break;

                     }

              }

       }

}
```

> ConfigWatcher 监听配置修改

```java
import java.io.IOException;

 

import org.apache.zookeeper.KeeperException;

import org.apache.zookeeper.WatchedEvent;

import org.apache.zookeeper.Watcher;

import org.apache.zookeeper.Watcher.Event.EventType;

 

public class ConfigWatcher implements Watcher{

    private ActiveKeyValueStore store;

 

    // 监控所有被触发的事件 当zooKeeper中节点变化（修改数据、删除节点）

@Override

    public void process(WatchedEvent event) {

        if(event.getType()==EventType.NodeDataChanged){

            try{

                dispalyConfig();

            }catch(InterruptedException e){

                System.err.println("Interrupted. exiting. ");

                Thread.currentThread().interrupt();

            }catch(KeeperException e){

                System.out.printf("KeeperException. Exiting.\n", e);

            }

        }

    }

    public ConfigWatcher(String hosts) throws IOException, InterruptedException {

        store=new ActiveKeyValueStore();

        store.connect(hosts);

    }

    public void dispalyConfig() throws KeeperException, InterruptedException{

        String value=store.read(ConfigUpdater.PATH, this);//读取节点数据 且 设置继续监听

        System.out.printf("Read %s as %s\n",ConfigUpdater.PATH,value);

    }

    public static void main(String[] args) throws IOException, InterruptedException, KeeperException {

        ConfigWatcher configWatcher = new ConfigWatcher("localhost:2181");

        configWatcher.dispalyConfig();

        Thread.sleep(Long.MAX_VALUE);

    }

}

```


# 五、ZooKeeper实现共享锁

## 分布式锁概述

> 分布式锁在一组进程之间提供了一种互斥机制。在任何时刻，在任何时刻只有一个进程可以持有锁。分布式锁可以在大型分布式系统中实现领导者选举，在任何时间点，持有锁的那个进程就是系统的领导者。

### 注意

> 不要将ZooKeeper自己的领导者选举和使用了ZooKeeper基本操作实现的一般领导者选混为一谈。ZooKeeper自己的领导者选举机制是对外不公开的，我们这里所描述的一般领导者选举服务则不同，他是对那些需要与主进程保持一致的分布式系统所设计的。

-----

### 思路
>为了使用ZooKeeper来实现分布式锁服务，我们使用顺序znode来为那些竞争锁的进程强制排序。


思路很简单：

>* 首先指定一个作为锁的znode，通常用它来描述被锁定的实体，称为/leader；
>* 然后希望获得锁的客户端创建一些短暂顺序znode，作为锁znode的子节点。
>* 在任何时间点，顺序号最小的客户端将持有锁。


例如，有两个客户端差不多同时创建znode，分别为/leader/lock-1和/leader/lock-2，那么创建/leader/lock-1的客户端将会持有锁，因为它的znode顺序号最小。ZooKeeper服务是顺序的仲裁者，因为它负责分配顺序号。


>* 通过删除znode /leader/lock-l即可简单地将锁释放；
>* 另外，如果客户端进程死亡，对应的短暂znode也会被删除
>* 接下来，创建/leader/lock-2的客户端将持有锁，因为它顺序号紧跟前一个
>* 通过创建一个关于znode删除的观察，可以使客户端在获得锁时得到通知

### 申请获取锁的伪代码
>* 在锁znode下创建一个名为lock-的短暂顺序znode，并且记住它的实际路径名(create操作的返回值)
>* 查询锁znode的子节点并且设置一个观察
>* 如果步骤l中所创建的znode在步骤2中所返回的所有子节点中具有最小的顺序号，则获取到锁。退出
>* 等待步骤2中所设观察的通知并且转到步骤2

# 当前问题与方案

## 1.羊群效应

### 问题

>* 虽然这个算法是正确的，但还是存在一些问题。第一个问题是这种实现会受到“羊群效应”(herd effect)的影响。
>* 考虑有成百上千客户端的情况，所有的客户端都在尝试获得锁，每个客户端都会在锁znode上设置一个观察，用于捕捉子节点的变化。
>* 每次锁被释放或另外一个进程开始申请获取锁的时候，观察都会被触发并且每个客户端都会收到一个通知。 
>* “羊群效应“就是指大量客户端收到同一事件的通知，但实际上只有很少一部分需要处理这一事件。
>* 在这种情况下，只有一个客户端会成功地获取锁，但是维护过程及向所有客户端发送观察事件会产生峰值流量，这会对ZooKeeper服务器造成压力。

### 方案解决方案

>* 为了避免出现羊群效应，我们需要优化通知的条件。
>* 关键在于只有在前一个顺序号的子节点消失时才需要通知下一个客户端，而不是删除（或创建）任何子节点时都需要通知。
>* 在我们的例子中，如果客户端创建了znode /leader/lock-1、/leader/lock-2和／leader/lock-3，那么只有当/leader/lock-2消失时才需要通知／leader/lock-3对照的客户端；/leader/lock-1消失或有新的znode /leader/lock-4加入时，不需要通知该客户端。


## 2.可恢复的异常

### 问题

>* 这个申请锁的算法目前还存在另一个问题，就是不能处理因连接丢失而导致的create操作失败。
>* 如前所述，在这种情况下，我们不知道操作是成功还是失败。
>* 由于创建一个顺序znode是非幂等操作，所以我们不能简单地重试，因为如果第一次创建已经成功，重试会使我们多出一个永远删不掉的孤儿zriode(至少到客户端会话结束前）。
>* 不幸的结果是将会出现死锁。

### 解决方案

>* 问题在于，在重新连接之后客户端不能够判断它是否已经创建过子节点。
>* 解决方案是在znode的名称中嵌入一个ID，如果客户端出现连接丢失的情况，重新连接之后它便可以对锁节点的所有于节点进行检查，看看是否有子节点的名称中包含其ID。
>* 如果有一个子节点的名称包含其ID，它便知道创建操作已经成功，不需要再创建子节点。
>* 如果没有子节点的名称中包含其ID，则客户端可以安全地创建一个新的顺序子节点。

>* 客户端会话的ID是一个长整数，并且在ZooKeeper服务中是唯一的，因此非常适合在连接丢失后用于识别客户端。
>* 可以通过调用Java ZooKeeper类的getSessionld()方法来获得会话的ID。
>* 在创建短暂顺序znode时应当采用lock-<sessionld>-这样的命名方式，ZooKeeper在其尾部添加顺序号之后，znode的名称会形如lock-<sessionld>-<sequenceNumber>。
>* 由于顺序号对于父节点来说是唯一的，但对于子节点名并不唯一，因此采用这样的命名方式可以诖子节点在保持创建顺序的同时能够确定自己的创建者。


## 3.不可恢复的异常

>* 如果一个客户端的ZooKeeper会话过期，那么它所创建的短暂znode将会被删除，已持有的锁会被释放，或是放弃了申请锁的位置。
>* 使用锁的应用程序应当意识到它已经不再持有锁，应当清理它的状态，然后通过创建并尝试申请一个新的锁对象来重新启动。
>* 注意，这个过程是由应用程序控制的，而不是锁，因为锁是不能预知应用程序需要如何清理自己的状态。


## 4.ZooKeeper实现共享锁

>* 实现正确地实现一个分布式锁是一件棘手的事，因为很难对所有类型的故障都进行正确的解释处理。
>* ZooKeeper带有一个JavaWriteLock，客户端可以很方便地使用它。
>* 更多分布式数据结构和协议例如“屏障”(bafrier)、队列和两阶段提交协议。
>* 有趣的是它们都是同步协议，即使我们使用异步ZooKeeper基本操作（如通知）来实现它们。
>* 使用ZooKeeper可以实现很多不同的分布式数据结构和协议，ZooKeeper网站(http://hadoop.apache.org/zookeeper/)提供了一些用于实现分布式数据结构和协议的伪代码。
>* ZooKeeper本身也带有一些棕准方法的实现，放在安装位置下的recipes目录中。

### 利用节点名称的唯一性来实现共享锁


![image](https://github.com/csy512889371/learnDoc/blob/master/image/zookeeper/zookeeper3.png)


> 利用顺序节点实现共享锁

![image](https://github.com/csy512889371/learnDoc/blob/master/image/zookeeper/zookeeper4.png)


> DistributedLock

```java
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;

import org.apache.zookeeper.CreateMode;
import org.apache.zookeeper.KeeperException;
import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooDefs;
import org.apache.zookeeper.ZooKeeper;
import org.apache.zookeeper.data.Stat;

public class DistributedLock implements Lock, Watcher {
	private ZooKeeper zk;
	private String root = "/locks";// 根
	private String lockName;// 竞争资源的标志
	private String waitNode;// 等待前一个锁
	private String myZnode;// 当前锁
	private CountDownLatch latch;// 计数器
	private int sessionTimeout = 30000;
	private List<Exception> exception = new ArrayList<Exception>();

	/**
	 * 创建分布式锁,使用前请确认config配置的zookeeper服务可用
	 * 
	 * @param config
	 *            127.0.0.1:2181
	 * @param lockName
	 *            竞争资源标志,lockName中不能包含单词lock
	 */
	public DistributedLock(String config, String lockName) {
		this.lockName = lockName;
		// 创建一个与服务器的连接
		try {
			zk = new ZooKeeper(config, sessionTimeout, this);
			Stat stat = zk.exists(root, false);
			if (stat == null) {
				// 创建根节点
				zk.create(root, new byte[0], ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
			}
		} catch (IOException e) {
			exception.add(e);
		} catch (KeeperException e) {
			exception.add(e);
		} catch (InterruptedException e) {
			exception.add(e);
		}
	}

	/**
	 * zookeeper节点的监视器
	 */
	public void process(WatchedEvent event) {
		if (this.latch != null) {
			this.latch.countDown();
			System.out.println("lock count down");
		}
	}

	public void lock() {
		if (exception.size() > 0) {
			throw new LockException(exception.get(0));
		}
		try {
			if (this.tryLock()) {
				System.out.println("Thread " + Thread.currentThread().getId() + " " + myZnode + " get lock true");
				return;
			} else {
				waitForLock(waitNode, sessionTimeout);// 等待锁
			}
		} catch (KeeperException e) {
			throw new LockException(e);
		} catch (InterruptedException e) {
			throw new LockException(e);
		}
	}

	public boolean tryLock() {
		try {
			String splitStr = "_lock_";
			if (lockName.contains(splitStr)) {
				throw new LockException("lockName can not contains \\u000B");
			}
			// 创建临时子节点
			myZnode = zk.create(root + "/" + lockName + splitStr, new byte[0], ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL_SEQUENTIAL);
			System.out.println(myZnode + " is created ");
			// 取出所有子节点
			List<String> subNodes = zk.getChildren(root, false);
			// 取出所有lockName的锁
			List lockObjNodes = new ArrayList();
			for (String node : subNodes) {
				String _node = node.split(splitStr)[0];
				if (_node.equals(lockName)) {
					lockObjNodes.add(node);
				}
			}
			Collections.sort(lockObjNodes);
			System.out.println(myZnode + "==" + lockObjNodes.get(0));
			if (myZnode.equals(root + "/" + lockObjNodes.get(0))) {
				// 如果是最小的节点,则表示取得锁
				return true;
			}
			// 如果不是最小的节点，找到比自己小1的节点
			String subMyZnode = myZnode.substring(myZnode.lastIndexOf("/") + 1);
			waitNode = (String) lockObjNodes.get(Collections.binarySearch(lockObjNodes, subMyZnode) - 1);
		} catch (KeeperException e) {
			throw new LockException(e);
		} catch (InterruptedException e) {
			throw new LockException(e);
		}
		return false;
	}

	public boolean tryLock(long time, TimeUnit unit) {
		try {
			if (this.tryLock()) {
				return true;
			}
			return waitForLock(waitNode, time);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	private boolean waitForLock(String lower, long waitTime) throws InterruptedException, KeeperException {
		Stat stat = zk.exists(root + "/" + lower, true);
		// 判断比自己小一个数的节点是否存在,如果不存在则无需等待锁,同时注册监听
		if (stat != null) {
			System.out.println("Thread " + Thread.currentThread().getId() + " waiting for " + root + "/" + lower);
			this.latch = new CountDownLatch(1);
			this.latch.await(waitTime, TimeUnit.MILLISECONDS);
			this.latch = null;
		}
		return true;
	}

	public void unlock() {
		try {
			System.out.println("unlock " + myZnode);
			zk.delete(myZnode, -1);
			myZnode = null;
			zk.close();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (KeeperException e) {
			e.printStackTrace();
		}
	}

	public void lockInterruptibly() throws InterruptedException {
		this.lock();
	}

	public Condition newCondition() {
		return null;
	}

	public class LockException extends RuntimeException {
		private static final long serialVersionUID = 1L;

		public LockException(String e) {
			super(e);
		}

		public LockException(Exception e) {
			super(e);
		}
	}

}

```

> ConcurrentTaskImpl

```java
import java.util.concurrent.TimeUnit;

public class ConcurrentTaskImpl implements ConcurrentTask {

	@Override
	public void running(int sleeptime) {
		DistributedLock lock = null;
		try {
			lock = new DistributedLock("127.0.0.1:2181", "test2");
			lock.lock();
			
			//模拟复杂任务执行时间
			TimeUnit.SECONDS.sleep(sleeptime);
			System.out.println("Thread " + Thread.currentThread().getId() + " running");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (lock != null) {
				lock.unlock();
			}
		}
	}

}


```



