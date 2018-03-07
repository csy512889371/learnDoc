# Spring ThreadPoolTaskExecutor 结合CountDownLatch 实现线程阻塞 

* 业务场景，大家可能都会遇到，在遍历一个list的时候，需要对list中的每个对象，做一些复杂又耗时的操作，比如取出对象的uid，远程调用一次userservice的getUserByUid方法，这属于IO操作了，可怕的是遍历到每个对象时，都得执行一次这种RPC的IO操作（甚至不止一次，因为可能还有别的接口需要去调）还有复杂的业务逻辑需要cpu去计算。
* java的thread类有join发法可让主线程阻塞直到子线程执行完毕，那么如何ThreadPoolTaskExecutor是否有功能呢。

* 例子地址 https://github.com/csy512889371/learndemo/tree/master/ctoedu-ThreadPool-TaskExecutor

## spring.xml


```xml
<bean id="taskExecutor" class="org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor">
        <!-- 核心线程数 -->
        <property name="corePoolSize" value="5"/>
        <!-- 最大线程数 -->
        <property name="maxPoolSize" value="10"/>
        <!-- 队列最大长度 >=mainExecutor.maxSize -->
        <property name="queueCapacity" value="25"/>
        <!-- 线程池维护线程所允许的空闲时间 -->
        <property name="keepAliveSeconds" value="3000"/>
        <!-- 线程池对拒绝任务(无线程可用)的处理策略 ThreadPoolExecutor.CallerRunsPolicy策略 ,调用者的线程会执行该任务,如果执行器已关闭,则丢弃.  -->
        <property name="rejectedExecutionHandler">
            <bean class="java.util.concurrent.ThreadPoolExecutor$CallerRunsPolicy"/>
        </property>
    </bean>

```

## ThreadRunnable

```java
@Component
public class ThreadRunnable {

    @Autowired
    private TaskExecutor taskExecutor;

    public void executeThread(String result, CountDownLatch latch) {
        this.taskExecutor.execute(new TaskThread(result, latch));
    }

    private class TaskThread implements Runnable {
        private CountDownLatch latch;
        java.text.SimpleDateFormat dateTimeFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        private String result;

        private TaskThread(String result, CountDownLatch latch) {
            super();
            this.result = result;
            this.latch = latch;
        }

        public void run() {
            try {
                for (int i = 0; i < 10000; i++) {
                    // dateTimeFormat.format(new Date());
                }
                System.out.println("现在的时间为：" + dateTimeFormat.format(new Date()) + "    " + result);

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (this.latch != null) {
                    latch.countDown();
                }
            }
        }
    }
}
```


## ThreadRunnableTest

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring.xml")
public class ThreadRunnableTest extends AbstractJUnit4SpringContextTests {

    @Autowired
    ThreadRunnable threadRunnable;

    @Test
    public void test() throws InterruptedException {
        CountDownLatch latch = new CountDownLatch(10);
        for (int i = 0; i < 11; i++) {
            threadRunnable.executeThread("架构师成长之路", latch);
        }
        latch.await();
        System.out.println("执行完毕了吗！");
    }
}
```