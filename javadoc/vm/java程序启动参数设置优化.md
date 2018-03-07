# java程序启动参数设置优化

* young generation 年轻代
* tenured generation老年代
* permanet generation持久代
* 一个E区，两个S区 简称（S1 S2）或简称（s from\ s to）


# 一、GC与内存分代收集算法

>* JVM里的GC(Garbage Collection)的算法有很多种，现在比较常用的是分代收集（generational collection,也是SUN VM使用的,J2SE1.2之后引入），即将内存分为几个区域，将不同生命周期的对象放在不同区域里:young generation，tenured generation和permanet generation。
>* 绝大部分的objec被分配在young generation(生命周期短)，并且大部分的object在这里die。
>* 当young generation满了之后，将引发minor collection(YGC)。在minor collection后存活的object会被移动到tenured generation(生命周期比较长)。
>* 最后，tenured generation满之后触发major collection。major collection（Full gc）会触发整个heap的回收，包括回收young generation。permanet generation区域比较稳定，主要存放classloader信息。



一个E区，两个S区（S1 S2）
>* young generation有eden、2个survivor 区域组成。其中一个survivor区域一直是空的，是eden区域和另一个survivor区域在下一次copy collection后活着的objecy的目的地。object在survivo区域被复制直到转移到tenured区。
>* 我们要尽量减少 Full gc 的次数(tenured generation 一般比较大,收集的时间较长,频繁的Full gc会导致应用的性能收到严重的影响)。
>* 堆内存GC： JVM(采用分代回收的策略)，用较高的频率对年轻的对象(young generation)进行YGC，而对老对象(tenured generation)较少(tenured generation 满了后才进行)进行Full GC。这样就不需要每次GC都将内存中所有对象都检查一遍。
>* 非堆内存不GC：GC不会在主程序运行期对PermGen Space进行清理，所以如果你的应用中有很多CLASS(特别是动态生成类，当然permgen space存放的内容不仅限于类)的话,就很可能出现PermGen Space错误。

# 二、内存申请、对象衰老过程

## 1、内存申请过程

* 1、JVM会试图为相关Java对象在Eden中初始化一块内存区域；
* 2、当Eden空间足够时，内存申请结束。否则到下一步；
* 3、JVM试图释放在Eden中所有不活跃的对象（minor collection），释放后若Eden空间仍然不足以放入新对象，则试图将部分Eden中活跃对象放入Survivor区；
* 4、Survivor区被用来作为Eden及old的中间交换区域，当OLD区空间足够时，Survivor区的对象会被移到Old区，否则会被保留在Survivor区；
* 5、当old区空间不够时，JVM会在old区进行major collection；
* 6、完全垃圾收集后，若Survivor及old区仍然无法存放从Eden复制过来的部分对象，导致JVM无法在Eden区为新对象创建内存区域，则出现"Out of memory错误"；

## 2、对象衰老过程

新创建的对象的内存都分配自eden。Minor collection的过程就是将eden和在用survivor space（s1）中的活对象copy到空闲survivor space(s2)中。对象在young generation里经历了一定次数(可以通过参数配置)的minor collection后，就会被移到old generation中，称为tenuring。


# 三、GC触发条件

## YGC

### a、GC类型
YGC

### b、触发条件
eden空间不足

### c、触发时发生了什么: 
* 1、清空Eden+from survivor中所有no ref的对象占用的内存
* 2、将eden+from sur中所有存活的对象copy到to sur中
* 3、一些对象将晋升到old中:to sur放不下的存活次数超过turning threshold中的
* 4、重新计算tenuring threshold(serial parallel GC会触发此项)
* 5、重新调整Eden 和from的大小(parallel GC会触发此项)

### d、注意
* 全过程暂停应用
* 是否为多线程处理由具体的GC决定

### e、查看方式
* jstat –gc 进程ID 间隔时间


## FGC

### a、GC类型

FGC

### b、触发条件
* old空间不足
* perm空间不足
* 显示调用System.GC, RMI等的定时触发
* YGC时的悲观策略
* dump live的内存信息时(jmap –dump:live)

### c、触发时发生了什么
* 清空heap中no ref的对象
* permgen中已经被卸载的classloader中加载的class信息
* 如配置了CollectGenOFirst,则先触发YGC(针对serial GC)
* 如配置了ScavengeBeforeFullGC,则先触发YGC(针对serial GC)

### d、注意
* 全过程暂停应用
* 是否为多线程处理由具体的GC决定
* 是否压缩需要看配置的具体GC

### e、查看方式
jstat –gc 进程ID 间隔时间


> permanent generation空间不足会引发Full GC,仍然不够会引发PermGen Space错误。

# 四、JVM参数设置优化

不管是YGC还是Full GC,GC过程中都会对导致程序运行中中断,正确的选择不同的GC策略,调整JVM、GC的参数，可以极大的减少由于GC工作，而导致的程序运行中断方面的问题，进而适当的提高Java程序的工作效率。

JVM参数的含义:

## -Xms
* 初始堆大小
* 默认值:物理内存的1/64(<1GB)
* 默认(MinHeapFreeRatio参数可以调整)空余堆内存小于40%时，JVM就会增大堆直到-Xmx的最大限制.

## -Xmx

* 最大堆大小
* 默认值:物理内存的1/4(<1GB)
* 默认(MaxHeapFreeRatio参数可以调整)空余堆内存大于70%时，JVM会减少堆直到 -Xms的最小限制

## -XX:NewSize
设置年轻代大小(for 1.3/1.4)

## -XX:MaxNewSize
年轻代最大值(for 1.3/1.4)

## -XX:PermSize
* 设置持久代(perm gen)初始值
* 默认值:物理内存的1/64

## -XX:MaxPermSize
* 设置持久代最大值
* 默认值：物理内存的1/4

## -Xss
* 每个线程的堆栈大小
* JDK5.0以后每个线程堆栈大小为1M,以前每个线程堆栈大小为256K.更具应用的线程所需内存大小进行 调整.在相同物理内存下,减小这个值能生成更多的线程.但是操作系统对一个进程内的线程数还是有限制的,不能无限生成,经验值在3000~5000左右
* 一般小的应用， 如果栈不是很深， 应该是128k够用的 大的应用建议使用256k。这个选项对性能影响比较大，需要严格的测试。（校长）
* 和threadstacksize选项解释很类似,官方文档似乎没有解释,在论坛中有这样一句话:"-Xss is translated in a VM flag named ThreadStackSize” 
* 一般设置这个值就可以了。

## -XX:ThreadStackSize

* Thread Stack Size
* (0 means use default stack size) [Sparc: 512; Solaris x86: 320 (was 256 prior in 5.0 and earlier); Sparc 64 bit: 1024; Linux amd64: 1024 (was 0 in 5.0 and earlier); all others 0.]

## -XX:NewRatio

* 年轻代(包括Eden和两个Survivor区)与年老代的比值(除去持久代)
* -XX:NewRatio=4表示年轻代与年老代所占比值为1:4,年轻代占整个堆栈的1/5
* Xms=Xmx并且设置了Xmn的情况下，该参数不需要进行设置。

## -XX:SurvivorRatio

* Eden区与Survivor区的大小比值
* 设置为8,则两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10

## -XX:LargePageSizeInBytes
* 内存页的大小不可设置过大， 会影响Perm的大小
* =128m

## -XX:+UseFastAccessorMethods
* 原始类型的快速优化

## -XX:+DisableExplicitGC
* 关闭System.gc()
* 这个参数需要严格的测试

## -XX:MaxTenuringThreshold

* 垃圾最大年龄
* 如果设置为0的话,则年轻代对象不经过Survivor区,直接进入年老代. 对于年老代比较多的应用,可以提高效率.如果将此值设置为一个较大值,则年轻代对象会在Survivor区进行多次复制,这样可以增加对象再年轻代的存活 时间,增加在年轻代即被回收的概率
* 该参数只有在串行GC时才有效.

## -XX:+AggressiveOpts

* 加快编译

## -XX:+UseBiasedLocking
* 锁机制的性能改善

## -Xnoclassgc
* 禁用垃圾回收

## -XX:SoftRefLRUPolicyMSPerMB
* 每兆堆空闲空间中SoftReference的存活时间
* 默认：1s
* softly reachable objects will remain alive for some amount of time after the last time they were referenced. The default value is one second of lifetime per free megabyte in the heap

## -XX:PretenureSizeThreshold
* 对象超过多大是直接在旧生代分配
* 默认：0
* 单位字节 新生代采用Parallel Scavenge GC时无效
* 另一种直接在旧生代分配的情况是大的数组对象,且数组中无外部引用对象.

## -XX:TLABWasteTargetPercent

* TLAB占eden区的百分比
* 默认：1%

## -XX:+CollectGen0First
* FullGC时是否先YGC
* false

# 五、并行收集器相关参数

## -XX:+UseParallelGC

* Full GC采用parallel MSC(此项待验证)
* 选择垃圾收集器为并行收集器.此配置仅对年轻代有效.即上述配置下,年轻代使用并发收集,而年老代仍旧使用串行收集.(此项待验证)

## -XX:+UseParNewGC
* 设置年轻代为并行收集
* 可与CMS收集同时使用
* JDK5.0以上,JVM会根据系统配置自行设置,所以无需再设置此值


## -XX:ParallelGCThreads
* 并行收集器的线程数
* 此值最好配置与处理器数目相等 同样适用于CMS

## -XX:+UseParallelOldGC
* 年老代垃圾收集方式为并行收集(Parallel Compacting)
* 这个是JAVA 6出现的参数选项


## -XX:MaxGCPauseMillis
* 每次年轻代垃圾回收的最长时间(最大暂停时间)
* 如果无法满足此时间,JVM会自动调整年轻代大小,以满足此值.

## -XX:+UseAdaptiveSizePolicy
* 自动选择年轻代区大小和相应的Survivor区比例
* 设置此选项后,并行收集器会自动选择年轻代区大小和相应的Survivor区比例,以达到目标系统规定的最低相应时间或者收集频率等,此值建议使用并行收集器时,一直打开.

## -XX:GCTimeRatio

* 设置垃圾回收时间占程序运行时间的百分比


## -XX:+ScavengeBeforeFullGC
* Full GC前调用YGC
* 默认值：true
* Do young generation GC prior to a full GC. (Introduced in 1.4.1.)

# 六、CMS相关参数

## -XX:+UseConcMarkSweepGC
* 使用CMS内存收集
* 测试中配置这个以后,-XX:NewRatio=4的配置失效了,原因不明.所以,此时年轻代大小最好用-Xmn设置.???

## -XX:+AggressiveHeap
* 试图是使用大量的物理内存
* 长时间大内存使用的优化，能检查计算资源（内存， 处理器数量）
* 至少需要256MB内存
* 大量的CPU／内存， （在1.4.1在4CPU的机器上已经显示有提升）



## -XX:CMSFullGCsBeforeCompaction
* 多少次后进行内存压缩
* 由于并发收集器不对内存空间进行压缩,整理,所以运行一段时间以后会产生"碎片",使得运行效率降低.此值设置运行多少次GC以后对内存空间进行压缩,整理.


## -XX:+CMSParallelRemarkEnabled
* 降低标记停顿

## -XX+UseCMSCompactAtFullCollection
* 在FULL GC的时候， 对年老代的压缩
* CMS是不会移动内存的， 因此， 这个非常容易产生碎片， 导致内存不够用， 因此， 内存的压缩这个时候就会被启用。 增加这个参数是个好习惯。
* 可能会影响性能,但是可以消除碎片


## -XX:+UseCMSInitiatingOccupancyOnly
* 使用手动定义初始化定义开始CMS收集
* 禁止hostspot自行触发CMS GC

## -XX:CMSInitiatingOccupancyFraction=70
* 使用cms作为垃圾回收使用70％后开始CMS收集
* 默认值：92
* 为了保证不出现promotion failed(见下面介绍)错误,该值的设置需要满足以下公式CMSInitiatingOccupancyFraction计算公式


## -XX:CMSInitiatingPermOccupancyFraction
* 设置Perm Gen使用到达多少比率时触发
* 默认值：92

## -XX:+CMSIncrementalMode
* 设置为增量模式
* 用于单CPU情况

## -XX:+CMSClassUnloadingEnabled


# 七、辅助信息

## -XX:+PrintGC
* 输出形式:
* [GC 118250K->113543K(130112K), 0.0094143 secs]
* [Full GC 121376K->10414K(130112K), 0.0650971 secs]

## -XX:+PrintGCDetails
* 输出形式:[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs]
* [GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K->10414K(130112K), 0.0436268 secs]

## -XX:+PrintGCTimeStamps

## -XX:+PrintGC:PrintGCTimeStamps
* 可与-XX:+PrintGC -XX:+PrintGCDetails混合使用
* 输出形式:11.851: [GC 98328K->93620K(130112K), 0.0082960 secs]

## -XX:+PrintGCApplicationStoppedTime
* 打印垃圾回收期间程序暂停的时间.可与上面混合使用
* 输出形式:Total time for which application threads were stopped: 0.0468229 seconds

## -XX:+PrintGCApplicationConcurrentTime
* 打印每次垃圾回收前,程序未中断的执行时间.可与上面混合使用
* 输出形式:Application time: 0.5291524 seconds

## -XX:+PrintHeapAtGC
* 打印GC前后的详细堆栈信息

## -Xloggc:filename
* 把相关日志信息记录到文件以便分析.
* 与上面几个配合使用


## -XX:+PrintClassHistogram
* garbage collects before printing the histogram.

## -XX:+PrintTLAB
* 查看TLAB空间的使用情况

## XX:+PrintTenuringDistribution
* 查看每次minor GC后新的存活周期的阈值
* Desired survivor size 1048576 bytes, new threshold 7 (max 15)
* new threshold 7即标识新的存活周期的阈值为7。

# 八、其他
对于GC的性能主要有2个方面的指标：吞吐量throughput（工作时间不算gc的时间占总的时间比）和暂停pause（gc发生时app对外显示的无法响应）。

## 1.Total Heap
> 默认情况下，vm会增加/减少heap大小以维持free space在整个vm中占的比例，这个比例由MinHeapFreeRatio和MaxHeapFreeRatio指定。

一般而言，server端的app会有以下规则：

* 对vm分配尽可能多的memory；
* 将Xms和Xmx设为一样的值。如果虚拟机启动时设置使用的内存比较小，这个时候又需要初始化很多对象，虚拟机就必须重复地增加内存。
* 处理器核数增加，内存也跟着增大。

## 2、The Young Generation

>* 另外一个对于app流畅性运行影响的因素是young generation的大小。young generation越大，minor collection越少；但是在固定heap size情况下，更大的young generation就意味着小的tenured generation，就意味着更多的major collection(major collection会引发minor collection)。
>* NewRatio反映的是young和tenured generation的大小比例。NewSize和MaxNewSize反映的是young generation大小的下限和上限，将这两个值设为一样就固定了young generation的大小（同Xms和Xmx设为一样）。
>* 如果希望，SurvivorRatio也可以优化survivor的大小，不过这对于性能的影响不是很大。SurvivorRatio是eden和survior大小比例。

一般而言，server端的app会有以下规则：
* 首先决定能分配给vm的最大的heap size，然后设定最佳的young generation的大小；
* 如果heap size固定后，增加young generation的大小意味着减小tenured generation大小。让tenured generation在任何时候够大，能够容纳所有live的data（留10%-20%的空余）。

# 九、最佳实践


## 1、年轻代大小选择

* 响应时间优先的应用:尽可能设大,直到接近系统的最低响应时间限制(根据实际情况选择).在此种情况下,年轻代收集发生的频率也是最小的.同时,减少到达年老代的对象.
* 吞吐量优先的应用:尽可能的设置大,可能到达Gbit的程度.因为对响应时间没有要求,垃圾收集可以并行进行,一般适合8CPU以上的应用.
* 避免设置过小.当新生代设置过小时会导致:1.YGC次数更加频繁 2.可能导致YGC对象直接进入旧生代,如果此时旧生代满了,会触发FGC.

## 2、年老代大小选择
* 响应时间优先的应用:年老代使用并发收集器,所以其大小需要小心设置,一般要考虑并发会话率和会话持续时间等一些参数.如果堆设置小了,可以会造成内存碎 片,高回收频率以及应用暂停而使用传统的标记清除方式;如果堆大了,则需要较长的收集时间.最优化的方案,一般需要参考以下数据获得:
* 并发垃圾收集信息、持久代并发收集次数、传统GC信息、花在年轻代和年老代回收上的时间比例。
* 吞吐量优先的应用:一般吞吐量优先的应用都有一个很大的年轻代和一个较小的年老代.原因是,这样可以尽可能回收掉大部分短期对象,减少中期的对象,而年老代尽存放长期存活对象.

## 3、较小堆引起的碎片问题
* 因为年老代的并发收集器使用标记,清除算法,所以不会对堆进行压缩.当收集器回收时,他会把相邻的空间进行合并,这样可以分配给较大的对象.但是,当堆空间较小时,运行一段时间以后,就会出现"碎片",如果并发收集器找不到足够的空间,那么并发收集器将会停止,然后使用传统的标记,清除方式进行回收.如果出现"碎片",可能需要进行如下配置:
* -XX:+UseCMSCompactAtFullCollection:使用并发收集器时,开启对年老代的压缩.
* -XX:CMSFullGCsBeforeCompaction=0:上面配置开启的情况下,这里设置多少次Full GC后,对年老代进行压缩

## 4、

用64位操作系统，Linux下64位的jdk比32位jdk要慢一些，但是吃得内存更多，吞吐量更大

## 5、

XMX和XMS设置一样大，MaxPermSize和MinPermSize设置一样大，这样可以减轻伸缩堆大小带来的压力

## 6、

使用CMS的好处是用尽量少的新生代，经验值是128M－256M， 然后老生代利用CMS并行收集， 这样能保证系统低延迟的吞吐效率。 实际上cms的收集停顿时间非常的短，2G的内存， 大约20－80ms的应用程序停顿时间

## 7、

系统停顿的时候可能是GC的问题也可能是程序的问题，多用jmap和jstack查看，或者killall -3 java，然后查看java控制台日志，能看出很多问题。(相关工具的使用方法将在后面的blog中介绍)

## 8、
仔细了解自己的应用，如果用了缓存，那么年老代应该大一些，缓存的HashMap不应该无限制长，建议采用LRU算法的Map做缓存，LRUMap的最大长度也要根据实际情况设定。

## 9、
采用并发回收时，年轻代小一点，年老代要大，因为年老大用的是并发回收，即使时间长点也不会影响其他程序继续运行，网站不会停顿，JVM参数的设置(特别是 –Xmx –Xms –Xmn -XX:SurvivorRatio   -XX:MaxTenuringThreshold等参数的设置没有一个固定的公式，需要根据PV old区实际数据     

## 10、
YGC次数等多方面来衡量。为了避免promotion faild可能会导致xmn设置偏小，也意味着YGC的次数会增多，处理并发访问的能力下降等问题。每个参数的调整都需要经过详细的性能测试，才能找到特定应用的最佳配置。


