# guava之ImmutableMap使用实例及好处


## 概述

ImmutableMap 的作用就是：可以让java代码也能够创建一个对象常量映射，来保存一些常量映射的键值对。

不可变集合，顾名思义就是说集合是不可被修改的。集合的数据项是在创建的时候提供，并且在整个生命周期中都不可改变。

为什么要用immutable对象？immutable对象有以下的优点：
1.对不可靠的客户代码库来说，它使用安全，可以在未受信任的类库中安全的使用这些对象
2.线程安全的：immutable对象在多线程下安全，没有竞态条件
3.不需要支持可变性, 可以尽量节省空间和时间的开销. 所有的不可变集合实现都比可变集合更加有效的利用内存 (analysis)
4.可以被使用为一个常量，并且期望在未来也是保持不变的

immutable对象可以很自然地用作常量，因为它们天生就是不可变的对于immutable对象的运用来说，它是一个很好的防御编程（defensive programming）的技术实践。



## 例子一

```
import com.google.common.collect.ImmutableMap;  
  
import java.util.Map;  
  
/** 
 * 定义一些常量Map<?,?> 
 * <p> 
 * Created by lxk on 2016/11/17 
 */  
interface ConstantMap {  
    Map<Integer, String> INTEGER_STRING_MAP =  
            new ImmutableMap.Builder<Integer, String>().  
  
                    put(30, "IP地址或地址段").  
                    put(31, "端口号或范围").  
                    put(32, "IP地址或地址段").  
                    put(33, "端口号或范围").  
                    put(34, "代码值").  
                    put(38, "探针名称").  
                    put(39, "网络协议号(protocol)").  
                    put(40, "ipv6源IP(ipv6_src_addr)").  
                    put(41, "ipv6目标IP(ipv6_dst_addr)").  
                    put(42, "网络协议名称(protocol_map)").  
                    put(43, "输入接口snmp(input_snmp)")  
  
                    .build();  
}  
  
/** 
 * guava ImmutableMap 测试实例 
 * <p> 
 * Created by lxk on 2016/11/14 
 */  
public class ImmutableMapTest {  
    public static void main(String[] args) {  
        immutableMapTest();  
    }  
  
    /** 
     * 测试 guava ImmutableMap 
     */  
    private static void immutableMapTest() {  
        Integer key = 30;  
        System.out.println("key = " + key + "的提示语是：" + ConstantMap.INTEGER_STRING_MAP.get(key));  
    }  
} 
```

## 例子二

```

/**
 * 带区间的常用数值定义
 *
 */
public class RentValueBlock {
    /**
     * 价格区间定义
     */
    public static final Map<String, RentValueBlock> PRICE_BLOCK;

    /**
     * 面积区间定义
     */
    public static final Map<String, RentValueBlock> AREA_BLOCK;

    /**
     * 无限制区间
     */
    public static final RentValueBlock ALL = new RentValueBlock("*", -1, -1);

    static {
        PRICE_BLOCK = ImmutableMap.<String, RentValueBlock>builder()
                .put("*-1000", new RentValueBlock("*-1000", -1, 1000))
                .put("1000-3000", new RentValueBlock("1000-3000", 1000, 3000))
                .put("3000-*", new RentValueBlock("3000-*", 3000, -1))
                .build();

        AREA_BLOCK = ImmutableMap.<String, RentValueBlock>builder()
                .put("*-30", new RentValueBlock("*-30", -1, 30))
                .put("30-50", new RentValueBlock("30-50", 30, 50))
                .put("50-*", new RentValueBlock("50-*", 50, -1))
                .build();
    }

    private String key;
    private int min;
    private int max;

    public RentValueBlock(String key, int min, int max) {
        this.key = key;
        this.min = min;
        this.max = max;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public int getMin() {
        return min;
    }

    public void setMin(int min) {
        this.min = min;
    }

    public int getMax() {
        return max;
    }

    public void setMax(int max) {
        this.max = max;
    }

    public static RentValueBlock matchPrice(String key) {
        RentValueBlock block = PRICE_BLOCK.get(key);
        if (block == null) {
            return ALL;
        }
        return block;
    }

    public static RentValueBlock matchArea(String key) {
        RentValueBlock block = AREA_BLOCK.get(key);
        if (block == null) {
            return ALL;
        }
        return block;
    }
}
```